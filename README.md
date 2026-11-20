<p align="center">
  <img src="assets/logo.png" alt="IA Masters Academy" width="320">
</p>

<h1 align="center">iAmasters OS</h1>

<p align="center">
  <em>O sistema operativo agÃªntico para operadores de IA.<br>
  PortuguÃªs. Multi-cliente. Com memÃ³ria que evolui.</em>
</p>

<p align="center">
  <a href="https://github.com/iamasters-academy/iamasters-os/releases"><img src="https://img.shields.io/badge/version-v0.6.0-orange.svg" alt="Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="vendor/sinapsis/"><img src="https://img.shields.io/badge/engine-Sinapsis%20v4.5-purple.svg" alt="Powered by Sinapsis"></a>
  <a href="https://angelaparicio.com"><img src="https://img.shields.io/badge/maintained%20by-Angel%20Aparicio-ff8c42.svg" alt="Maintained by Angel Aparicio"></a>
  <a href="https://www.skool.com/ia-masters-automations"><img src="https://img.shields.io/badge/by-IA%20Masters%20Academy-b794f4.svg" alt="IA Masters Academy"></a>
</p>

---

## ðŸš€ InstalaÃ§Ã£o (v0.6 â€” com install gate)

**Caminho curto (recomendado)** â€” pelo terminal:

```bash
git clone https://github.com/iamasters-academy/iamasters-os.git ~/iamasters-os
cd ~/iamasters-os
bash scripts/install.sh
```

Isto instala as fases tÃ©cnicas (prereqs + engine Sinapsis) com validaÃ§Ã£o profunda. Quando terminar, abre o Claude Code nesta pasta e o resto completa-se por dentro:

1. O hook **SessionStart** detecta que faltam fases (onboarding + welcome) e guia o agente.
2. O agente invoca o comando `/install` que orquestra as 4 fases conversacionais restantes.
3. O **onboarding wizard** entrevista-te por sub-fases com **commits incrementais**: se interromperes a meio, o guardado fica guardado e `/install --resume` retoma exatamente onde paraste.
4. ApÃ³s o wizard gera-se o teu primeiro entregÃ¡vel (`welcome-quick-win`, ~5 min).

Total realista: 15-20 minutos.

**Alguma coisa falha?** Executa:
```bash
bash scripts/install.sh --resume        # continua desde a Ãºltima fase bem-sucedida
bash scripts/install.sh --force-reinstall  # backup do state atual e arranca limpo
```

E de dentro do Claude Code: `/install-status` mostra-te o dashboard sem tocar em nada.

> ðŸ’¡ **PorquÃª este fluxo** (v0.6+): a versÃ£o anterior reportava por vezes "tudo instalado" quando partes tinham falhado silenciosamente. Agora hÃ¡ um **state machine persistente** em `~/.claude/skills/_install-state.json` que Ã© a fonte da verdade sobre o que estÃ¡ realmente instalado. ValidaÃ§Ã£o profunda, nÃ£o sÃ³ presenÃ§a de ficheiros. Ver [`docs/install-state-schema.md`](docs/install-state-schema.md).

