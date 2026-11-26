ï»¿<p align="center">
  <img src="assets/logo.png" alt="IA Masters Academy" width="320">
</p>

<h1 align="center">iAmasters OS</h1>

<p align="center">
  <em>O sistema operativo agêÂªntico para operadores de IA.<br>
  PortuguêÂªs. Multi-cliente. Com memêÂ³ria que evolui.</em>
</p>

<p align="center">
  <a href="https://github.com/iamasters-academy/iamasters-os/releases"><img src="https://img.shields.io/badge/version-v0.6.0-orange.svg" alt="Version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="vendor/sinapsis/"><img src="https://img.shields.io/badge/engine-Sinapsis%20v4.5-purple.svg" alt="Powered by Sinapsis"></a>
  <a href="https://angelaparicio.com"><img src="https://img.shields.io/badge/maintained%20by-Angel%20Aparicio-ff8c42.svg" alt="Maintained by Angel Aparicio"></a>
  <a href="https://www.skool.com/ia-masters-automations"><img src="https://img.shields.io/badge/by-IA%20Masters%20Academy-b794f4.svg" alt="IA Masters Academy"></a>
</p>

---

## ê°Å¸Å¡â¬ InstalaêÂ§êÂ£o (v0.6 ê¢â¬â com install gate)

**Caminho curto (recomendado)** ê¢â¬â pelo terminal:

```bash
git clone https://github.com/iamasters-academy/iamasters-os.git ~/iamasters-os
cd ~/iamasters-os
bash scripts/install.sh
```

Isto instala as fases têÂ©cnicas (prereqs + engine Sinapsis) com validaêÂ§êÂ£o profunda. Quando terminar, abre o Claude Code nesta pasta e o resto completa-se por dentro:

1. O hook **SessionStart** detecta que faltam fases (onboarding + welcome) e guia o agente.
2. O agente invoca o comando `/install` que orquestra as 4 fases conversacionais restantes.
3. O **onboarding wizard** entrevista-te por sub-fases com **commits incrementais**: se interromperes a meio, o guardado fica guardado e `/install --resume` retoma exatamente onde paraste.
4. ApêÂ³s o wizard gera-se o teu primeiro entregêÂ¡vel (`welcome-quick-win`, ~5 min).

Total realista: 15-20 minutos.

**Alguma coisa falha?** Executa:
```bash
bash scripts/install.sh --resume        # continua desde a êÂºltima fase bem-sucedida
bash scripts/install.sh --force-reinstall  # backup do state atual e arranca limpo
```

E de dentro do Claude Code: `/install-status` mostra-te o dashboard sem tocar em nada.

> ê°Å¸âÂ¡ **PorquêÂª este fluxo** (v0.6+): a versêÂ£o anterior reportava por vezes "tudo instalado" quando partes tinham falhado silenciosamente. Agora hêÂ¡ um **state machine persistente** em `~/.claude/skills/_install-state.json` que êÂ© a fonte da verdade sobre o que estêÂ¡ realmente instalado. ValidaêÂ§êÂ£o profunda, nêÂ£o sêÂ³ presenêÂ§a de ficheiros. Ver [`docs/install-state-schema.md`](docs/install-state-schema.md).

