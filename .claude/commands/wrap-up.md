---
description: Fecho de sessêo iAmasters OS. Gera daily summary, sincroniza skills, propõe commit.
---

# /wrap-up

Invoca a skill `meta-wrap-up` que vive em `.claude/skills/_meta/meta-wrap-up/SKILL.md`.

## O que faz

1. Recapitula a sessêo (o que se fez, o que ficou)
2. Sincroniza `synapsis/skills-catalog.json` se houve mudanças em `.claude/skills/`
3. Atualiza o skills registry do `CLAUDE.md`
4. Append em `context/learnings.md` se houve aprendizagens
5. Gera/atualiza `synapsis/daily-summaries/<TODAY>.md`
6. Deteta projetos a arquivar (status: done > 7 dias)
7. Propõe Git commit (espera aprovaçêo)
8. Sugere `/eod` Sinapsis se é fim do dia

## Comando

Carrega e invoca a skill `meta-wrap-up`. Segue o processo do SKILL.md passo a passo.

NêO faz push automático nem commit sem aprovaçêo explícita.
