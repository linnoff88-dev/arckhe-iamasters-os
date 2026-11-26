---
name: meta-start-here
description: Ritual de início de sessêo para o iAmasters OS. Carrega o contexto necessário (operator-state, user.md, daily summary, learnings, projetos abertos), recapitula ao operador o que deixou pendente, e propõe tarefa do dia. Invoca-se no primeiro turno de cada sessêo, automaticamente ou por /start-here.
---

# meta-start-here

## Quando é invocada

- Primeira mensagem de qualquer sessêo (Claude lê `CLAUDE.md` e deteta esta skill como ritual de entrada)
- Utilizador invoca `/start-here` explicitamente (slash command)
- Outra skill deteta deriva (ex: `meta-onboarding-wizard` finaliza e deriva para aqui)

## Process

### Passo 1 · Detetar estado do repo

Lê por esta ordem:

1. `~/.claude/skills/_operator-state.json`
   - Existe? `needsOnboarding: true`? → derivar para `meta-onboarding-wizard`
   - `deepDiveCompleted: false` e passaram >12h desde `onboardingDate`? → marca flag interna `suggestDeepDive: true` (nêo derives — só lembra no cumprimento, ver Passo 4)
2. `context/me.md` (ou `context/user.md` legacy)
   - Está vazio ou por preencher? → derivar para `meta-onboarding-wizard`
3. `brand-context/voice/voice-profile.md`
   - Nêo existe ou vazio? → sugere executar `marketing-brand-voice`

### Passo 2 · Carregar continuidade

Lê `synapsis/daily-summaries/<TODAY>.md` ou `<YESTERDAY>.md`:
- Se houver → resumir o "For tomorrow" numa linha
- Se nêo → primeira sessêo do dia

Lê `context/learnings.md` (se > 200 chars):
- Identificar a última liçêo adicionada

Lê `synapsis/projects.json` (Sinapsis):
- Filtrar projetos com `status: active`
- Listar no máximo 3 mais recentes

Lê `projects/briefs/*/brief.md`:
- Filtrar os que tenham YAML frontmatter `status: active` ou `phase: in-progress`

### Passo 3 · Sincronizar skills detetadas

Verifica se há `.claude/.skills-pending.json` (criado pelo hook `skill-change-detector.sh`):
- Se sim → atualizar `synapsis/skills-catalog.json` com as skills novas
- Limpar a flag

### Passo 4 · Cumprimento contextual

Construir cumprimento conforme contexto detetado:

**Se houver daily summary de ontem:**
> "Olá {{nome}}. Ontem fechaste com: {{summary}}.
> Para hoje propunhas: {{for-tomorrow}}.
> Continuas com isso, ou mudamos?"

**Se houver projeto ativo mas sem daily summary:**
> "Olá {{nome}}. Tens o projeto **{{nome-projeto}}** aberto na fase {{fase}}.
> Continuas com ele ou vamos a outra coisa?"

**Se nêo houver nada ativo:**
> "Olá {{nome}}. Em que te ajudo hoje?
>
> [1] Criar conteúdo (skills marketing-*)
> [2] Trabalhar com um cliente (`/add-client` ou `cd clients/<x>`)
> [3] Análise estratégica (skills strategy-*)
> [4] Tarefa livre — diz-me o que precisas"

### Passo 4.5 · Lembrete de deep-dive (se aplicável)

Se no Passo 1 ficou `suggestDeepDive: true`, adiciona no fim do cumprimento (nêo antes — o cumprimento principal vai primeiro):

```
PS: ainda nêo completaste o deep-dive do onboarding. O sistema
conhece-te superficialmente. Quando tiveres 25 minutos, executa `/deep-dive`
e refinamos.
```

Este lembrete é mostrado **cada vez** que o operador arranca, até `deepDiveCompleted: true`. Nêo é intrusivo (só 1 linha), mas lembra.

Se o operador já completou o deep-dive (`deepDiveCompleted: true`), nêo mencionar nada.

### Passo 5 · Se houver pending tasks de Sinapsis

Sinapsis pode ter instincts em draft pendentes de promote. Se em `~/.claude/skills/_instincts-index.json` houver 5+ drafts com `occurrences >= 3`:
- Mencionar no fim do cumprimento: "(Tens 5 instincts prontos para rever com `/analyze-session` quando quiseres)"

### Passo 6 · Nêo fazer mais

Importante: este ritual NêO executa tarefas. Só carrega contexto e propõe.
- Se o utilizador respondeu à pergunta colocada → continua com a tarefa concreta (outra skill ou açêo direta).
- Se nêo → espera input.

## Outputs

- Mensagem ao utilizador com resumo + proposta
- Update interno: `synapsis/skills-catalog.json` se houve skill changes pending

## Skills que chama

- **`meta-onboarding-wizard`** — se detetar primeiro arranque
- **`marketing-brand-voice`** — opcionalmente se faltar voice profile

## Skills que sugere (sem invocar automaticamente)

- **`meta-deep-dive`** — se o operador completou o wizard inicial mas nêo o deep-dive (mostrado como PS no fim do cumprimento, lembrete diário até que se complete)

## Edge cases

- **Nêo há `.claude/skills/`**: o repo está corrompido ou mal instalado. Avisa o utilizador e sugere `bash scripts/install.sh`.
- **`operator-state.json` corrompido (JSON mal formado)**: recuperar de backup em `~/.claude/_backup_*` ou derivar para re-onboarding.
- **Daily summary de há 5+ dias**: melhor começar limpo do que arrastar contexto stale. Cumprimentar como nova sessêo.

## Examples

**Caso 1 · Continuidade calorosa:**
```
Operador: (abre Claude Code à segunda-feira)
Skill: "Olá Marta. Sexta-feira fechaste com o blog post de Stripe billing (status: pending review).
        Para hoje propunhas: 'passá-lo pelo output-verifier e publicar'.
        Continuas com isso?"
```

**Caso 2 · Sem atividade recente:**
```
Operador: (abre depois de 5 dias sem abrir)
Skill: "Olá Marta. Há algum tempo. Em que te ajudo hoje?
        [1] Criar conteúdo
        [2] Trabalhar com um cliente (tens 3: Acme, ContoSL, NorthStar)
        [3] Análise estratégica
        [4] Tarefa livre"
```

**Caso 3 · Primeiro arranque após instalaçêo:**
```
Skill: → deteta needsOnboarding: true
       → deriva para meta-onboarding-wizard
       (nêo mostra cumprimento próprio)
```
