---
name: decisions-log
description: Mantém um diário append-only de decisões importantes do operador, com formato fixo (data · decisêo · raciocínio · contexto). Usa-o quando o utilizador tomar uma decisêo estratégica que quererá recordar mais à frente, ou quando outra skill (six-hats, marketing-positioning, pricing-strategy) fechar com uma conclusêo decidida. O log vive em `context/decisions-log.md` e o Claude lê-o ao arrancar cada sessêo para nêo se contradizer com decisões anteriores.
---

# decisions-log

> **Crédito**: este padrêo está inspirado diretamente em [`Luispitik/claude-code-second-brain`](https://github.com/Luispitik/claude-code-second-brain) de Luis Pitik (mesmo autor de Sinapsis). O conceito de "decision journal append-only que o Claude lê para manter coerência entre sessões" é dele. Mantemos o formato exato e referenciamos o repo original.

## Quando é invocada

- Utilizador diz: "regista esta decisêo", "quero lembrar-me disto", "anota que decidimos X"
- Outra skill fecha com uma decisêo clara e propõe gravá-la (six-hats, pricing-strategy, marketing-positioning, etc.)
- Fecho de sessêo (`/wrap-up`) deteta uma decisêo tomada que nêo foi registada e propõe gravá-la
- Utilizador pergunta: "o que decidimos sobre Y?" → a skill procura no log

## Por que importa

Claude Code (mesmo com Sinapsis) pode contradizer-se entre sessões se uma decisêo antiga nêo lhe for lembrada. O operador também esquece — e pior, *muda de opiniêo sem se aperceber*. Um log append-only força a:
1. Tornar as decisões explícitas no momento em que se tomam
2. Ter o "porquê" registado (nêo só o "o quê")
3. Comparar a versêo atual com o decidido antes (quando alguém sugere mudar)
4. Gerar um track record honesto do operador ao longo do tempo

## Formato canónico

Cada entrada em `context/decisions-log.md` segue exatamente esta estrutura:

```markdown
## YYYY-MM-DD · <título curto, ≤60 chars>

**Decisêo**: <1 frase clara com o quê>

**Raciocínio**: <2-4 frases com o porquê — inclui os dados ou
sinais que levaram à decisêo, nêo só "porque sim">

**Contexto**: <1-2 frases com a situaçêo mais ampla que explica
porque esta decisêo fazia sentido neste momento. Crucial para
reavaliar amanhê.>

**Quando reconsiderar**: <critério concreto que faria rever a
decisêo — evento, métrica, data. NêO "se correr mal".>

---
```

## Process

### Passo 1 · Detetar que há decisêo

Uma decisêo qualifica para o log se cumprir PELO MENOS 2 de:
- **É nêo trivial** — afeta o negócio, um cliente, o posicionamento, a equipa, ou o tempo do operador em >2h/semana
- **Tem reversibilidade limitada** — custaria tempo/dinheiro/relações revertê-la
- **Vai influenciar futuras conversas com o Claude** — o sistema devia mantê-la coerente

Se a "decisêo" for operativa pequena (que cor usar, que hora de reuniêo, que ficheiro nomear), NêO vai para o log. Para isso há tarefas e notas, nêo decisions journal.

### Passo 2 · Ler o log existente

Antes de adicionar, lê `context/decisions-log.md` completo (ou se for muito longo, as últimas 20 entradas) para:
- Detetar se esta decisêo **contradiz** uma anterior — entêo há que registar a inversêo, nêo só adicionar
- Detetar se esta decisêo **complementa** uma anterior — referenciar a entrada anterior com `(refina <YYYY-MM-DD · título>)`
- Verificar que o formato canónico se mantém consistente

### Passo 3 · Confirmar com o utilizador os 4 campos

Pergunta por ordem:

```
1. Título curto (≤60 chars):
2. Decisêo em 1 frase:
3. Raciocínio (os dados/sinais que te levaram aqui):
4. Quando devíamos reconsiderar esta decisêo (que evento ou métrica):
```

Se o utilizador for lacónico ou nêo quiser escrever, propõe tu um draft baseado na conversa que acabaram de ter. Pede-lhe "ok" ou ajustes.

O **Contexto** redige-lo tu a partir do estado do operator-state + o que tenhas observado na conversa. NêO o perguntes — seria pedir ao utilizador para explicar o óbvio.

### Passo 4 · Append no log

Edita `context/decisions-log.md` adicionando a nova entrada NO FIM do ficheiro, seguindo o formato canónico exato.

**Nunca edites entradas existentes.** Se uma decisêo for invertida, escreve nova entrada com título tipo "Invertemos decisêo de YYYY-MM-DD: agora fazemos X" e referência explícita.

### Passo 5 · Confirmar e propor seguinte

Após o append, mostra ao utilizador:

```
✅ Registada: <título da decisêo>

Total de decisões gravadas: <N>
Tempo desde a última decisêo: <X dias>

Há outra decisêo de hoje que devíamos gravar?
```

### Passo 6 · Fecho

- Se a decisêo gravada **inverter** uma anterior, propõe no wrap-up atualizar `~/.claude/skills/_operator-state.json` para que a operaçêo diária reflita a nova direçêo
- Se esta for a 5ª, 10ª ou 25ª decisêo gravada, celebra brevemente — o log torna-se útil exponencialmente com cada nova entrada

## Leitura do log ao arrancar sessêo

`meta-start-here` e `meta-onboarding-wizard` devem ler as últimas 5 entradas do log ao arrancar e mencioná-las se forem relevantes para a conversa que começa.

Exemplo de mensagem ao arrancar:

```
Lembretes do decisions-log:
- (há 3 dias) Decidiste pausar lançamentos em julho e centrares-te no produto.
  Continua a ser o plano ou mudamos?
- (há 12 dias) Decidiste subir preços anuais para €497.
  Já o aplicaste ou fica pendente?
```

## Outputs

- Append em `context/decisions-log.md`
- Opcional: update em `~/.claude/skills/_operator-state.json` se a decisêo muda o estado atual do operador

## Skills que chama

Nenhuma diretamente. Esta skill é invocada **por** outras (six-hats, pricing-strategy, marketing-positioning, etc.) quando essas fecham com decisêo.

## Edge cases

- **Log vazio (primeira vez)**: adicionar um header ao ficheiro:
  ```markdown
  # Decisions log

  Diário append-only de decisões do operador.
  Padrêo inspirado em [claude-code-second-brain](https://github.com/Luispitik/claude-code-second-brain) de Luis Pitik.

  ---
  ```
  Depois adiciona a primeira entrada normal.

- **Decisêo muito emocional / impulsiva**: pergunta ao utilizador "queres dormir 24h sobre isto antes de gravar? As decisões impulsivas no log vêo confundir-te mais à frente." Se insistir, regista-a com tag `[impulsiva]` no título.

- **Decisões contraditórias dentro da mesma sessêo**: se o utilizador decide A, depois diz B, regista como entrada única "Mudança de opiniêo durante sessêo: primeiro A, agora B" com raciocínio do porquê mudou.

- **Decisêo sobre cliente concreto vs decisêo pessoal**: se for de cliente, vai para o log do cliente (`clients/<nome>/context/decisions-log.md`). Se for pessoal/operador, para a raiz. Em caso de dúvida, raiz.

- **Decisêo que requer comunicaçêo à equipa**: depois de a gravar, propõe ao utilizador redigir o comunicado à equipa (via `marketing-copywriting` ou draft direto).

## Examples

### Exemplo de entrada bem formada

```markdown
## 2026-05-08 · Pausar sprint v0.5.0 até validar v0.4.3

**Decisêo**: pausar o sprint planeado de adicionar 7 skills novas ao iamasters-os (v0.5.0) até ter lançado v0.4.3 com os fixes de plug-and-play e validado em uso real.

**Raciocínio**: a sessêo de planning aplicando 6 chapéus mostrou que o problema central nêo é catálogo (12 → 19 skills) mas sim fricçêo de onboarding. Adicionar mais skills sobre um onboarding partido multiplica fricçêo. Além disso, a liçêo de ontem à noite com o cockpit (RUBRIC) reforça: validar contra uso real antes de continuar a construir.

**Contexto**: iamasters-os v0.4.2 publicado no GitHub com 12 skills + atribuiçêo completa mas sem ter sido instalado ainda por nenhum membro da iAmasters Academy. Sprint v0.5.0 estava previsto imediatamente. v0.4.3 introduz: refactor README+AGENTS para auto-instalaçêo URL conversacional, /doctor, welcome-quick-win, six-hats, decisions-log, sectorizaçêo context/, vídeos Loom 60s.

**Quando reconsiderar**: se após release v0.4.3 + envio ao Luis para feedback, validaçêo com 5+ membros mostrar que o catálogo de 18 skills está bem mas faltam skills específicas concretas. Entêo v0.5.0 com essas, nêo as 7 originalmente planeadas às cegas.

---
```

### Exemplo de inversêo de decisêo

```markdown
## 2026-06-10 · Invertemos decisêo 2026-04-15: volta o Free Trial 7 dias

**Decisêo**: reativar o Free Trial de 7 dias para iAmasters, eliminado a 6-abril-2026.

**Raciocínio**: após 2 meses sem trial, os dados mostram que o funil "lançamento de 6 em 6 semanas" tem gap entre lançamentos onde nêo entra ninguém. Trial 7 dias preenchia esse gap. CAC trial €54 com conversêo de 32.6% continua a ser o melhor modelo numérico que temos.

**Contexto**: decisêo 2026-04-15 eliminou trial pensando que o modelo "comunidade fechada + lançamentos" era suficiente. Após 60 dias: MRR baixou de €45K para €42K. A previsêo de "trial canibaliza lançamentos" nêo se confirma com os dados.

**Quando reconsiderar**: se após 60 dias com trial reativado, MRR nêo recuperar trajetória para €50K, entêo o problema nêo era o trial — investigar outra hipótese.

---
```

## Notas operativas

- **Nunca apagues entradas do log**, nem as edites a posteriori. O log é histórico imutável. Se algo mudar, NOVA entrada.
- **Uma sessêo NêO deve gerar mais de 3 entradas**. Se for mais, provavelmente estás a registar ruído. Pergunta-te quais sêo nêo triviais.
- **As entradas mais úteis sêo as que doem registar** — as que admites um erro, mudas de opiniêo, ou decides algo que vai contra o teu instinto. Essas é que o log ajuda a respeitar.
- **O log é só do operador**, nêo de cada cliente. Para clientes há um decisions-log dentro de `clients/<nome>/context/`.