Ainda nÃ£o tens o Claude Desktop? [Descarrega aqui](https://claude.com/download). NÃ£o sabes que plano precisas? Ver [ðŸ’° Custo real](#-custo-real) abaixo.

---

## O que Ã©

**iAmasters OS** Ã© um repositÃ³rio Claude Code que converte uma sessÃ£o vanilla num sistema operativo profissional para operadores de IA. TrÃªs camadas:

1. **Sinapsis v4.5 (engine)** â€” memÃ³ria persistente, instintos auto-aprendidos, skills on-demand. Vendorizado intacto do [repo do Luis Pitik](https://github.com/Luispitik/sinapsis).
2. **Camada OS** â€” brand context (voice, positioning, ICP), agent context setorizado (me, work, team, priorities, goals), projetos estruturados, multi-cliente com templates por vertical.
3. **Skills curadas** â€” 23 skills validadas para marketing, estratÃ©gia, automaÃ§Ã£o, tools, visualizaÃ§Ã£o e meta-pensamento. Todas seguem o padrÃ£o skill.md + references/ + scripts/. Skills oficiais da Anthropic (docx, xlsx, pdf, pptx) instalam-se via marketplace no dia 4 do `/aprende`.

> ðŸŒ± **Sistema vivo**: o catÃ¡logo cresce com a comunidade. Quando uma skill nova da IA Masters Academy demonstra valor em produÃ§Ã£o, entra no repo. Ver [`docs/skills-recommended.md`](docs/skills-recommended.md) para propor uma.

## Para quem

- Operador IA freelancer que serve vÃ¡rios clientes
- Empreendedor que automatiza o seu negÃ³cio com Claude Code
- AgÃªncia pequena que quer padronizar a sua stack agÃªntica
- Formador que ensina Claude Code e precisa de um repo de referÃªncia
- Qualquer membro da [IA Masters Academy](https://www.skool.com/ia-masters-automations) (Ã© a audiÃªncia principal)

NÃ£o requer conhecimentos de programaÃ§Ã£o. Requer paciÃªncia para configurar pela primeira vez (~15-20 min de onboarding guiado).

## O que te dÃ¡ no primeiro dia

- âœ… MemÃ³ria que persiste entre sessÃµes (acabou o "explica-me a tua stack outra vez")
- âœ… O teu primeiro entregÃ¡vel real gerado pelo sistema nos primeiros 20 min (welcome-quick-win)
- âœ… 23 skills curadas, instaladas, prontas a ativar-se quando falas com o Claude
- âœ… Brand context (voz, posicionamento, ICP) gerÃ¡vel em 30 minutos extra
- âœ… Multi-cliente pronto para escalar (4 templates de vertical incluÃ­dos)
- âœ… Sistema de aprendizagem contÃ­nua: o que repetes gradua-se a regra
- âœ… Decisions log append-only que mantÃ©m o Claude coerente entre sessÃµes
- âœ… `/doctor` para diagnosticar e arranjar qualquer desvio

## ðŸ’° Custo real

**Importante ler antes de instalar.** O iAmasters OS Ã© grÃ¡tis e open source, mas requer o Claude (da Anthropic), que NÃƒO Ã© grÃ¡tis.

| Conceito | Custo | Quando se paga |
|---|---|---|
| iAmasters OS (este repo) | **GrÃ¡tis** (MIT) | Nunca |
| Membership iAmasters Academy | (ver site) | Se quiseres a comunidade e formaÃ§Ã£o. **NÃ£o** Ã© necessÃ¡ria para usar o OS |
| Claude Desktop app | GrÃ¡tis (descarga) | Nunca |
| **Anthropic Pro** | **$20/mÃªs** | MÃ­nimo necessÃ¡rio para o OS funcionar bem |
| **Anthropic Max** | $100-200/mÃªs | Se vais usar muito Cowork ou sessÃµes longas de Code |
| Firecrawl API (opcional) | GrÃ¡tis 500 crÃ©ditos | Se quiseres que o OS faÃ§a scraping do teu site/LinkedIn auto |

**ConclusÃ£o**: o custo mÃ­nimo realista para comeÃ§ar bem Ã© **$20/mÃªs de Anthropic Pro**. Com o plano Free os modelos bons nÃ£o chegam e o OS sente-se partido.

> Se vens da iAmasters Academy: a tua membership NÃƒO inclui Anthropic. SÃ£o contas separadas. Dizemo-lo claro porque outros produtos escondem.

## InstalaÃ§Ã£o alternativa (via Claude Code)

Se preferires lanÃ§ar tudo a partir do Claude Code (nÃ£o recomendado para v0.6 â€” o script tÃ©cnico executa-se melhor do terminal):

```
Instala o iAmasters OS desde
https://github.com/iamasters-academy/iamasters-os
e guia-me no setup
```

O Claude Code vai clonar o repo e indicar-te abrir o terminal para executar `bash scripts/install.sh` (as fases tÃ©cnicas precisam de terminal). Depois disso, o fluxo Ã© o mesmo: o install gate guia as fases restantes.

Detalhe completo em [`docs/installation.md`](docs/installation.md) e schema do state machine em [`docs/install-state-schema.md`](docs/install-state-schema.md).

## Depois de instalar

O mais Ãºtil para arrancar:

| Comando / aÃ§Ã£o | O que faz |
|---|---|
| `/install` | Orquestra a instalaÃ§Ã£o por fases. Reentrante com `--resume` (v0.6) |
| `/install-status` | Dashboard read-only do state machine (v0.6) |
| Onboarding wizard (auto) | Entrevista-te por sub-fases com commits incrementais |
| `/welcome` | Gera o teu primeiro entregÃ¡vel HTML partilhÃ¡vel (5 min) |
| `/doctor` | Diagnostica o OS com validaÃ§Ã£o profunda, deteta drift, propÃµe fixes |
| `/start-here` | Ritual diÃ¡rio de inÃ­cio: resumo de ontem + proposta de hoje |
| `/wrap-up` | Ritual de fecho: regista deliverables, decisÃµes, liÃ§Ãµes |

## Skills incluÃ­das (Camada 1 â€” prÃ©-instaladas)

```
_meta/                            Sistema e rituais do OS
â”œâ”€â”€ meta-skill-creator            Cria skills novas seguindo o padrÃ£o canÃ³nico
â”œâ”€â”€ meta-onboarding-wizard        Entrevista express adaptativa (8 dimensÃµes crÃ­ticas)
â”œâ”€â”€ meta-deep-dive                ðŸ†• Entrevista profunda adaptativa (22-25 dimensÃµes)
â”œâ”€â”€ meta-start-here               Ritual diÃ¡rio de inÃ­cio
â”œâ”€â”€ meta-wrap-up                  Ritual diÃ¡rio de fecho
â”œâ”€â”€ welcome-quick-win             O teu primeiro entregÃ¡vel garantido em 5 min
â”œâ”€â”€ six-hats                      MÃ©todo 6 chapÃ©us de De Bono
â”œâ”€â”€ decisions-log                 DiÃ¡rio append-only inspirado em second-brain
â”œâ”€â”€ health-check                  DiagnÃ³stico (via `/doctor`)
â””â”€â”€ find-skills                   Descoberta por intent em linguagem natural

marketing/                        Voz, conteÃºdo e conversÃ£o
â”œâ”€â”€ marketing-brand-voice         Voice profile + 3 registos A/B/C
â”œâ”€â”€ marketing-positioning         AnÃ¡lise de posicionamento
â”œâ”€â”€ marketing-icp                 Cliente ideal: dores, linguagem, triggers
â”œâ”€â”€ marketing-copywriting         Copy com humanizer gate obrigatÃ³rio
â”œâ”€â”€ marketing-content-repurposing DistribuiÃ§Ã£o multiplataforma
â””â”€â”€ marketing-email-sequence      ðŸ†• SequÃªncias de email (welcome, nurture, win-back)

automation/                       ðŸ†• AutomaÃ§Ã£o e migraÃ§Ã£o
â”œâ”€â”€ automation-n8n-to-claude      Migra workflows n8n para o ecossistema Claude
â””â”€â”€ automation-n8n-builder        Cria workflows n8n desde o Claude (via MCP n8n-mcp)

strategy/                         ðŸ†• InvestigaÃ§Ã£o e estratÃ©gia
â””â”€â”€ strategy-web-research         Research profundo multi-fonte (LangChain)

tools/                            Utilidades transversais
â”œâ”€â”€ tool-firecrawl-scraper        Wrapper Firecrawl com fallback manual
â”œâ”€â”€ tool-humanizer                Remove padrÃµes AI-tell do output
â””â”€â”€ tool-output-verifier          Gate de qualidade (humanizer + voice + length)

visualization/                    Outputs partilhÃ¡veis
â””â”€â”€ tool-visual-explainer         Gera HTML autocontido partilhÃ¡vel

_meta/_optional/                  AtivÃ¡veis com `/install-skill <nome>`
â””â”€â”€ cognito                       Sistema Operativo de Pensamento (Luis Pitik)
```

> ðŸ“¦ **Skills oficiais Anthropic (`docx`, `xlsx`, `pdf`, `pptx`)**: NÃƒO sÃ£o vendorizadas neste repo porque a licenÃ§a Ã© "source-available" (nÃ£o permite redistribuiÃ§Ã£o). Instalam-se via marketplace oficial dentro do Claude Code (`/plugin install anthropic-skills`). O comando `/aprende` dia 4 guia-te passo a passo.

Queres mais? Ver [`docs/skills-recommended.md`](docs/skills-recommended.md) â€” catÃ¡logo da Camada 2 instalÃ¡vel on-demand com `/install-skill`.

## Estrutura do repo

```
iamasters-os/
â”œâ”€â”€ .claude/
â”‚   â”œâ”€â”€ settings.json           # Hooks Sinapsis + permissÃµes seguras por defeito
â”‚   â”œâ”€â”€ commands/               # Slash commands do OS
â”‚   â””â”€â”€ skills/                 # 22 skills curadas por categoria
â”‚
â”œâ”€â”€ brand-context/              # A tua marca: voice, positioning, ICP, assets
â”œâ”€â”€ context/                    # Contexto setorizado: me, work, team, priorities, goals
â”‚   â”œâ”€â”€ me.md                   # Identidade
â”‚   â”œâ”€â”€ work.md                 # NegÃ³cio e receita
â”‚   â”œâ”€â”€ team.md                 # Equipa
â”‚   â”œâ”€â”€ current-priorities.md   # Foco atual (muda mensalmente)
â”‚   â”œâ”€â”€ goals.md                # Objetivos 12 meses
â”‚   â”œâ”€â”€ decisions-log.md        # DecisÃµes append-only
â”‚   â”œâ”€â”€ learnings.md            # Feedback de skills
â”‚   â””â”€â”€ soul.md                 # Personalidade do agente
â”‚
â”œâ”€â”€ projects/                   # Outputs por skill ou por brief
â”‚   â””â”€â”€ welcome/                # O teu primeiro entregÃ¡vel vive aqui
â”‚
â”œâ”€â”€ clients/                    # Multi-cliente
â”‚   â””â”€â”€ _templates/             # 4 verticais: freelance-ia, agencia-marketing,
â”‚                               #               formador-online, consultoria-b2b
â”‚
â”œâ”€â”€ docs/                       # Guias de instalaÃ§Ã£o, multi-cliente, skills curadas
â”œâ”€â”€ scripts/                    # install, update, add-client, validate-skill
â””â”€â”€ vendor/
    â””â”€â”€ sinapsis/               # Sinapsis v4.5 vendorizado (engine de memÃ³ria)
```

## Diferencial vs vanilla Claude Code

| Sem OS | Com iAmasters OS |
|---|---|
| Cada sessÃ£o comeÃ§a a explicar a tua stack | Sinapsis lembra-se e carrega skills relevantes |
| Skills soltas sem curadoria | 18 skills validadas para o teu avatar |
| Brand voice cada vez que escreves | Voice profile permanente com 3 registos A/B/C |
| Outputs sem gate de qualidade | `tool-output-verifier` antes de entregar |
| 1 cliente ou mistura-se tudo | Multi-cliente com templates por vertical |
| Sem aprendizagem | O que repetes 3+ sessÃµes â†’ regra automÃ¡tica |
| Sem coerÃªncia entre sessÃµes | `decisions-log.md` mantÃ©m track record |
| Se algo parte, abandono | `/doctor` diagnostica e propÃµe fixes |

## Compatibilidade

- **Anthropic Plan**: Pro ou Max (Free nÃ£o chega)
- **OS**: macOS, Linux, Windows (Git Bash ou WSL)
- **Requer**: Claude Code (incluÃ­do no Claude Desktop), Node.js 18+, Python 3.9+, Git
- **Opcional**: Firecrawl API key (para auto-extrair voice profile e brand assets)

## Roadmap

Ver [`CHANGELOG.md`](CHANGELOG.md) para histÃ³rico detalhado.

- **v0.1.0** âœ… esqueleto + Sinapsis vendorizado + meta-skills + brand-context flow
- **v0.2.0** âœ… skills marketing core + output-verifier + skill marketplace local
- **v0.3.0** âœ… multi-cliente + 4 templates verticais + update.sh com conflict resolution
- **v0.4.0** âœ… MCPs curados + atribuiÃ§Ã£o (6 camadas)
- **v0.4.3** âœ… Plug-and-play (URL conversacional, /doctor, welcome quick-win, six-hats, decisions-log, setorizaÃ§Ã£o context)
- **v0.5.0** âœ… Sistema vivo + skills automation/email/strategy + comando `/aprende` (tour de 5 dias) + showcase prÃ©-povoado + plugins Anthropic via marketplace
- **v0.6.0** âœ… **Install gate** com state machine persistente, validaÃ§Ã£o profunda anti-"instalaÃ§Ã£o fantasma", hook SessionStart, onboarding por sub-fases com commits incrementais, comandos `/install` e `/install-status`, deteÃ§Ã£o Python multi-plataforma
- **v0.7.0** â€” Skills nativas em portuguÃªs (meeting-notes, proposal-writer, youtube-transcript, linkedin-posts) reescritas com voice profile do operador
- **v1.0.0** â€” release pÃºblica estÃ¡vel + vÃ­deos Loom integrados + landing em iamastersacademy.com/os

## ðŸŒ± Sistema vivo

iAmasters OS **nÃ£o Ã© um produto fechado**. Ã‰ um repositÃ³rio que cresce com a comunidade IA Masters Academy.

Cada vez que um membro constrÃ³i uma skill que demonstra valor em produÃ§Ã£o (validada â‰¥2 semanas, Ãºtil para â‰¥3 avatares, sem dependÃªncias privadas), entra no catÃ¡logo na prÃ³xima release. Cada vez que uma skill fica obsoleta ou tem melhor substituto, sai.

**Como propor uma skill nova**: ver critÃ©rios e processo em [`docs/skills-recommended.md`](docs/skills-recommended.md) â†’ secÃ§Ã£o "Como propor uma skill ao catÃ¡logo". O maintainer (Angel) revÃª, e as que passam entram na prÃ³xima release com crÃ©dito ao autor.

**CadÃªncia esperada**: release menor a cada 4-6 semanas com skills validadas pela comunidade.

## Contribuir

iAmasters OS Ã© cÃ³digo aberto sob MIT. ContribuiÃ§Ãµes bem-vindas:

- Skills novas (seguindo o padrÃ£o em [`docs/skill-creation-guide.md`](docs/skill-creation-guide.md))
- Templates de cliente para novos verticais
- Melhorias Ã  documentaÃ§Ã£o
- Reportes de bugs em `/doctor` ou instalaÃ§Ã£o

## CrÃ©ditos

- **Sinapsis**: [Luis Pitik](https://github.com/Luispitik/sinapsis) â€” o engine de memÃ³ria persistente
- **PadrÃ£o decisions-log**: inspirado em [`Luispitik/claude-code-second-brain`](https://github.com/Luispitik/claude-code-second-brain)
- **skill cognito**: original do Luis Pitik, copiada com autorizaÃ§Ã£o
- **find-skills, visual-explainer**: da suite Anthropic skills + comunidade
- **Brand Voice patterns A/B/C**: inspirado no Brand Voice Manual de Fernando Montero
- **6 chapÃ©us**: mÃ©todo de Edward de Bono, domÃ­nio pÃºblico

## Sobre o projeto

**iAmasters OS** Ã© propriedade de **Angel Aparicio** e faz parte do ecossistema de produtos da **[IA Masters Academy](https://www.skool.com/ia-masters-automations)**, a comunidade de operadores de IA.

| | |
|---|---|
| **Autor e mantenedor** | Angel Aparicio |
| **Marca** | IA Masters Academy |
| **Empresa legal** | AASC Associates |
| **Site pessoal** | [angelaparicio.com](https://angelaparicio.com) |
| **LinkedIn** | [angel-aparicio92](https://www.linkedin.com/in/angel-aparicio92/) |
| **GitHub** | [@angelapaia](https://github.com/angelapaia) |
| **GitHub Org** | [@iamasters-academy](https://github.com/iamasters-academy) |
| **Comunidade** | [skool.com/ia-masters-automations](https://www.skool.com/ia-masters-automations) |
| **Email** | aaparicio@iamastersacademy.com |
| **Ano** | 2025-2026 |

### Como citar

Se usares o iAmasters OS no teu trabalho, projeto ou publicaÃ§Ã£o, agradecemos a citaÃ§Ã£o. Ver [`CITATION.cff`](CITATION.cff) para o formato estruturado. ReferÃªncia rÃ¡pida:

> Aparicio, A. (2025-2026). *iAmasters OS* [Software]. IA Masters Academy.
> https://github.com/iamasters-academy/iamasters-os

### Code ownership

Este repositÃ³rio segue o modelo CODEOWNERS do GitHub. Qualquer PR requer review do proprietÃ¡rio. Ver [`.github/CODEOWNERS`](.github/CODEOWNERS) para o detalhe.

### Marca

"IA Masters Academy", "iAmasters OS" e o logo do camaleÃ£o sÃ£o marcas registadas de **AASC Associates Â· Angel Aparicio**. O cÃ³digo-fonte publica-se sob licenÃ§a MIT (uso/modificaÃ§Ã£o livres), mas o uso da marca e dos logos requer autorizaÃ§Ã£o explÃ­cita por escrito.

Para uso da marca, contactar: aaparicio@iamastersacademy.com

## LicenÃ§a

CÃ³digo-fonte sob MIT â€” ver [LICENSE](LICENSE).
Componente vendorizado Sinapsis v4.5 conserva a sua licenÃ§a "Source Available" original do Luis Pitik em [`vendor/sinapsis/LICENSE`](vendor/sinapsis/LICENSE).

---

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="32" />
  <p><strong>Arckhé AI</strong></p>
</div>