Ainda nêÂ£o tens o Claude Desktop? [Descarrega aqui](https://claude.com/download). NêÂ£o sabes que plano precisas? Ver [ê°Å¸âÂ° Custo real](#-custo-real) abaixo.

---

## O que êÂ©

**iAmasters OS** êÂ© um repositêÂ³rio Claude Code que converte uma sessêÂ£o vanilla num sistema operativo profissional para operadores de IA. TrêÂªs camadas:

1. **Sinapsis v4.5 (engine)** ê¢â¬â memêÂ³ria persistente, instintos auto-aprendidos, skills on-demand. Vendorizado intacto do [repo do Luis Pitik](https://github.com/Luispitik/sinapsis).
2. **Camada OS** ê¢â¬â brand context (voice, positioning, ICP), agent context setorizado (me, work, team, priorities, goals), projetos estruturados, multi-cliente com templates por vertical.
3. **Skills curadas** ê¢â¬â 23 skills validadas para marketing, estratêÂ©gia, automaêÂ§êÂ£o, tools, visualizaêÂ§êÂ£o e meta-pensamento. Todas seguem o padrêÂ£o skill.md + references/ + scripts/. Skills oficiais da Anthropic (docx, xlsx, pdf, pptx) instalam-se via marketplace no dia 4 do `/aprende`.

> ê°Å¸ÅÂ± **Sistema vivo**: o catêÂ¡logo cresce com a comunidade. Quando uma skill nova da IA Masters Academy demonstra valor em produêÂ§êÂ£o, entra no repo. Ver [`docs/skills-recommended.md`](docs/skills-recommended.md) para propor uma.

## Para quem

- Operador IA freelancer que serve vêÂ¡rios clientes
- Empreendedor que automatiza o seu negêÂ³cio com Claude Code
- AgêÂªncia pequena que quer padronizar a sua stack agêÂªntica
- Formador que ensina Claude Code e precisa de um repo de referêÂªncia
- Qualquer membro da [IA Masters Academy](https://www.skool.com/ia-masters-automations) (êÂ© a audiêÂªncia principal)

NêÂ£o requer conhecimentos de programaêÂ§êÂ£o. Requer paciêÂªncia para configurar pela primeira vez (~15-20 min de onboarding guiado).

## O que te dêÂ¡ no primeiro dia

- ê¢Åâ¦ MemêÂ³ria que persiste entre sessêÂµes (acabou o "explica-me a tua stack outra vez")
- ê¢Åâ¦ O teu primeiro entregêÂ¡vel real gerado pelo sistema nos primeiros 20 min (welcome-quick-win)
- ê¢Åâ¦ 23 skills curadas, instaladas, prontas a ativar-se quando falas com o Claude
- ê¢Åâ¦ Brand context (voz, posicionamento, ICP) gerêÂ¡vel em 30 minutos extra
- ê¢Åâ¦ Multi-cliente pronto para escalar (4 templates de vertical incluêÂ­dos)
- ê¢Åâ¦ Sistema de aprendizagem contêÂ­nua: o que repetes gradua-se a regra
- ê¢Åâ¦ Decisions log append-only que mantêÂ©m o Claude coerente entre sessêÂµes
- ê¢Åâ¦ `/doctor` para diagnosticar e arranjar qualquer desvio

## ê°Å¸âÂ° Custo real

**Importante ler antes de instalar.** O iAmasters OS êÂ© grêÂ¡tis e open source, mas requer o Claude (da Anthropic), que NêÆO êÂ© grêÂ¡tis.

| Conceito | Custo | Quando se paga |
|---|---|---|
| iAmasters OS (este repo) | **GrêÂ¡tis** (MIT) | Nunca |
| Membership iAmasters Academy | (ver site) | Se quiseres a comunidade e formaêÂ§êÂ£o. **NêÂ£o** êÂ© necessêÂ¡ria para usar o OS |
| Claude Desktop app | GrêÂ¡tis (descarga) | Nunca |
| **Anthropic Pro** | **$20/mêÂªs** | MêÂ­nimo necessêÂ¡rio para o OS funcionar bem |
| **Anthropic Max** | $100-200/mêÂªs | Se vais usar muito Cowork ou sessêÂµes longas de Code |
| Firecrawl API (opcional) | GrêÂ¡tis 500 crêÂ©ditos | Se quiseres que o OS faêÂ§a scraping do teu site/LinkedIn auto |

**ConclusêÂ£o**: o custo mêÂ­nimo realista para comeêÂ§ar bem êÂ© **$20/mêÂªs de Anthropic Pro**. Com o plano Free os modelos bons nêÂ£o chegam e o OS sente-se partido.

> Se vens da iAmasters Academy: a tua membership NêÆO inclui Anthropic. SêÂ£o contas separadas. Dizemo-lo claro porque outros produtos escondem.

## InstalaêÂ§êÂ£o alternativa (via Claude Code)

Se preferires lanêÂ§ar tudo a partir do Claude Code (nêÂ£o recomendado para v0.6 ê¢â¬â o script têÂ©cnico executa-se melhor do terminal):

```
Instala o iAmasters OS desde
https://github.com/iamasters-academy/iamasters-os
e guia-me no setup
```

O Claude Code vai clonar o repo e indicar-te abrir o terminal para executar `bash scripts/install.sh` (as fases têÂ©cnicas precisam de terminal). Depois disso, o fluxo êÂ© o mesmo: o install gate guia as fases restantes.

Detalhe completo em [`docs/installation.md`](docs/installation.md) e schema do state machine em [`docs/install-state-schema.md`](docs/install-state-schema.md).

## Depois de instalar

O mais êÂºtil para arrancar:

| Comando / aêÂ§êÂ£o | O que faz |
|---|---|
| `/install` | Orquestra a instalaêÂ§êÂ£o por fases. Reentrante com `--resume` (v0.6) |
| `/install-status` | Dashboard read-only do state machine (v0.6) |
| Onboarding wizard (auto) | Entrevista-te por sub-fases com commits incrementais |
| `/welcome` | Gera o teu primeiro entregêÂ¡vel HTML partilhêÂ¡vel (5 min) |
| `/doctor` | Diagnostica o OS com validaêÂ§êÂ£o profunda, deteta drift, propêÂµe fixes |
| `/start-here` | Ritual diêÂ¡rio de inêÂ­cio: resumo de ontem + proposta de hoje |
| `/wrap-up` | Ritual de fecho: regista deliverables, decisêÂµes, liêÂ§êÂµes |

## Skills incluêÂ­das (Camada 1 ê¢â¬â prêÂ©-instaladas)

```
_meta/                            Sistema e rituais do OS
ê¢âÅê¢ââ¬ê¢ââ¬ meta-skill-creator            Cria skills novas seguindo o padrêÂ£o canêÂ³nico
ê¢âÅê¢ââ¬ê¢ââ¬ meta-onboarding-wizard        Entrevista express adaptativa (8 dimensêÂµes crêÂ­ticas)
ê¢âÅê¢ââ¬ê¢ââ¬ meta-deep-dive                ê°Å¸â â¢ Entrevista profunda adaptativa (22-25 dimensêÂµes)
ê¢âÅê¢ââ¬ê¢ââ¬ meta-start-here               Ritual diêÂ¡rio de inêÂ­cio
ê¢âÅê¢ââ¬ê¢ââ¬ meta-wrap-up                  Ritual diêÂ¡rio de fecho
ê¢âÅê¢ââ¬ê¢ââ¬ welcome-quick-win             O teu primeiro entregêÂ¡vel garantido em 5 min
ê¢âÅê¢ââ¬ê¢ââ¬ six-hats                      MêÂ©todo 6 chapêÂ©us de De Bono
ê¢âÅê¢ââ¬ê¢ââ¬ decisions-log                 DiêÂ¡rio append-only inspirado em second-brain
ê¢âÅê¢ââ¬ê¢ââ¬ health-check                  DiagnêÂ³stico (via `/doctor`)
ê¢ââê¢ââ¬ê¢ââ¬ find-skills                   Descoberta por intent em linguagem natural

marketing/                        Voz, conteêÂºdo e conversêÂ£o
ê¢âÅê¢ââ¬ê¢ââ¬ marketing-brand-voice         Voice profile + 3 registos A/B/C
ê¢âÅê¢ââ¬ê¢ââ¬ marketing-positioning         AnêÂ¡lise de posicionamento
ê¢âÅê¢ââ¬ê¢ââ¬ marketing-icp                 Cliente ideal: dores, linguagem, triggers
ê¢âÅê¢ââ¬ê¢ââ¬ marketing-copywriting         Copy com humanizer gate obrigatêÂ³rio
ê¢âÅê¢ââ¬ê¢ââ¬ marketing-content-repurposing DistribuiêÂ§êÂ£o multiplataforma
ê¢ââê¢ââ¬ê¢ââ¬ marketing-email-sequence      ê°Å¸â â¢ SequêÂªncias de email (welcome, nurture, win-back)

automation/                       ê°Å¸â â¢ AutomaêÂ§êÂ£o e migraêÂ§êÂ£o
ê¢âÅê¢ââ¬ê¢ââ¬ automation-n8n-to-claude      Migra workflows n8n para o ecossistema Claude
ê¢ââê¢ââ¬ê¢ââ¬ automation-n8n-builder        Cria workflows n8n desde o Claude (via MCP n8n-mcp)

strategy/                         ê°Å¸â â¢ InvestigaêÂ§êÂ£o e estratêÂ©gia
ê¢ââê¢ââ¬ê¢ââ¬ strategy-web-research         Research profundo multi-fonte (LangChain)

tools/                            Utilidades transversais
ê¢âÅê¢ââ¬ê¢ââ¬ tool-firecrawl-scraper        Wrapper Firecrawl com fallback manual
ê¢âÅê¢ââ¬ê¢ââ¬ tool-humanizer                Remove padrêÂµes AI-tell do output
ê¢ââê¢ââ¬ê¢ââ¬ tool-output-verifier          Gate de qualidade (humanizer + voice + length)

visualization/                    Outputs partilhêÂ¡veis
ê¢ââê¢ââ¬ê¢ââ¬ tool-visual-explainer         Gera HTML autocontido partilhêÂ¡vel

_meta/_optional/                  AtivêÂ¡veis com `/install-skill <nome>`
ê¢ââê¢ââ¬ê¢ââ¬ cognito                       Sistema Operativo de Pensamento (Luis Pitik)
```

> ê°Å¸âÂ¦ **Skills oficiais Anthropic (`docx`, `xlsx`, `pdf`, `pptx`)**: NêÆO sêÂ£o vendorizadas neste repo porque a licenêÂ§a êÂ© "source-available" (nêÂ£o permite redistribuiêÂ§êÂ£o). Instalam-se via marketplace oficial dentro do Claude Code (`/plugin install anthropic-skills`). O comando `/aprende` dia 4 guia-te passo a passo.

Queres mais? Ver [`docs/skills-recommended.md`](docs/skills-recommended.md) ê¢â¬â catêÂ¡logo da Camada 2 instalêÂ¡vel on-demand com `/install-skill`.

## Estrutura do repo

```
iamasters-os/
ê¢âÅê¢ââ¬ê¢ââ¬ .claude/
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ settings.json           # Hooks Sinapsis + permissêÂµes seguras por defeito
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ commands/               # Slash commands do OS
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ skills/                 # 22 skills curadas por categoria
ê¢ââ
ê¢âÅê¢ââ¬ê¢ââ¬ brand-context/              # A tua marca: voice, positioning, ICP, assets
ê¢âÅê¢ââ¬ê¢ââ¬ context/                    # Contexto setorizado: me, work, team, priorities, goals
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ me.md                   # Identidade
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ work.md                 # NegêÂ³cio e receita
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ team.md                 # Equipa
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ current-priorities.md   # Foco atual (muda mensalmente)
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ goals.md                # Objetivos 12 meses
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ decisions-log.md        # DecisêÂµes append-only
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ learnings.md            # Feedback de skills
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ soul.md                 # Personalidade do agente
ê¢ââ
ê¢âÅê¢ââ¬ê¢ââ¬ projects/                   # Outputs por skill ou por brief
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ welcome/                # O teu primeiro entregêÂ¡vel vive aqui
ê¢ââ
ê¢âÅê¢ââ¬ê¢ââ¬ clients/                    # Multi-cliente
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ _templates/             # 4 verticais: freelance-ia, agencia-marketing,
ê¢ââ                               #               formador-online, consultoria-b2b
ê¢ââ
ê¢âÅê¢ââ¬ê¢ââ¬ docs/                       # Guias de instalaêÂ§êÂ£o, multi-cliente, skills curadas
ê¢âÅê¢ââ¬ê¢ââ¬ scripts/                    # install, update, add-client, validate-skill
ê¢ââê¢ââ¬ê¢ââ¬ vendor/
    ê¢ââê¢ââ¬ê¢ââ¬ sinapsis/               # Sinapsis v4.5 vendorizado (engine de memêÂ³ria)
```

## Diferencial vs vanilla Claude Code

| Sem OS | Com iAmasters OS |
|---|---|
| Cada sessêÂ£o comeêÂ§a a explicar a tua stack | Sinapsis lembra-se e carrega skills relevantes |
| Skills soltas sem curadoria | 18 skills validadas para o teu avatar |
| Brand voice cada vez que escreves | Voice profile permanente com 3 registos A/B/C |
| Outputs sem gate de qualidade | `tool-output-verifier` antes de entregar |
| 1 cliente ou mistura-se tudo | Multi-cliente com templates por vertical |
| Sem aprendizagem | O que repetes 3+ sessêÂµes ê¢â â regra automêÂ¡tica |
| Sem coerêÂªncia entre sessêÂµes | `decisions-log.md` mantêÂ©m track record |
| Se algo parte, abandono | `/doctor` diagnostica e propêÂµe fixes |

## Compatibilidade

- **Anthropic Plan**: Pro ou Max (Free nêÂ£o chega)
- **OS**: macOS, Linux, Windows (Git Bash ou WSL)
- **Requer**: Claude Code (incluêÂ­do no Claude Desktop), Node.js 18+, Python 3.9+, Git
- **Opcional**: Firecrawl API key (para auto-extrair voice profile e brand assets)

## Roadmap

Ver [`CHANGELOG.md`](CHANGELOG.md) para histêÂ³rico detalhado.

- **v0.1.0** ê¢Åâ¦ esqueleto + Sinapsis vendorizado + meta-skills + brand-context flow
- **v0.2.0** ê¢Åâ¦ skills marketing core + output-verifier + skill marketplace local
- **v0.3.0** ê¢Åâ¦ multi-cliente + 4 templates verticais + update.sh com conflict resolution
- **v0.4.0** ê¢Åâ¦ MCPs curados + atribuiêÂ§êÂ£o (6 camadas)
- **v0.4.3** ê¢Åâ¦ Plug-and-play (URL conversacional, /doctor, welcome quick-win, six-hats, decisions-log, setorizaêÂ§êÂ£o context)
- **v0.5.0** ê¢Åâ¦ Sistema vivo + skills automation/email/strategy + comando `/aprende` (tour de 5 dias) + showcase prêÂ©-povoado + plugins Anthropic via marketplace
- **v0.6.0** ê¢Åâ¦ **Install gate** com state machine persistente, validaêÂ§êÂ£o profunda anti-"instalaêÂ§êÂ£o fantasma", hook SessionStart, onboarding por sub-fases com commits incrementais, comandos `/install` e `/install-status`, deteêÂ§êÂ£o Python multi-plataforma
- **v0.7.0** ê¢â¬â Skills nativas em portuguêÂªs (meeting-notes, proposal-writer, youtube-transcript, linkedin-posts) reescritas com voice profile do operador
- **v1.0.0** ê¢â¬â release pêÂºblica estêÂ¡vel + vêÂ­deos Loom integrados + landing em iamastersacademy.com/os

## ê°Å¸ÅÂ± Sistema vivo

iAmasters OS **nêÂ£o êÂ© um produto fechado**. êâ° um repositêÂ³rio que cresce com a comunidade IA Masters Academy.

Cada vez que um membro constrêÂ³i uma skill que demonstra valor em produêÂ§êÂ£o (validada ê¢â°Â¥2 semanas, êÂºtil para ê¢â°Â¥3 avatares, sem dependêÂªncias privadas), entra no catêÂ¡logo na prêÂ³xima release. Cada vez que uma skill fica obsoleta ou tem melhor substituto, sai.

**Como propor uma skill nova**: ver critêÂ©rios e processo em [`docs/skills-recommended.md`](docs/skills-recommended.md) ê¢â â secêÂ§êÂ£o "Como propor uma skill ao catêÂ¡logo". O maintainer (Angel) revêÂª, e as que passam entram na prêÂ³xima release com crêÂ©dito ao autor.

**CadêÂªncia esperada**: release menor a cada 4-6 semanas com skills validadas pela comunidade.

## Contribuir

iAmasters OS êÂ© cêÂ³digo aberto sob MIT. ContribuiêÂ§êÂµes bem-vindas:

- Skills novas (seguindo o padrêÂ£o em [`docs/skill-creation-guide.md`](docs/skill-creation-guide.md))
- Templates de cliente para novos verticais
- Melhorias êÂ  documentaêÂ§êÂ£o
- Reportes de bugs em `/doctor` ou instalaêÂ§êÂ£o

## CrêÂ©ditos

- **Sinapsis**: [Luis Pitik](https://github.com/Luispitik/sinapsis) ê¢â¬â o engine de memêÂ³ria persistente
- **PadrêÂ£o decisions-log**: inspirado em [`Luispitik/claude-code-second-brain`](https://github.com/Luispitik/claude-code-second-brain)
- **skill cognito**: original do Luis Pitik, copiada com autorizaêÂ§êÂ£o
- **find-skills, visual-explainer**: da suite Anthropic skills + comunidade
- **Brand Voice patterns A/B/C**: inspirado no Brand Voice Manual de Fernando Montero
- **6 chapêÂ©us**: mêÂ©todo de Edward de Bono, domêÂ­nio pêÂºblico

## Sobre o projeto

**iAmasters OS** êÂ© propriedade de **Angel Aparicio** e faz parte do ecossistema de produtos da **[IA Masters Academy](https://www.skool.com/ia-masters-automations)**, a comunidade de operadores de IA.

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

Se usares o iAmasters OS no teu trabalho, projeto ou publicaêÂ§êÂ£o, agradecemos a citaêÂ§êÂ£o. Ver [`CITATION.cff`](CITATION.cff) para o formato estruturado. ReferêÂªncia rêÂ¡pida:

> Aparicio, A. (2025-2026). *iAmasters OS* [Software]. IA Masters Academy.
> https://github.com/iamasters-academy/iamasters-os

### Code ownership

Este repositêÂ³rio segue o modelo CODEOWNERS do GitHub. Qualquer PR requer review do proprietêÂ¡rio. Ver [`.github/CODEOWNERS`](.github/CODEOWNERS) para o detalhe.

### Marca

"IA Masters Academy", "iAmasters OS" e o logo do camaleêÂ£o sêÂ£o marcas registadas de **AASC Associates êÂ· Angel Aparicio**. O cêÂ³digo-fonte publica-se sob licenêÂ§a MIT (uso/modificaêÂ§êÂ£o livres), mas o uso da marca e dos logos requer autorizaêÂ§êÂ£o explêÂ­cita por escrito.

Para uso da marca, contactar: aaparicio@iamastersacademy.com

## LicenêÂ§a

CêÂ³digo-fonte sob MIT ê¢â¬â ver [LICENSE](LICENSE).
Componente vendorizado Sinapsis v4.5 conserva a sua licenêÂ§a "Source Available" original do Luis Pitik em [`vendor/sinapsis/LICENSE`](vendor/sinapsis/LICENSE).

---

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="32" />
  <p><strong>Arckhé AI</strong></p>
</div>