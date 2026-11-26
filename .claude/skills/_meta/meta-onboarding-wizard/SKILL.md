---
name: meta-onboarding-wizard
description: Lança o onboarding inicial quando um operador instala o iAmasters OS pela primeira vez. NêO é um formulário — é uma entrevista conversacional adaptativa que cobre 8 dimensões críticas (identidade, negócio, foco, objetivos). v0.6 CRÍTICO -- a entrevista está dividida em 4 sub-fases com COMMITS INCREMENTAIS após cada uma, e atualiza ~/.claude/skills/_install-state.json. Se o utilizador abandonar a meio, o progresso fica persistido e a sessêo seguinte retoma exatamente onde ficou (graças ao install-gate hook).
---

# meta-onboarding-wizard

> **Filosofia**: isto NêO é um formulário com 15 perguntas predefinidas. É uma entrevista conversacional. As perguntas concretas sêo decididas pelo agente em cada turno, conforme a resposta anterior. O que está fixo sêo as **dimensões a cobrir** e as **regras de aprofundamento**.
>
> **CRÍTICO v0.6** — A entrevista está dividida em 4 sub-fases. Depois de cada sub-fase escreves o ficheiro correspondente E atualizas `~/.claude/skills/_install-state.json`. NUNCA esperes pelo fim para escrever nada. Se o utilizador se cansar ou se for, o que já está capturado fica persistido.

## Quando é invocada

- O hook `_install-gate.sh` deteta `phases.context-files.status != "done"` e guia o utilizador para aqui
- O utilizador executa `/install --resume` e a fase ativa é `context-files` ou `operator-state`
- O utilizador pede explicitamente "volta a fazer-me o onboarding" ou "refazer onboarding"

NêO se invoca quando:
- `phases.context-files.status == "done"` E `phases.operator-state.status == "done"` no state
- Há daily summary do dia anterior (continuidade normal, ir a `meta-start-here`)

## As 8 dimensões críticas que TEM de capturar

Lê também [`references/dimensiones-express.md`](references/dimensiones-express.md) para o detalhe de que informaçêo concreta deve ficar em cada uma.

| # | Dimensêo | Sub-fase do wizard | Ficheiro destino |
|:--|---|---|---|
| 1 | Identidade (nome + 1 frase pro) | **W1 · Identidade** | `context/me.md` |
| 2 | Localizaçêo + idioma | **W1 · Identidade** | `context/me.md` |
| 3 | Negócio principal | **W2 · Negócio** | `context/work.md` |
| 4 | Modelo de receitas | **W2 · Negócio** | `context/work.md` |
| 5 | Cliente ideal | **W2 · Negócio** | `context/work.md` |
| 6 | Stack diário | **W2 · Negócio** | `context/work.md` |
| 7 | Foco do mês | **W3 · Foco** | `context/current-priorities.md` |
| 8 | Objetivo 12 meses | **W3 · Foco** | `context/goals.md` |
| — | Config técnica (nível, idioma outputs, Firecrawl) | **W4 · Config** | `~/.claude/skills/_operator-state.json` |

**Definiçêo de "done" por sub-fase**: cada sub-fase tem um ficheiro correspondente que deve ficar escrito com conteúdo real (nêo template vazio, nêo placeholders). Mínimo 100 caracteres de conteúdo útil.

**Tempo objetivo total**: 10-12 minutos. Se demorar mais, algo vai mal com o aprofundamento.

## Regras de aprofundamento

As perguntas concretas sêo decididas pelo agente em cada turno. Para cada resposta do utilizador, aplica estas regras:

### Sinais que pedem para aprofundar (faz 1 follow-up, nêo mais)

| Sinal na resposta | Movimento |
|---|---|
| Menos de 15 palavras numa dimensêo chave | "Conta-me mais" ou pede exemplo concreto |
| Cifra sem contexto ("faturo 30K") | Pergunta tendência ou ticket médio |
| Adjetivo abstrato ("cliente difícil") | Pede exemplo da última semana |
| Generalidade sem substância ("ajudo as pessoas") | Reformula: "pessoas como? Pinta-me o cliente perfeito" |
| Contradiçêo aparente entre respostas | Pede clarificaçêo 1 linha, sem julgar |

