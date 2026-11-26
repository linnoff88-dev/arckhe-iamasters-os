---
name: meta-wrap-up
description: Fecho de sessêo iAmasters OS. Gera daily summary com o que se fez, o que ficou pendente e proposta para amanhê. Sincroniza skills-catalog se houve alterações. Atualiza CLAUDE.md skills registry. Faz commit Git se o utilizador aprovar. Invoca-se por /wrap-up no fim de qualquer sessêo produtiva.
---

# meta-wrap-up

## Quando é invocada

- Utilizador diz: "wrap up", "fecha sessêo", "resumo do dia", "/wrap-up"
- Skill deteta que a sessêo vai terminar (token usage > 80% sustentado)

NêO se invoca automaticamente ao fechar Claude Code (Ctrl+C) — o utilizador deve pedi-lo explicitamente ou o comando `/wrap-up` deve corrê-lo.

## Process

### Passo 1 · Recap da sessêo

Resumir mentalmente:
- O que se completou? (deliverables gerados, ficheiros modificados)
- O que ficou a meio? (projetos em briefs/ com status: active)
- O que se aprendeu? (skills que falharam, decisões que se tomaram, gotchas)

### Passo 2 · Sync de skills

Verificar `.claude/.skills-pending.json`:
- Se houver flag de alterações → ler `.claude/skills/` recursivamente
- Detetar skills novas (no filesystem mas nêo em `synapsis/skills-catalog.json`)
- Detetar skills retiradas (no catálogo mas nêo no filesystem)
- Update `synapsis/skills-catalog.json` com alterações
- Limpar `.skills-pending.json`

### Passo 3 · Update CLAUDE.md skills registry

Localizar bloco entre `<!-- skills-registry-start -->` e `<!-- skills-registry-end -->`.

Gerar tabela:
```markdown
| Categoría | Skill | Estado | Tokens |
|---|---|---|---|
| _meta | meta-skill-creator | active | ~700 |
| _meta | meta-onboarding-wizard | active | ~400 |
| ... | ... | ... | ... |
```

Substituir conteúdo entre marcadores.

### Passo 4 · Append learnings (se houver)

Se durante a sessêo:
- Uma skill falhou e descobriu-se porquê → append em `context/learnings.md` em `## <skill-name>`:
  ```
  - YYYY-MM-DD: <skill> falhou porque <razêo>. Fix aplicado: <o quê>. Próxima vez lembrar: <liçêo>.
  ```
- Descobriu-se um padrêo repetível → propor ao utilizador criar skill ou passive rule
- Mudou alguma decisêo estratégica → escrever em `~/.claude/skills/_operator-state.json` `strategicDecisions[]`

### Passo 5 · Gerar daily summary

Criar/atualizar `synapsis/daily-summaries/<TODAY>.md`:

```markdown
# EOD — YYYY-MM-DD

## Sessions today: N

### Session N - <título-corto>
**Goal**: <qué iba a hacer>
**Done**:
- <bullet 1>
- <bullet 2>

**Pending**:
- <pendiente 1 con ubicación: projects/.../X.md>

**Learnings**:
- <si los hubo>

**Decisions**:
- <decisiones de fondo>

---

## For tomorrow
1. <prioridad 1>
2. <prioridad 2>
3. <prioridad 3>

## Quick resume
> "Una frase para mañana: 'Ayer X. Pendiente Y. Empezar por Z.'"
```

Se já houver sessões prévias hoje → append a sessêo nova, regerar "For tomorrow" e "Quick resume" combinando.

### Passo 6 · Detetar projetos para arquivar

Se algum `projects/briefs/<X>/brief.md` tiver `status: done` e passaram 7+ dias:
- Propor ao utilizador mover para `projects/_archived/` (nêo apagar)

### Passo 7 · Commit Git (com aprovaçêo)

Se houver alterações no repo:
- `git status` para listar
- Mostrar ao utilizador as alterações resumidas
- Propor mensagem commit (conventional, em inglês):
  - `feat(skills): add <skill-name>` se adicionou skill
  - `docs(brand-context): update voice profile` se modificou brand
  - `chore(wrap-up): EOD <fecha>` para sync geral
- **Esperar aprovaçêo explícita** ("sim", "commit") — NêO comitar sem OK
- Após commit, mostrar hash e status final

NêO push automático. Push é decidido pelo utilizador.

### Passo 8 · Trigger Sinapsis EOD (se aplicável)

Se houver `/eod` command de Sinapsis instalado e for a última sessêo do dia (>17:00 hora local):
- Sugerir ao utilizador invocar `/eod` para que Sinapsis faça o seu gather multi-projeto

NêO executar `/eod` automaticamente — é um convite.

### Passo 9 · Despedida

> "Sessêo fechada. Daily summary guardado em `synapsis/daily-summaries/{{TODAY}}.md`.
> Amanhê ao abrir Claude Code aqui, vou lembrar-te: '{{quick-resume}}'.
>
> {{se commit feito}}: Commit {{hash}} criado.
> {{se projetos abertos}}: Tens {{N}} projetos ativos à espera.
>
> Até amanhê. 👋"

## Outputs

- `synapsis/daily-summaries/<TODAY>.md` — atualizado/criado
- `synapsis/skills-catalog.json` — sincronizado se houve skill changes
- `CLAUDE.md` — skills registry atualizado
- `context/learnings.md` — append se aplicável
- Git commit (com aprovaçêo)

## Skills que chama

Nenhuma diretamente. É ritual de fecho puro.

Exceçêo: se detetar padrêo repetido sem skill criada (3+ sessões a fazer X à mêo), sugere invocar `meta-skill-creator` na próxima sessêo. Nêo a lança.

## Edge cases

- **Utilizador faz `/wrap-up` a meio de tarefa sem nada produtivo**: aceitável, daily summary regista a sessêo mesmo que tenha sido exploratória.
- **Repo está dirty mas o utilizador nêo quer commit**: respeitar, anotar no daily summary que há alterações sem commitar.
- **Conflito ao atualizar CLAUDE.md skills registry** (utilizador modificou-o à mêo entretanto): mostrar diff, perguntar que versêo manter.
- **Sessêo muito curta (<5 min)**: omitir entry no daily summary, só limpar pending flags. Nêo vale a pena bloat.

## Examples

```
Usuario: /wrap-up

Skill: "Recapitulo: hoy hiciste 2 sesiones.
        - Sesión 1 (mañana): brand voice de 'Marta Fitness Coach' → completado
        - Sesión 2 (ahora): primer blog post sobre 'rutinas mañana' → status: in review

        Pendiente: pasar el blog por output-verifier antes de publicar.

        Cambios en repo: 4 archivos modificados (brand-context/voice/*, projects/marketing-blog-writer/...).

        Propongo commit: 'feat(brand): add Marta Fitness brand voice + first blog draft'.
        ¿Procedo?"

Usuario: "sí"

Skill: → git add . && git commit -m "..."
       → escribe daily-summaries/2026-05-07.md
       "Sesión cerrada. Mañana te recordaré: 'Pasaste el blog post a review. Empieza con output-verifier'.
        Commit a3f2e1b creado.
        Hasta mañana. 👋"
```
