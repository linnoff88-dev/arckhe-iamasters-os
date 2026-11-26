# Changelog

Todas as mudanças notáveis ao iAmasters OS documentam-se aqui.

Formato baseado em [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### Próximas versões (em backlog)
- v0.7.0: skills nativas em português (meeting-notes, proposal-writer, youtube-transcript, linkedin-posts) reescritas com voice profile do operador
- v0.8.0: dashboard do OS (a decidir se se integra com o dashboard Sinapsis)
- v1.0.0: release pública estável + vídeos Loom integrados + landing em iamastersacademy.com/os

---

## v0.6.0 — Install Gate · state machine anti-instalaçêo-fantasma (2026-05-15)

> **Porquê esta release**: o primeiro feedback negativo da comunidade reportou uma instalaçêo que parecia completa mas nêo estava — o agente Claude do utilizador tinha criado ficheiros JSON "fantasma" a simular que o Sinapsis se instalou, quando na verdade tinha falhado por causa do Python em Windows. Esta versêo fecha essa porta a nível estrutural: há um state machine persistente, um hook SessionStart que bloqueia respostas se a instalaçêo nêo está completa, e validaçêo profunda em cada fase.

### Added — Install gate com state machine

- **`scripts/_install-state.template.json`** (novo) — template do state machine persistente. Após `install.sh`, vive em `~/.claude/skills/_install-state.json` com 6 fases tipadas: `prereqs`, `sinapsis-engine`, `context-files`, `operator-state`, `welcome-completed`, `deep-dive-completed` (esta última deferrable).
- **`scripts/_install-gate.sh`** (novo) — hook SessionStart em bash + node. Lê o state file e, se houver fases `required: true` nêo `done`, injeta `additionalContext` ao modelo: `"[INSTALL GATE] Installation incomplete. Before responding to the user, you MUST execute /install --resume."`. É enforcement real — a harness executa antes do modelo ver a primeira mensagem, nêo depende da vontade do modelo de ler o CLAUDE.md.
- **`docs/install-state-schema.md`** (novo) — spec completa do schema: estados por fase, contrato de quem escreve o quê, validaçêo de "done", edge cases (sessêo partida a meio, drift, reinstalaçêo).
- **Comandos `/install` e `/install-status`** em `.claude/commands/` — orquestrador reentrante e dashboard read-only. `/install` lê o state, identifica a fase pendente e executa (script bash do terminal se é `prereqs`/`sinapsis-engine`, skill conversacional se é `context-files`/`operator-state`/`welcome-completed`). `--resume` continua de onde ficou. `--force-reinstall` requer confirmaçêo explícita e faz backup do state.

### Changed — `scripts/install.sh` reescrito completo

- **Deteçêo Python multi-plataforma**: tenta `python3` → `py -3` → `python` → `python3.11/12/10` → paths absolutos Windows (`/c/Python311/python.exe` etc.). Resolve o caso típico Windows + Microsoft Store launcher que partia a v0.5.x.
- **Validaçêo profunda do Sinapsis** (funçêo `validate_sinapsis_deep`): nêo se contenta com "o ficheiro existe". Verifica JSON parseable, hooks executáveis (`_passive-activator.sh`, `_session-learner.sh`, etc.), settings.json com secçêo hooks, e contagem ≥1 de `SKILL.md` reais. Se o Sinapsis se instalou mas a validaçêo profunda falha, marca `failed` com detalhe em `errors[]` e aborta.
- **Modo `--resume`**: se o state file existe com fases `done`, salta-as. Continua só desde a primeira nêo completada. Idempotente — executar várias vezes nêo parte nada.
- **Modo `--force-reinstall`**: backup do state atual para `_install-state.<timestamp>.bak`, apaga e arranca limpo.
- **`compute_and_store_checksum`** — guarda hash sha256 dos ficheiros críticos do Sinapsis (`_*.json` + `_*.sh`) no state. `health-check` pode detetar drift posterior comparando.
- **`register_session_start_hook`** — modifica `~/.claude/settings.json` para adicionar o hook SessionStart preservando todos os hooks existentes do Sinapsis (PreToolUse, PostToolUse, Stop, PreCompact). Idempotente: nêo duplica se já está registado.
- **Output estruturado** mantido: `[OK]/[SKIP]/[WARN]/[ERROR]`. Cada fase escreve o seu estado para o state file assim que termina, nêo no fim.

### Changed — `meta-onboarding-wizard` com commits incrementais

- **De entrevista monolítica a 4 sub-fases com commits**. A v0.5 escrevia os 4 ficheiros de `context/` no fim ("Só quando as 8 dimensões têm dado sólido"). A v0.6 escreve cada ficheiro **imediatamente** ao fechar a sua sub-fase:
  - W1 Identidade → `context/me.md` + atualiza state
  - W2 Negócio → `context/work.md` + atualiza state
  - W3 Foco → `context/current-priorities.md` + `context/goals.md` + atualiza state
  - W4 Config técnica → `~/.claude/skills/_operator-state.json` + marca `context-files.status: done` + `operator-state.status: done`
- **Reentrada inteligente**: ao arrancar lê `phases.context-files.filesCreated` e começa na primeira sub-fase com ficheiros pendentes. Se o utilizador fez W1+W2 ontem, hoje retoma em W3 com uma saudaçêo breve, sem repetir a abertura completa.
- **Comportamento perante "para"** definido e persistido: marca `pausedBy: user` com a sub-fase atual, nêo insiste, nêo reporta como completo. Na próxima sessêo o hook deteta e guia para `/install --resume`.
- **Validaçêo pós-commit anti-fantasma**: ao fechar cada sub-fase verifica que o ficheiro escrito existe com >100 chars de conteúdo real. Se a validaçêo falha, NêO marca `done`. Avisa o utilizador e deixa a fase `in-progress`.

### Changed — `health-check` com validaçêo profunda e deteçêo de drift

- **Antes**: verificava presença de ficheiros. **Agora**: faz parse de JSON, valida campos mínimos, executa `test -x` sobre hooks, mede tamanho de ficheiros críticos (`me.md` deve ter >100 chars e `## Nome` com valor real).
- **DRIFT detection** (novo): se o state machine diz que uma fase está `done` mas a validaçêo profunda falha, reporta como 🔴 **STATE DRIFT** e oferece reverter o state para `in-progress` para que o sistema force re-execuçêo. Requer confirmaçêo literal "sim, reverter" — nêo é auto-fix por defeito.
- **Cruzamento com state machine**: a skill agora usa `~/.claude/skills/_install-state.json` como fonte da verdade sobre o que *devia* estar instalado, e compara com o estado real do disco.

### Changed — `CLAUDE.md` do repo

- **Secçêo `⛔ INSTALLATION GATE` no início do documento**, antes de qualquer outra coisa. Impossível de ignorar visualmente. Define o contrato anti-fantasma: nunca criar ficheiros manualmente para simular instalaçêo, nunca reportar `done` sem que o state confirme.
- Movida a secçêo `MANDATORY first action` para *pós-gate*. Adicionada instruçêo explícita de ler planos ativos em `.claude/plans/` (caso do feedback).

### Fixed

- **Deteçêo "Sinapsis já instalada" falso positiva**: a v0.5.x considerava o Sinapsis instalado só com a presença de `_catalog.json` ou `_operator-state.json`. Se o agente do utilizador tinha criado esses ficheiros previamente (caso do feedback), o script saltava a instalaçêo real. Agora valida-se que esses JSON sêo parseable, que os hooks do Sinapsis sêo executáveis e que há pelo menos 1 `SKILL.md` real instalada.

### Migraçêo desde v0.5.x

Para operadores que já tinham a v0.5.x a funcionar:
1. `git pull` para trazer a v0.6.0
2. `bash scripts/install.sh --resume` — o script deteta que o Sinapsis já estava instalado (validaçêo profunda passa), cria o `_install-state.json` retroativamente com `sinapsis-engine.status: done` e `prereqs.status: done`, e regista o hook SessionStart.
3. Se o operator-state já tinha `needsOnboarding: false`, o wizard marca `context-files` e `operator-state` como `done` também — a migraçêo é transparente e nêo parte a instalaçêo existente.

---

## v0.5.2 — Brand Voice v2.0 com dupla rota (2026-05-15)

> **Visêo**: a skill `marketing-brand-voice` capturava bem a voz se o operador tinha presença online (URLs scrapeáveis, posts representativos), mas ficava curta quando alguém nêo tinha arquivo digital ou nêo queria partilhar privados. Esta release integra a mecânica de **Brand Voice Pro** (skill standalone publicada como bónus do lançamento iAmasters Academy 17-mai em `iamasters-academy/brand-voice-pro`), mantendo toda a integraçêo com o ecossistema OS.

### Changed — `marketing-brand-voice` reescrita a v2.0

- **De perguntas teóricas a captura de voz autêntica**. A v1 fazia 6 perguntas sobre o tom (que o operador podia responder de forma idealizada). A v2 incorpora **dupla rota por registo**: artefactos reais ou **15 simulações reais** (5 por cada registo A/B/C) que tiram a voz natural sem que o operador saiba que está a "ser medido".
- **Deteçêo de rota global** ao início (Passo 2). Pergunta-chave: *"És uma pessoa ativa nas redes / escreves muito online?"* → atribui rota artefactos (a), simulaçêo (b) ou híbrida (c) por registo.
- **Validaçêo intermédia** antes de gerar os ficheiros finais (Passo 7). Mostra ao operador a análise detetada por registo + spectrum 0-10 e pede correçêo antes de fechar.
- **Edge case novo**: operador idealiza respostas em simulaçêo. Se no Passo 7 o operador diz "isto nêo sou eu", reformular perguntas pedindo respostas mais autênticas ("responde-me como o farias num sábado às 23h, nêo como gostarias de soar").

### Added — 3 ficheiros novos no output

Output total: 5 → **8 ficheiros** em `brand-context/voice/`:

- **`audit-prompt.md`** *(novo)* — prompt sistema reutilizável para auditar qualquer texto e verificar se está na voz do operador. Devolve pontuaçêo por dimensêo (tom, estrutura, vocabulário, spectrum 0-10) + substituições concretas para anti-voz detetada. Colável como instruçêo de sistema no Claude Project, ChatGPT GEM ou qualquer LLM.
- **`vocabulary.md`** *(novo)* — ficheiro independente com: palavras-assinatura por registo · anti-corporate · anti-hype · anti-genérico de IA · muletas autênticas (as que o operador repete naturalmente e NêO deve eliminar porque sêo parte da sua marca).
- **`installation.md`** *(novo)* — guia multi-sistema para instalar o voice profile no Claude Desktop / Claude Project / ChatGPT GEM / qualquer LLM externo. Permite que o operador use a sua voz fora do OS também.

### Kept — toda a integraçêo OS e a qualidade quantitativa da v1

Mantém-se sem mudanças:

- Firecrawl auto-scraping de URLs (site, LinkedIn, YouTube, X) via `tool-firecrawl-scraper`
- Spectrum 0-10 em 5 dimensões: formality, directness, humor, authority, warmth
- 6 perguntas calibradoras (anti-modelo, modelo aspiracional, frases-assinatura, jargêo próprio, vocabulário proibido, tom dominante)
- Integraçêo com `meta-onboarding-wizard` (invocaçêo após identidade)
- Update do `operator-state.json` com flag `brandVoiceConfigured: true`
- Append a `context/learnings.md` com a entrada do dia
- Edge cases existentes: idioma nêo-castelhano, voice multi-canal, URLs nêo scrapeáveis, sem presença online

### Relaçêo com Brand Voice Pro (repo standalone)

O repo privado [`iamasters-academy/brand-voice-pro`](https://github.com/iamasters-academy/brand-voice-pro) **mantém-se** como produto independente para:

- Bónus da lista prioritária do lançamento iAmasters Academy de 17-mai-2026 (janela 18:00-19:00h)
- Operadores que ainda nêo usam o iAmasters OS e querem a skill desde o ChatGPT GEM ou Claude Project soltos

A v2 dentro do OS adiciona em cima do Brand Voice Pro a **integraçêo com o ecossistema** (Firecrawl + spectrum + onboarding-wizard + learnings + multi-cliente). Quem usa o OS tem a versêo completa.

---

## v0.5.1 — Onboarding profundo e conversacional (2026-05-13)

> **Visêo**: o wizard inicial era um formulário disfarçado de conversa (14 perguntas predefinidas, respostas planas). Esta release converte-o numa entrevista real adaptativa, com aprofundamento dinâmico conforme as respostas. E adiciona uma segunda fase opcional (`meta-deep-dive`) que aprofunda 22-25 dimensões residuais em ~25 min.

### Changed — `meta-onboarding-wizard` reescrita

- **De formulário a entrevista conversacional adaptativa**. Já nêo há perguntas literais no SKILL.md — só **8 dimensões críticas** que o agente cobre dinamicamente.
- **Regras de aprofundamento explícitas**: quando insistir (resposta curta, abstrata, número sem contexto, adjetivo sem exemplo) vs quando passar (resposta rica, fadiga do utilizador, "nêo sei" honesto).
- **Repertório de 6 técnicas conversacionais** em `references/tecnicas-conversacionales.md`: pedir exemplo concreto, 5 whys ligeiro (máx 2 níveis), inversêo, espelho curto, ancoragem temporal, aceitar o "nêo sei".
- **Anti-formulário explícito** documentado: proibido numerar perguntas visíveis ao utilizador, anunciar a próxima pergunta, dupla pergunta por turno, tom terapêutico, emojis durante a entrevista, juízo implícito, validaçêo falsa tipo "que boa pergunta".
- **Definiçêo de "done"** clara por dimensêo em `references/dimensiones-express.md` — cada dimensêo exige dado sólido (nêo genérico, nêo evasivo) antes de fechar o wizard.
- Tempo objetivo do express: 10-12 min (sem mudanças face à versêo anterior, mas agora com info mais valiosa por turno).

### Added — `meta-deep-dive` (skill nova)

- **Segunda fase do onboarding** — opcional mas recomendada no dia seguinte ao wizard inicial.
- Aprofunda **22-25 dimensões residuais** organizadas em 4 blocos:
  - **A · Persona profunda** (7): horário produtivo, interrupções, contexto vital, motivadores profundos, drenadores, estilo de comunicaçêo com IA, palavras/tons proibidos.
  - **B · Negócio profundo** (6): saúde financeira (intervalo), margem, ticket médio, diferencial real, side projects, fricções do modelo.
  - **C · Equipa e clientes** (6, condicional): tamanho equipa, papéis + dinâmica, comunicaçêo interna, delegaçêo, clientes top, clientes problemáticos.
  - **D · Foco profundo** (6): decisêo pendente, meta 3 anos profissional, meta 3 anos vital, medo profissional, métrica semanal, definiçêo pessoal de sucesso.
- **Idempotente**: se o operador para a meio, `operator-state.deepDiveProgress` guarda o avanço. Retoma onde ficou.
- **Branching condicional**: se trabalha sozinho, o bloco equipa reduz-se a 2 dimensões (clientes top + problemáticos).
- **Checkpoints cada 7 dimensões**: oportunidade de pausar sem perder progresso.
- Demora ~25-30 min total.
- Regras de aprofundamento e técnicas conversacionais idênticas ao wizard inicial — `references/tecnicas-conversacionales.md` duplicada para autocontençêo.

### Added — `/deep-dive` (slash command novo)

- Invoca `meta-deep-dive` com deteçêo automática de estado: primeira vez vs retomar vs já completado.
- Avisa se o operador ainda nêo fez o onboarding inicial (redireciona-o para o wizard).

### Changed — `meta-start-here` atualizada

- Deteta `deepDiveCompleted: false` + `onboardingDate > 12h` e mostra **lembrete breve** (1 linha) no fim da saudaçêo diária até o operador completar a deep-dive.
- Nêo é intrusivo: aparece como PS, nêo como bloqueio do flow normal.

### Filosofia v0.5.1

- **A diferença entre output decente e output que parece teu está no contexto que o sistema tem de ti**. Uma entrevista de 14 perguntas planas gera contexto plano. Uma entrevista adaptativa de 30+ perguntas dinâmicas gera contexto que o sistema pode usar para falar como tu.
- **Honestidade sobre o custo de tempo**: o wizard inicial continua a ser ~10 min (nêo inflar o primeiro wow). A deep-dive (~25 min) é opcional, separada, recomendada no dia seguinte.
- **Sem formulários disfarçados**: se o agente acaba a fazer as mesmas perguntas na mesma ordem a todos os operadores, falhámos. A entrevista tem de sentir-se como conversa humana, nêo como tour guiado.

### Counts pós-v0.5.1

| Categoria | v0.5.0 | v0.5.1 |
|---|---:|---:|
| `_meta/` | 9 | **10** (+meta-deep-dive) |
| Resto | 13 | 13 |
| **Total core** | **22** | **23** |
| Opcional | 1 (cognito) | 1 (cognito) |
| Slash commands | 7 | **8** (+`/deep-dive`) |

---

## v0.5.0 — Sistema vivo + skills automation/email/strategy + /aprende (2026-05-13)

> **Visêo**: converter o iAmasters OS num **sistema vivo** que cresce com a comunidade. Fecho do feedback do Fernando Montero sobre v0.4.3 com decisões tomadas explicitamente (vendoreio seletivo, plugins Anthropic via marketplace, comando educativo `/aprende`).

### Added — Skills novas vendorizadas (3, todas MIT com ORIGIN.md)

- **`marketing-email-sequence`** — sequências welcome/nurture/win-back/lifecycle. Vendorizada de [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) (MIT, Corey Haines). Renomeada de `email-sequence` para seguir a convençêo iAmasters OS.
- **`strategy-web-research`** — research profundo multi-fonte com subagentes. Vendorizada de [langchain-ai/deepagents](https://github.com/langchain-ai/deepagents) (MIT, LangChain Inc.). Renomeada de `web-research`.
- **`automation-n8n-to-claude`** — migra workflows n8n/Make para o ecossistema Claude. Vendorizada do catálogo pessoal do Angel Aparicio (iAmasters Automations).

### Added — Skill nova escrita de zero (1)

- **`automation-n8n-builder`** — cria, valida e deploya workflows n8n desde o Claude usando o MCP `n8n-mcp`. Inclui padrões comuns (webhook→processar→notificar, schedule→ler→reportar, etc.) e guardrails sobre quando NêO usar n8n.

### Added — Slash command novo

- **`/aprende`** — tour interativo de 5 dias para alunos que começam de zero. Idempotente via marker em `context/learn-progress.json`. Currículo:
  - **Dia 1**: o que é uma skill, como o Claude as ativa sozinho, demo em direto
  - **Dia 2**: brand context (voice, ICP, positioning) — output pessoal vs genérico
  - **Dia 3**: multi-cliente com `/add-client`
  - **Dia 4**: catálogo (plugins Anthropic, `/install-skill`, `/install-mcp`)
  - **Dia 5**: fluxo end-to-end real (reuniêo → notas → proposta → email)

### Changed — Cognito move para opcional

- **`cognito` movida para `.claude/skills/_meta/_optional/cognito/`**. Nêo se instala automaticamente. Ativa-se com `/install-skill cognito` quando o aluno conhece os fundamentos. Razêo: feedback do Fernando — para alguém que abre o OS pela primeira vez, o cognito é ruído conceptual.
- **`/install-skill`** ampliado: se o argumento NêO é URL mas nome simples (ex. `cognito`), procura em `_optional/` e ativa.
- **`scripts/install.sh`** JÁ NêO copia o cognito automaticamente — só mostra mensagem informativa.

### Changed — tool-visual-explainer move para visualization/

- **`tool-visual-explainer`** movida de `tools/` → `visualization/`. Razêo: as pastas `operations/`, `strategy/` e `visualization/` existiam vazias na v0.4.3 (bug documental detetado pelo Fernando). Agora `visualization/` tem conteúdo coerente.

### Changed — Filosofia "Sistema vivo" explícita no README

- Nova secçêo 🌱 **Sistema vivo** no README a explicar que o catálogo cresce com a comunidade (ciclo 4-6 semanas). Reforça o processo de proposta e retirada de skills documentado em `docs/skills-recommended.md`.
- Cadência esperada de release menor: cada 4-6 semanas com skills validadas pela comunidade.

### Changed — Plugins oficiais Anthropic via marketplace (NêO vendorizados)

- **Decisêo legal**: as 4 skills oficiais da Anthropic (`docx`, `xlsx`, `pdf`, `pptx`) têm licença **"source-available", NêO open source** (verificado em `skills/docx/LICENSE.txt` do repo `anthropics/skills`). **Nêo se podem redistribuir** neste repo MIT.
- **Soluçêo**: documentar instalaçêo via marketplace oficial dentro do Claude Code (`/plugin install anthropic-skills`). O utilizador recebe-as diretamente da Anthropic, nêo deste repo. Vantagem adicional: quando a Anthropic atualiza, o utilizador recebe-as sem esperar release.
- **Integraçêo**: dia 4 do comando `/aprende` guia o aluno passo a passo para as ativar.

### Added — Showcase pré-povoado

- **`projects/_showcase/`** — 4 outputs reais gerados com dados sintéticos para que o aluno veja que tipo de resultado o sistema produz antes de gerar o seu:
  1. **Post LinkedIn** — preview visual a simular LinkedIn nativo
  2. **Sequência de boas-vindas** (5 emails) — HTML interativo desdobrável
  3. **Resumo de reuniêo kick-off** — HTML com temas, action items e riscos
  4. **Proposta comercial** — HTML branded premium estilo Sintaxis Lab
- Caso unificado: consultora fictícia "Marta Sánchez" a trabalhar com "Logística do Norte SL". Coerência entre outputs mostra como o brand context atravessa todas as skills.
- Removível sem afetar nada: `rm -rf projects/_showcase/`.

### Fixed — Inconsistências documentais detetadas em revisêo Fernando

- **`docs/quickstart.md`** já nêo menciona skills inexistentes (`operations-meeting-notes`, `strategy-competitor-monitor`). Substituídas por exemplos com skills que existem.
- **Contagem de skills**: README e CLAUDE.md agora dizem 22 skills core (era 18 anunciadas mas desencontradas com o sistema real).
- **Pastas vazias**: `operations/` e `strategy/` já nêo sêo fantasmas — `strategy/` tem `strategy-web-research`. `operations/` mantém-se vazia até à v0.6.0 (onde entram as versões nativas em português).

### Filosofia v0.5.0

- **Vendoreio seletivo, nêo às cegas**: das 6 skills sugeridas pelo Fernando, só 2 passaram auditoria (Haiku-evaluated): email-sequence e web-research. As outras 4 (meeting-notes, proposal-writer, youtube-transcript, linkedin-posts) estêo em backlog v0.6.0 para reescrita nativa em português com voice profile.
- **Cumprimento legal explícito**: duas decisões de licença tomadas (Sinapsis passa a MIT por acordo com o Luis Pitik · skills oficiais Anthropic via marketplace, nêo copiadas). Zero zonas cinzentas.
- **Sistema vivo como narrativa**: o repo nêo é produto fechado. Cada release menor incorpora 1-3 skills validadas pela comunidade.
- **Educaçêo incluída**: o aluno de zero tem um tutorial guiado (`/aprende`) e um showcase de referência (`projects/_showcase/`). Nêo depende de vídeos externos.

### Counts pós-v0.5.0

| Categoria | v0.4.3 | v0.5.0 |
|---|---:|---:|
| `_meta/` | 10 (com cognito) | 9 |
| `_meta/_optional/` | 0 | 1 (cognito) |
| `marketing/` | 5 | 6 (+email-sequence) |
| `automation/` | 0 | 2 (novo) |
| `strategy/` | 0 | 1 (novo) |
| `tools/` | 4 | 3 (-visual-explainer) |
| `visualization/` | 0 | 1 (+visual-explainer) |
| **Total core** | **18** | **22** |
| Plugins Anthropic | — | 4 (via marketplace) |

---

## v0.4.3 — Plug-and-play conversacional (2026-05-08)

> **Visêo**: converter a instalaçêo do iAmasters OS numa experiência conversacional. O membro cola um URL no Claude Code e o sistema sabe o que fazer. Zero terminal manual, primeiro entregável garantido em ~15-20 min.

### Added — Skills novas

- **`_meta/welcome-quick-win`** — primeira tarefa garantida em 5 min após o onboarding. Pede URL público do utilizador (LinkedIn / site), executa análise de posicionamento, gera 3 hooks LinkedIn + plano de semana, tudo empacotado em HTML autocontido e partilhável. É a skill que entrega o "primeiro wow".
- **`_meta/six-hats`** — método dos 6 chapéus de Edward de Bono. Analisa decisões a partir de 6 perspetivas separadas (processo, dados, riscos, oportunidades, criatividade, intuiçêo). Universal e útil para qualquer empreendedor que toma decisões grandes.
- **`_meta/decisions-log`** — diário append-only de decisões do operador. Inspirado diretamente em [`Luispitik/claude-code-second-brain`](https://github.com/Luispitik/claude-code-second-brain) do Luis Pitik (com crédito explícito em SKILL.md e README). Mantém o Claude coerente entre sessões.
- **`_meta/health-check`** — diagnóstico completo do OS. Verifica ambiente, Sinapsis, brand-context, context setorizado, skills curadas, settings, API keys. Devolve report 🟢🟡🔴 com auto-fixes.
- **`_meta/cognito`** (wrapper) — Sistema Operativo de Pensamento do Luis Pitik vendorizado em `vendor/cognito/`. O instalador copia-a para `~/.claude/skills/cognito/` na primeira vez. Mantida intacta.
- **`_meta/find-skills`** — descoberta. Ajuda-te a encontrar skills quando o catálogo crescer por intent em linguagem natural.
- **`tools/tool-visual-explainer`** — gera HTML autocontido e bonito para outputs partilháveis (sem JS, mobile-first, paleta laranja iAmasters). Invocada por welcome-quick-win, six-hats, marketing-positioning, etc.

### Added — Slash commands

- **`/doctor`** — invoca `_meta/health-check` com apresentaçêo 🟢🟡🔴 + proposta auto-fix
- (Pendente v0.5.0: `/welcome` e `/cognito-mode` como aliases explícitos)

### Changed — Refactor crítico

- **`AGENTS.md`** completamente reescrito. Secçêo principal nova: "Se és Claude Code e recebes o prompt URL canónico" com workflow passo-a-passo (clone → install → onboarding → welcome). Secçêo cross-tool conservada no fim.
- **`README.md`** redesenhado com:
  - Secçêo "🚀 Instalaçêo em 30 segundos" no início com prompt URL canónico copy-paste destacado
  - Secçêo "💰 Custo real" transparente sobre Anthropic Pro/Max ($20-200/mês) — comunicaçêo honesta antes que o membro choque com a fatura
  - Lista das 18 skills core pré-instaladas (12 v0.4.2 + 6 novas)
  - Renovado bloco de créditos com autoria correta (Luis Pitik, De Bono, Anthropic skills)
- **`scripts/install.sh`** robustecido:
  - Deteçêo OS (macOS / Linux / Windows-bash)
  - Saída estruturada parseável: `[OK]`, `[SKIP]`, `[WARN]`, `[ERROR]` (Claude Code agent pode ler o output e reagir)
  - Idempotente: executar várias vezes nêo parte nada
  - Cria `context/decisions-log.md` com header canónico
  - Cria diretório `projects/welcome/`
  - Step 7 novo: copia `vendor/cognito/` para `~/.claude/skills/cognito/` se nêo existir
- **`meta-onboarding-wizard`** completamente reescrito:
  - Entrevista por blocos temáticos (nêo tudo de uma vez — padrêo second-brain)
  - Enche 5 ficheiros setorizados: `context/me.md`, `work.md`, `team.md`, `current-priorities.md`, `goals.md` (em vez de `user.md` monolítico)
  - Pergunta cognito mode (guiado / completo) e guarda no operator-state
  - Lança `welcome-quick-win` ao fechar para garantir o primeiro wow

### Added — Documentaçêo

- **`docs/skills-recommended.md`** redesenhado:
  - Catálogo Camada 2 com ~30 skills opcionais agrupadas por categoria
  - Secçêo "Alternativa lean: claude-code-second-brain" com tabela "quando escolher um ou outro" — referencia e respeita o Luis
  - Processos de proposta e retirada de skills do catálogo
- **`context/README.md`** novo, a explicar o padrêo setorizado
- **`brand-context/README.md`** a explicar que skill gera cada ficheiro

### Refactor — context/ setorizado

- `context/user.md` monolítico → 5 ficheiros setorizados criados pelo wizard:
  - `me.md` — identidade pessoal (nome, localizaçêo, descriçêo profissional)
  - `work.md` — negócio, serviços, receita, stack
  - `team.md` — equipa (pode estar vazia se trabalha sozinho)
  - `current-priorities.md` — foco do mês, gargalo
  - `goals.md` — objetivos 12 meses
- `context/decisions-log.md` novo (criado por install.sh com header)
- `context/soul.md` e `context/learnings.md` mantidos

### Vendored

- **`vendor/cognito/`** — sistema cognito do Luis Pitik vendorizado intacto (sem modificar). Inclui SKILL.md, modes/, phases/, profiles/, hooks/, commands/, integrations/, templates/, config/. Excluído: tests/, .git/, .github/.

### Filosofia v0.4.3

- **Nêo inflar o catálogo**: passámos de 12 → 18 skills core (todas validadas), nêo a 19 com sprint às cegas. Catálogo Camada 2 disponível on-demand.
- **Validaçêo antes que construçêo**: a experiência da Sessêo 1 (Angel + URL canónico em Claude Desktop limpo) confirmou que o flow vai funcionar. Sprint v0.5.0 esperará feedback real de uso, nêo planeamento às cegas.
- **Crédito explícito ao Luis Pitik**: três das skills novas (decisions-log inspirada em second-brain, cognito vendorizada intacta, find-skills) referenciam o Luis com atribuiçêo completa. Coerente com a regra das 6 camadas de atribuiçêo.

---

## v0.4.2 — Migraçêo para org iamasters-academy + dados finais (2026-05-07)

### Changed
- **Repo migrado**: `angelapaia/iamasters-os` → `iamasters-academy/iamasters-os`
  - Novo URL: https://github.com/iamasters-academy/iamasters-os
  - GitHub mantém redirects automáticos do URL anterior
- **Atribuiçêo corrigida** em todos os ficheiros do repo:
  - "iAmasters Academy" → "IA Masters Academy" (3 palavras separadas, conforme logo oficial)
  - Email gmail → `aaparicio@iamastersacademy.com` (corporativo)
  - Copyright `2026` → `2025-2026` (inclui ano de fundaçêo da academia)
  - Adicionada entidade legal: AASC Associates (a brand of)
  - Adicionado LinkedIn: linkedin.com/in/angel-aparicio92/
  - Adicionado GitHub Org link: @iamasters-academy
- **Logo adicionado**: `assets/logo.png` (2.4 MB, 1536×1024 PNG RGBA transparente). Mostrado no header do README, header do HTML team-presentation e footer do HTML.
- **README header redesenhado**: logo centrado + título + subtitle + 5 badges centrados.
- **LICENSE** ampliada com secçêo "Trademark notice" (marcas da AASC Associates).
- **CITATION.cff** version bumpeada a 0.4.2 com URLs atualizados para a org nova.

### Added
- **`assets/logo.png`** — logo oficial IA Masters Academy
- **Sweep global** automatizado para substituir referências antigas em todos os .md, .html, .cff, .json, .sh do repo

### Brand assets central
O logo e futuros assets vivem em
`Empresa/01-IA Masters/07-Equipo/brand-assets/iamasters-academy-logo.png`
como fonte única de verdade. Cada repo novo copia-o daí seguindo o
checklist `captacion-shared/07-Equipo/repo-attribution-checklist.md`.

---

## v0.4.1 — Atribuiçêo e propriedade (2026-05-07)

### Added
- **LICENSE atualizado** com copyright "© 2026 Angel Aparicio · IA Masters Academy" + secçêo Authorship & Maintenance + bloco Vendored components a clarificar licença Sinapsis + bloco How to cite
- **README badges** (5): version, license, sinapsis-engine, maintained-by-angel-aparicio, by-iamasters-academy
- **README secçêo "Sobre o projeto"** com tabela de autoria + como citar + nota de marca + code ownership
- **`.github/CODEOWNERS`** com `* @angelapaia` global + paths específicos
- **`CITATION.cff`** formato académico com dados completos + preferred-citation + referência a Sinapsis vendorizado
- **GitHub repo metadata** atualizado: description com atribuiçêo, homepage para comunidade iAmasters, 7 topics (claude-code, agentic-os, sinapsis, ai-operator, skills-on-demand, iamasters, castellano)
- **Footer team-presentation.html** com copyright, links próprios, nota de marcas

Aplica as 6 camadas standard de atribuiçêo documentadas no repo
partilhado da equipa (`captacion-shared/07-Equipo/repo-attribution-checklist.md`).

---

## v0.4.0 — Marketplace local + MCPs curados (2026-05-07)

### Added
- **`/install-skill <github-url>`** comando para instalar skills externas com validaçêo prévia:
  - Descarrega para `/tmp/iamasters-os-skill-validate-<hash>/`
  - Valida estrutura (SKILL.md, YAML frontmatter, name kebab-case, description 50-500 chars)
  - Deteta verbos de intençêo na description (afeta ativaçêo)
  - Verifica scripts por padrões perigosos (rm -rf /, eval, dd if=, mkfs, etc.)
  - Deteta credenciais hardcoded (regex API keys, tokens)
  - Verifica conflito com skills locais do mesmo nome
  - Output: report com OK/WARN/ERROR + recomendações de instalaçêo
- **`/install-mcp <name>`** comando para instalar MCP servers:
  - Lista curada em `docs/mcps-curated.md` (top 5 + 5 úteis + warnings)
  - Configura `.mcp.json` com templates testados
  - Modo custom para URLs nêo curados (com warnings)
- **`scripts/validate-skill.sh`** executa toda a validaçêo
- **`docs/mcps-curated.md`** lista mantida de 10 MCPs úteis para operadores IA:
  - ⭐ Top 5: context7, github, supabase, notion, firecrawl
  - 🔧 Úteis: linear, gmail (read-only), slack, filesystem
  - ⚠️ MCPs a evitar (write redes sociais sem gates, scopes opacos)
  - Padrêo de token budget (5-7 MCPs ativos máximo)
- **`docs/skills-recommended.md`** lista de skills externas validadas:
  - Anthropic core: skill-creator, visual-explainer, pdf, docx, xlsx
  - Marketing: content-strategy, social-content, email-marketing-bible, ad-creative
  - Operations: marketing-psychology, product-management, saas-revenue-growth-metrics
  - Tech: nextjs-*, vercel-deployment, tailwind-design-system, web-security-audit
  - ⚠️ Skills a evitar (sem description clara, duplicadas, "tudo em um")
- **`docs/multi-client-guide.md`** guia operativo multi-cliente:
  - Quando usar / nêo usar
  - Estrutura herança CLAUDE.md
  - Skills custom por cliente vs skills globais do repo
  - Best practices de segurança: separaçêo de info entre clientes
  - Troubleshooting típico

### Decisões de design
- O validate-skill.sh cria sempre TMP dir e NêO elimina automaticamente (operador pode inspecionar manualmente)
- Hardcoded secrets detection usa regex permissivo (pode haver falsos positivos, melhor warning que false-negative)
- MCP install nêo toca em .mcp.json sem confirmaçêo explícita do operador
- Curated lists sêo opinativas: só skills/MCPs com experiência real >2 semanas

---

## v0.3.0 — Multi-cliente + scripts de gestêo (2026-05-07)

### Added
- **4 templates verticais completos** em `clients/_templates/`:
  - `freelance-ia/` — operador IA solo, ticket 5-50K€/projeto
  - `agencia-marketing/` — pequena agência, MRR recorrente
  - `formador-online/` — coach/educador, ticket 200-2000€
  - `consultoria-b2b/` — high-ticket 30-300K€/engagement
- Cada template inclui: README específico + voice-profile + positioning + ICP + soul + user (template) — 6 ficheiros × 4 templates = 24 ficheiros
- **`scripts/add-client.sh`** — cria cliente novo desde template ou vazio:
  - Valida nome kebab-case
  - Clona template + substitui placeholders `{{CLIENT_NAME}}`
  - Gera `clients/<nome>/CLAUDE.md` com overrides específicos
  - Output: estrutura completa pronta a configurar
- **`scripts/update.sh`** — atualiza repo desde upstream com conflict resolution:
  - 4 cenários tratados: nada muda / upstream atualiza / local modificou / conflito
  - Backup automático em `.backup/<timestamp>/` antes de tocar em nada
  - User data (brand-context, context, projects, clients, .env) NUNCA se sobrescreve
  - Skills locais modificadas: prompt caso a caso (keep / use upstream / diff / skip)
  - Vendor sinapsis + system files: safe to update

### Notas operativas
- Herança CLAUDE.md: o do cliente adiciona overrides ao do raiz, nêo o substitui
- Skills copiam-se para o cliente (nêo se herdam automaticamente); sincronizam-se com `update.sh`
- O operador pode criar skills custom dentro de `clients/<nome>/.claude/skills/` que só se aplicam a esse cliente

---

## v0.2.0 — Skills marketing core (2026-05-07)

### Added
- **8 skills novas** seguindo o padrêo canónico do meta-skill-creator:
  - `tool-humanizer` — detetor + reescritor anti-AI com `references/ai-tells.md`
  - `tool-output-verifier` — gate 4-checks (humanizer + brand-voice + length + factuality)
  - `tool-firecrawl-scraper` — wrapper Firecrawl com degradaçêo graceful
  - `marketing-brand-voice` — voice profile + 3 registos A/B/C (formal/divulgativo/próximo)
  - `marketing-positioning` — análise concorrentes + 3-5 ângulos + recomendaçêo
  - `marketing-icp` — perfil cliente ideal completo com buying triggers + linguagem + anti-ICP
  - `marketing-copywriting` — gerador com voice + register auto + 2-3 variações por output
  - `marketing-content-repurposing` — 1 fonte → 5-8 peças multiplataforma com calendar
- **Padrêo de skill collaboration** documentado: copywriting → output-verifier → humanizer
- **Plataform limits reference** mantido com 30+ plataformas

### Decisões de design
- Todas as skills marketing-* invocam tool-output-verifier obrigatoriamente como gate
- Humanizer score thresholds variam por plataforma (email premium ≥8, WhatsApp ≥6)
- Brand voice compõe-se de 3 registos separados, nêo 1 generic
- Firecrawl é opcional: se faltar API key, fallback para WebFetch com warning

---

## v0.1.0 — esqueleto + Sinapsis (2026-05-07)

**Objetivo**: repo clonável que instala Sinapsis e deixa preparada a camada OS para construir em cima.

### Added
- Estrutura completa de pastas
- Sinapsis v4.5 vendorizado em `vendor/sinapsis/`
- `install.sh` que delega ao Sinapsis e depois inicializa a camada OS
- README, CLAUDE.md, AGENTS.md, LICENSE, .gitignore, .env.example
- Meta-skills v0: `meta-skill-creator`, `meta-onboarding-wizard`, `meta-start-here`, `meta-wrap-up`
- Templates vazios de brand-context e context

---

## Versionamento do Sinapsis vendorizado

| iAmasters OS | Sinapsis vendorizado |
|---|---|
| v0.1.0 | v4.5.0 |

Quando o Sinapsis publica nova versêo upstream, atualiza-se o vendor com um commit dedicado.