### Sinais que pedem para NêO aprofundar (passa à dimensêo seguinte)

| Sinal | Movimento |
|---|---|
| Resposta rica e completa (>50 palavras com dados concretos) | Salta para a seguinte. Nêo insistas |
| Utilizador diz "nêo sei", "ainda nêo", "depois" | Aceita. Aponta "(por definir)" e propõe skill concreta |
| Respostas curtas seguidas (3+ turnos) | Sinal de fadiga. Acelera, salta dimensões com dado mínimo |
| Utilizador mostra urgência ("seguinte", "já está") | Respeita. Fecha a sub-fase atual e commit |

## Anti-formulário (proibido explicitamente)

- ❌ Dizer "pergunta 3 de 10" ou qualquer numeraçêo visível
- ❌ Anunciar a pergunta seguinte antes de a fazer
- ❌ Fazer 2 perguntas no mesmo turno (exceto abertura: "como te chamas e onde vives?")
- ❌ Listas de bullets nas TUAS respostas durante a entrevista (só em fechos)
- ❌ Repetir literalmente a resposta do utilizador "para confirmar"
- ❌ Anunciar "agora passamos a W2" — as sub-fases sêo internas do wizard, NêO do utilizador
- ❌ Usar emojis durante a entrevista (sim em fechos)

---

## Process — 4 sub-fases com commits incrementais

### Antes de começar: leitura de estado

Ao ser invocado, **antes** de cumprimentar o utilizador:

1. Lê `~/.claude/skills/_install-state.json` com a tool `Read`.
2. Localiza `phases.context-files.filesCreated` — isto diz-te que ficheiros já estêo escritos de uma sessêo anterior.
3. Identifica a sub-fase pendente:
   - Se `context/me.md` nêo estiver em filesCreated → começar em W1
   - Se `me.md` sim mas `work.md` nêo → começar em W2 (cumprimenta dizendo "Continuemos onde ficámos. Já sei o teu nome e onde estás. Agora conta-me do teu negócio...")
   - Se `me.md` e `work.md` estiverem mas faltarem `current-priorities.md` ou `goals.md` → começar em W3
   - Se os 4 ficheiros de context estiverem mas `operator-state.status != "done"` → começar em W4

**Se retomas a meio, NêO repitas a abertura completa**. Só diz "Continuemos. Já temos X. Vamos com Y."

### W1 · Identidade (dimensões 1-2)

**Abertura** (só se nêo estás a retomar):
```
Bem-vindo ao iAmasters OS.

Antes de te gerar qualquer coisa, preciso de te conhecer um pouco. Nêo é
um formulário — é uma conversa rápida. Eu pergunto, tu contas-me,
e se algo me parecer interessante peço-te mais detalhe.

Demora ~10 minutos e só se faz uma vez. O bom: se te interromperes,
retomamos exatamente onde ficaste, nêo se perde nada.

Começamos? Diz-me o teu nome e onde vives.
```

Captura nome + localizaçêo + idioma operacional. Se faltou algo, pergunta UM follow-up.

**Quando tiveres dimensões 1+2 com dado sólido:**

1. **COMMIT imediato**: escreve `context/me.md` com a tool `Write`:
   ```markdown
   # me.md — quem sou

   ## Nome
   <nome>

   ## Localizaçêo
   <cidade, país>

   ## Idioma operativo
   <idioma>

   ## Frase pro (descriçêo profissional em 1 frase)
   <se a deu, vai aqui; se nêo, escreve "(por definir — o wizard insistirá em W4 se aplicar)">

   ---
   *Última atualizaçêo: <data atual>*
   *Gerado por: meta-onboarding-wizard · sub-fase W1*
   ```

