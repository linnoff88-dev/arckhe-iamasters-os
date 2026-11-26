#!/bin/bash
# ============================================================
#  iAmasters OS — Install Gate (SessionStart hook)
#  Bloqueia respostas do agente se a instalaçêo estiver incompleta.
#
#  Output: JSON com additionalContext em stdout (formato Claude Code hooks).
#  Comportamento:
#    - Se OS nêo instalado (sem state) → injeta mensagem "instalar primeiro"
#    - Se OS instalado parcial → injeta mensagem "executa /install --resume"
#    - Se OS completo → nêo faz nada (sai 0 sem output)
#
#  Este hook regista-se em ~/.claude/settings.json na secçêo
#  "hooks.SessionStart". Instala-o scripts/install.sh.
# ============================================================

set +e  # Nunca queremos que um hook partido bloqueie a sessêo

STATE_FILE="$HOME/.claude/skills/_install-state.json"

# Se nêo temos node, nêo conseguimos fazer parse do state. Saímos silencioso.
# (Se node nêo está, o Sinapsis também nêo funciona, portanto o OS está partido na mesma.)
if ! command -v node >/dev/null 2>&1; then
    exit 0
fi

# Caso 1: state file NêO existe → OS nêo instalado de todo
if [ ! -f "$STATE_FILE" ]; then
    # Só injetamos o aviso se estivermos dentro de um repo iamasters-os
    # (detetado pela presença de vendor/sinapsis/ + CLAUDE.md com mençêo)
    if [ -d "$PWD/vendor/sinapsis" ] && [ -f "$PWD/CLAUDE.md" ] && grep -q "iAmasters OS" "$PWD/CLAUDE.md" 2>/dev/null; then
        cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"[INSTALL GATE] iAmasters OS detetado neste repo mas NêO instalado (nêo existe ~/.claude/skills/_install-state.json).\n\nAntes de responder ao utilizador:\n1. Indica-lhe claramente: 'iAmasters OS nêo está instalado. Preciso que executes no terminal:\\n\\n   bash scripts/install.sh\\n\\nQuando terminar, volta aqui e retomamos.'\n2. NêO tentes criar ficheiros manualmente para simular a instalaçêo.\n3. NêO reportes que instalaste nada até o state file existir e todas as fases required estarem em 'done'.\n4. Se o utilizador insistir em avançar sem instalar, lembra-o que o sistema nêo funcionará corretamente."}}
EOF
    fi
    exit 0
fi

# Caso 2: state file existe → avaliamos completude
node <<NODE_EOF
try {
  const fs = require('fs');
  const s = JSON.parse(fs.readFileSync('$STATE_FILE', 'utf8'));

  const phases = s.phases || {};
  const required = Object.entries(phases).filter(([k, v]) => v.required === true);
  const pending = required.filter(([k, v]) => v.status !== 'done');

  // Tudo OK: nêo injetamos nada
  if (pending.length === 0) {
    process.exit(0);
  }

  // Há fases pendentes/falhadas: construir mensagem
  const total = required.length;
  const done = total - pending.length;
  const failed = pending.filter(([k, v]) => v.status === 'failed');
  const inProgress = pending.filter(([k, v]) => v.status === 'in-progress');
  const pendingOnly = pending.filter(([k, v]) => v.status === 'pending');

  let context = '[INSTALL GATE] iAmasters OS installation INCOMPLETE.\n';
  context += 'Required phases: ' + done + '/' + total + ' done.\n\n';

  if (failed.length > 0) {
    context += 'FAILED phases (requires fix):\n';
    failed.forEach(([k, v]) => {
      context += '  - ' + k + ' (owner: ' + (v.owner || '?') + ')\n';
    });
    context += '\n';
    if (s.errors && s.errors.length > 0) {
      const lastErr = s.errors[s.errors.length - 1];
      context += 'Last error: ' + lastErr.message + '\n\n';
    }
  }

  if (inProgress.length > 0) {
    context += 'IN-PROGRESS phases (resume from here):\n';
    inProgress.forEach(([k, v]) => {
      context += '  - ' + k + ' (owner: ' + (v.owner || '?') + ')';
      if (v.filesCreated && v.filesCreated.length > 0) {
        context += ' [partial: ' + v.filesCreated.length + ' files created]';
      }
      context += '\n';
    });
    context += '\n';
  }

  if (pendingOnly.length > 0) {
    context += 'PENDING phases:\n';
    pendingOnly.forEach(([k, v]) => {
      context += '  - ' + k + ' (owner: ' + (v.owner || '?') + ')\n';
    });
    context += '\n';
  }

  context += 'BEFORE responding to the user, you MUST:\n';
  context += '1. Acknowledge to the user that installation is incomplete (' + done + '/' + total + ' phases).\n';
  context += '2. Read ~/.claude/skills/_install-state.json with the Read tool to see exact state.\n';
  context += '3. Execute /install --resume to continue from where it stopped.\n';
  context += '4. If the FIRST pending phase is "context-files" or "operator-state", invoke the meta-onboarding-wizard skill directly.\n';
  context += '5. If the FIRST pending phase is "welcome-completed", invoke welcome-quick-win.\n';
  context += '6. NEVER report installation as complete unless the state file confirms all required phases are "done".\n';
  context += '7. NEVER create installation files manually to simulate progress — only the wizard and welcome-quick-win can mark phases done.\n\n';
  context += 'If the user says "stop", "para" or "nêo quero seguir":\n';
  context += '- Mark pausedBy="user" in the state file and pausedAtPhase=<current>.\n';
  context += '- Remind them they can resume anytime with /install --resume.\n';
  context += '- Do NOT pretend the installation is complete.\n';

  const out = {
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: context
    }
  };
  process.stdout.write(JSON.stringify(out));
  process.exit(0);
} catch (e) {
  // State corrupto: avisamos o modelo em vez de crashar silencioso
  const out = {
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: '[INSTALL GATE] ~/.claude/skills/_install-state.json exists but is corrupted (' + e.message + '). Tell the user to run: bash scripts/install.sh --force-reinstall'
    }
  };
  process.stdout.write(JSON.stringify(out));
  process.exit(0);
}
NODE_EOF

exit 0