2. **Atualizar state**: usa a tool `Bash` para adicionar o ficheiro à lista `filesCreated`:
   ```bash
   node -e "
   const fs = require('fs');
   const p = process.env.HOME + '/.claude/skills/_install-state.json';
   const s = JSON.parse(fs.readFileSync(p, 'utf8'));
   if (!s.phases['context-files'].filesCreated.includes('context/me.md')) {
     s.phases['context-files'].filesCreated.push('context/me.md');
   }
   s.phases['context-files'].status = 'in-progress';
   if (!s.phases['context-files'].startedAt) {
     s.phases['context-files'].startedAt = new Date().toISOString();
   }
   s.phases['context-files'].filesPending = s.phases['context-files'].filesPending.filter(f => f !== 'context/me.md');
   s.lastUpdatedAt = new Date().toISOString();
   s.currentPhase = 'context-files';
   fs.writeFileSync(p, JSON.stringify(s, null, 2));
   console.log('[wizard W1] me.md committed');
   "
   ```

3. **NêO digas ao utilizador "guardei em me.md"** — encadeia natural a W2:
   > "OK, já te tenho localizado. Vamos ao negócio: a que te dedicas?"

### W2 · Negócio (dimensões 3-6)

Cobre por esta ordem (mas sem anunciar):
1. **Negócio principal** — "A que te dedicas? Conta-mo como o contarias a alguém num jantar."
2. **Modelo de receitas** — Derivado de 1. Se nêo ficou claro: "De onde vem o dinheiro hoje? Serviços, produtos, subscrições, mix..."
3. **Cliente ideal** — "Pinta o teu cliente perfeito. Setor, tamanho, momento em que chega a ti."
4. **Stack diário** — "Com que ferramentas trabalhas dia a dia? As imprescindíveis."

Aplica regras de aprofundamento. Se uma resposta cobre 2 dimensões, marca-as e avança.

**Quando tiveres dimensões 3-6 com dado sólido:**

1. **COMMIT imediato**: escreve `context/work.md`:
   ```markdown
   # work.md — o meu negócio

   ## O que faço
   <negócio principal, 2-3 linhas>

   ## Modelo de receitas
   <serviços / produtos / subscriçêo / mix, com detalhe>

   ## Cliente ideal (descriçêo inicial)
   <setor, tamanho, momento, dor principal — o que tivermos>

   ## Stack diário
   <ferramentas mencionadas, em bullets>

   ## Cifras-chave (se as deu)
   <revenue / ticket / volume, se foram mencionadas>

   ---
   *Última atualizaçêo: <data>*
   *Para aprofundar: executa /deep-dive quando estiveres pronto*
   ```

2. **Atualizar state** (igual que W1, adicionar `context/work.md` a `filesCreated`).

3. Encadear a W3:
   > "OK, já tenho claro a que te dedicas. Última parte antes do fecho: o que tens no radar?"

### W3 · Foco (dimensões 7-8)

1. **Foco do mês** — "Em que estás centrado ESTE mês? Se tivesses de escolher 2-3 coisas para levar à frente."
2. **Objetivo 12 meses** — "Olha-te daqui a 12 meses. O que tem de acontecer para dizeres 'o ano valeu a pena'?"

**Quando tiveres dimensões 7+8:**

1. **COMMIT imediato**: dois ficheiros.

   `context/current-priorities.md`:
   ```markdown
   # current-priorities.md — foco este mês

   ## Top prioridades (ordem de impacto)
   1. <prioridade 1>
   2. <prioridade 2>
   3. <prioridade 3, se a deu>

   ## Porque importam
   <contexto que deste sobre porque estas e nêo outras>

   ---
   *Atualizado: <data>*
   *Refresh recomendado: mensal ou quando mudarem as circunstâncias*
   ```

   `context/goals.md`:
   ```markdown
   # goals.md — meta a 12 meses

   ## Onde quero estar daqui a 12 meses
   <descriçêo literal ou reformulada do operador>

   ## Métricas / sinais de sucesso
   <se as deu, em bullets; se nêo, "(por definir em /deep-dive)">

   ---
   *Atualizado: <data>*
   *Refresh recomendado: trimestral*
   ```

2. **Atualizar state**: adicionar ambos a `filesCreated`.

3. Encadear a W4:
   > "Quase. Última coisa, 3 perguntas técnicas rápidas para configurar o sistema."

### W4 · Config técnica + fecho context-files

3 perguntas seguidas (SIM rápidas e diretas — sêo técnicas):

1. "Qual é o teu nível técnico? Zero (nunca mexeste num terminal) / intermédio / avançado"
2. "Idioma dos outputs para os teus clientes? Português / inglês / bilingue / outro"
3. "Tens Firecrawl API key? Se nêo, salto-a e o sistema funciona na mesma com fallback manual."

**Quando tiveres as 3 respostas:**

1. **Inicializar headers de ficheiros auxiliares** (`team.md`, `decisions-log.md`, `learnings.md`, `soul.md`) se nêo existirem — `install.sh` já os criou vazios, nêo os reescrevas.

2. **COMMIT a `~/.claude/skills/_operator-state.json`**: atualizar o JSON com os dados recolhidos. Usa Bash:
   ```bash
   node -e "
   const fs = require('fs');
   const p = process.env.HOME + '/.claude/skills/_operator-state.json';
   const s = JSON.parse(fs.readFileSync(p, 'utf8'));
   s.needsOnboarding = false;
   s.onboardingDate = new Date().toISOString().slice(0,10);
   s.operator = s.operator || {};
   s.operator.name = '<nome>';
   s.operator.location = '<localizaçêo>';
   s.operator.language = '<idioma>';
   s.operator.technicalLevel = '<resposta>';
   s.operator.clientOutputLanguage = '<resposta>';
   s.firecrawlAvailable = <true|false>;
   s.welcomeCompleted = false;
   s.deepDiveCompleted = false;
   s.lastUpdated = new Date().toISOString();
   fs.writeFileSync(p, JSON.stringify(s, null, 2));
   console.log('[wizard W4] operator-state committed');
   "
   ```

3. **Se o utilizador deu Firecrawl key**: adicioná-la a `.env` (`FIRECRAWL_API_KEY=...`).

4. **Marcar ambas as fases `done` em `_install-state.json`**:
   ```bash
   node -e "
   const fs = require('fs');
   const p = process.env.HOME + '/.claude/skills/_install-state.json';
   const s = JSON.parse(fs.readFileSync(p, 'utf8'));
   const now = new Date().toISOString();

   // context-files done
   s.phases['context-files'].status = 'done';
   s.phases['context-files'].validatedAt = now;
   if (!s.completedPhases.includes('context-files')) s.completedPhases.push('context-files');

   // operator-state done
   s.phases['operator-state'].status = 'done';
   s.phases['operator-state'].validatedAt = now;
   s.phases['operator-state'].fields = {
     needsOnboarding: false,
     onboardingDate: now.slice(0,10),
     technicalLevel: '<resposta>',
     clientOutputLanguage: '<resposta>'
   };
   if (!s.completedPhases.includes('operator-state')) s.completedPhases.push('operator-state');

   s.currentPhase = 'welcome-completed';
   s.lastUpdatedAt = now;
   fs.writeFileSync(p, JSON.stringify(s, null, 2));
   console.log('[wizard W4] context-files + operator-state marked done');
   "
   ```

5. **Validaçêo pós-commit** (defesa contra "instalaçêo fantasma"):
   - Confirma que os 4 ficheiros em `context/` existem e cada um tem >100 chars.
   - Se algum falhar, NêO marques `done`. Avisa o utilizador, marca a fase como `in-progress` e para.

### W5 · Transiçêo a welcome-quick-win

Mensagem:

```
🎉 Setup mínimo completo. Tenho:

  ✓ A tua identidade e onde estás
  ✓ O teu negócio principal e a quem serves
  ✓ O teu stack diário
  ✓ O teu foco este mês e a tua meta a 12 meses

Vou gerar-te o teu primeiro entregável real agora. ~5 min. Fica-te
um HTML partilhável.

Vamos?
```

Se "sim": invoca `welcome-quick-win`. Essa skill marca `phases.welcome-completed.status = "done"` ao terminar.

Se "nêo" ou "depois":
- Marca `pausedBy: "user"`, `pausedAtPhase: "welcome-completed"` em `_install-state.json`.
- Despede-te: "OK. Quando voltares, lembro-te com `/install --resume`. O sistema fica funcional embora sem o primeiro entregável."

### W6 · Anúncio de deep-dive

Após `welcome-quick-win` (ou se disse "depois"):

```
Última coisa antes de fechar.

O de hoje foi o mínimo. O sistema já funciona, mas conhece-te ainda
superficialmente. Se queres que os outputs saiam mesmo na tua voz,
há uma skill chamada `meta-deep-dive` que aprofunda outras 20-25 áreas:
os teus ritmos, o teu modelo financeiro, a tua equipa, a tua
definiçêo de sucesso.

Demora ~25 minutos. Recomendo para amanhê, nêo hoje.

Quando quiseres, executa:  /deep-dive

Boa sorte. Vemo-nos amanhê.
```

---

## Comportamento perante interrupções

**Utilizador diz "para", "fecha", "nêo quero continuar":**
1. NêO marques nada como `done` que nêo esteja efetivamente `done`.
2. O que tenhas comitado de ficheiros já está persistido em disco.
3. Atualiza `_install-state.json`: `pausedBy: "user"`, `pausedAt: <now>`, `pausedAtPhase: <sub-fase atual>`.
4. Mensagem breve: "Sem problema. Guardámos o que já temos. Quando voltares, `/install --resume` retoma daqui."
5. NêO insistas. NêO peças confirmaçêo. NêO digas "de certeza?".

**Sessêo parte (context window, erro)**:
- O último comitado a disco persiste.
- A sessêo seguinte: o hook `_install-gate.sh` detetará `phases.context-files.status: "in-progress"` e guiará o utilizador para `/install --resume`.
- A nova execuçêo do wizard lê `filesCreated` e arranca na primeira sub-fase que tenha ficheiros pendentes.

**Utilizador é curioso sem negócio ativo**:
- Em W2, marca `avatar: "curioso"` em operator-state, salta a W3 com "Sem negócio ativo ainda, OK. Passamos ao teu foco."
- Anota em work.md: "Sem negócio ativo. Quando o tiveres, reexecuta o wizard."

**Utilizador responde a tudo num parágrafo gigante**:
- Extrai as 8 dimensões desse parágrafo. NêO peças desdobramento.
- Só aprofundas dimensões que ficaram fracas.
- Confirma com o utilizador antes de comitar cada ficheiro: "Vou anotar X, Y, Z. Vai?"

---

## Edge cases técnicos

- **`_install-state.json` nêo existe quando o wizard arranca**: o wizard NêO foi invocado pelo install.sh corretamente. Avisa o utilizador: "O installer técnico nêo foi executado. Sai do Claude Code e executa `bash scripts/install.sh` a partir do terminal."
- **`_install-state.json` existe mas `phases.sinapsis-engine` nêo está `done`**: Sinapsis nêo está bem instalada. Avisa e deriva para `bash scripts/install.sh --resume`.
- **O operator-state.json já existe com dados prévios**: NêO o sobrescrevas em bloco. Faz merge: preserva campos nêo tocados pelo wizard.
- **Firecrawl key parece fake** (nêo começa por `fc-` ou tem menos de 20 chars): pede-a outra vez com suavidade ou marca-a como `firecrawlAvailable: false`.

## Outputs (ao fechar corretamente)

- `context/me.md`, `work.md`, `current-priorities.md`, `goals.md` — escritos com conteúdo real
- `context/team.md`, `decisions-log.md`, `learnings.md`, `soul.md` — inicializados com header (foi o `install.sh`)
- `~/.claude/skills/_operator-state.json` — campos críticos preenchidos
- `~/.claude/skills/_install-state.json` — `context-files.status = "done"`, `operator-state.status = "done"`
- `.env` com Firecrawl se aplicável

## Skills que chama

- **`welcome-quick-win`** — no fim de W4, para gerar primeiro entregável (essa skill marca `welcome-completed: done`)

## Skills que recomenda ao fechar

- **`meta-deep-dive`** — para as 22 dimensões restantes
