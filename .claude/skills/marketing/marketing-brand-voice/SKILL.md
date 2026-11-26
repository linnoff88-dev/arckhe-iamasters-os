---
name: marketing-brand-voice
version: 2.0.0
description: Gera o voice profile completo do operador com 3 registos (A formal, B divulgativo, C próximo). Mecânica de dupla via (artefactos reais ou simulaçêo guiada) que capta voz autêntica mesmo que o operador nêo tenha presença online. Combina interview direta + Firecrawl scraping de URLs públicas + 5 simulações por registo. Output para brand-context/voice/ com 8 ficheiros: voice-profile.md, samples.md, register-{a,b,c}.md, audit-prompt.md, vocabulary.md, installation.md. É invocada pelo onboarding wizard após a identidade.
---

# marketing-brand-voice · v2.0

## Alterações face à v1.0

- **Dupla via artefactos vs simulaçêo** · por registo · acessível para operadores sem presença online
- **15 simulações reais** (5 por registo) que captam voz autêntica
- **3 ficheiros novos**: `audit-prompt.md`, `vocabulary.md`, `installation.md`
- Mantém: Firecrawl auto-scraping, spectrum 0-10, anti-modelo/modelo a aspirar, integraçêo OS

## Quando é invocada

- `meta-onboarding-wizard` chama-a depois de configurar a identidade básica
- Utilizador invoca: "configura o meu brand voice", "extrai a minha voz", "refaz o voice profile"
- Quando se deteta drift nos outputs (humanizer baixa consistentemente) e se sugere refinar a voz

## Process

### Passo 1 · Detetar inputs disponíveis

Pergunta ao operador (usa AskUserQuestion):

1. **Web própria / blog**: URL (opcional)
2. **LinkedIn pessoal**: URL (opcional)
3. **Canal de YouTube**: URL (opcional, com 5+ vídeos)
4. **Twitter/X**: URL (opcional)
5. **Documentos próprios**: tens copy já escrito que represente a tua voz? (newsletter, post fixado, etc.) Cola ou indica o path para o ficheiro
6. **Voice profile prévio**: já tens um voice profile feito noutro lado? Cola o que quiseres integrar

### Passo 2 · Deteçêo de via global *(novo na v2)*

Pergunta-chave ao operador para decidir como captar a voz:

```
És uma pessoa ativa nas redes / escreves muito online (LinkedIn, Instagram, emails, blog, threads no X)?

(a) Sim, escrevo muito e tenho arquivo
(b) Nêo, escrevo pouco ou nada online
(c) Misto · escrevo em alguns canais mas noutros nêo
```

Conforme resposta:
- **(a) → Via artefactos global**: no Passo 4 vai pedir material real para cada registo (apoiado por scraping)
- **(b) → Via simulaçêo global**: no Passo 4 vai fazer simulações reais por registo · capta voz autêntica
- **(c) → Via híbrida**: decide por cada registo conforme material disponível

Anota a via atribuída por registo (A, B, C) para a usar no Passo 4.

### Passo 3 · Scrapear URLs (se existirem)

Se no Passo 1 foram fornecidas URLs, invocar `tool-firecrawl-scraper`:
```json
{
  "urls": [...],
  "format": "markdown",
  "extract_assets": true
}
```

Output esperado: conteúdo markdown + assets em `brand-context/assets/`.

### Passo 4 · Captura por registo · dupla via *(novo na v2)*

Trabalha **um registo de cada vez**. Anuncia o bloco, executa a via atribuída no Passo 2, valida, passa ao seguinte.

---

#### Registo A · Profissional / Formal

Anuncia: *"Começamos pelo registo profissional. É como falas quando representas a tua marca ou quando há um cliente potencial do outro lado: LinkedIn, emails formais, propostas comerciais."*

**Se Via artefactos** (ou se o Passo 3 já scrapeou o LinkedIn):
- Pede 3-5 posts de LinkedIn (os mais representativos, nêo os virais por acaso)
- Pede 2-3 emails que tenha enviado a clientes potenciais
- Pede 1-2 propostas comerciais ou documentos formais

**Se Via simulaçêo**:
Lança as 5 simulações uma a uma. Espera resposta antes de passar à seguinte:

1. *"Um cliente potencial escreve-te por LinkedIn: 'Olá, vi o teu perfil. Trabalhamos num B2B SaaS e queremos integrar IA no nosso pipeline de vendas. Tens 20 minutos para te contar?' Responde-lhe."*

2. *"Tens de mandar um email a um cliente a quem entregaste um projeto há 3 meses e que nêo voltou a contratar. Queres reativar a relaçêo sem pressionar. Escreve-o."*

3. *"Estás a escrever o primeiro parágrafo de uma proposta comercial. O cliente é uma empresa de média dimensêo que quer migrar os seus processos para um sistema agéntico. Escreve o parágrafo de abertura."*

4. *"Um post de LinkedIn tipo: vais explicar porque é que a maioria das empresas que diz 'usar IA' na verdade só usa ChatGPT. 3-5 linhas no máximo."*

5. *"Um cliente pergunta-te porque é que a tua proposta é mais cara que a do concorrente. Responde-lhe com calma mas sem te justificares."*

---

#### Registo B · Divulgativo

Anuncia: *"Agora o registo divulgativo. É como falas quando ensinas, divulgas ou crias conteúdo para audiência ampla: Reels, captions de Instagram, posts de blog, newsletters, podcasts, YouTube."*

**Se Via artefactos** (ou se o Passo 3 já scrapeou Instagram/blog):
- 3-5 captions de Instagram
- 1-2 posts de blog (se existirem)
- Transcrições de Reels/TikToks/Shorts representativos
- 1-2 newsletters próprias

**Se Via simulaçêo**:

1. *"Tens 90 segundos para gravar um Reel a explicar o que é uma skill de IA. Escreve o que dirias à câmara, sem guiêo, no teu tom natural."*

2. *"Caption de Instagram para acompanhar uma foto tua a trabalhar. Queres aterrar o que faz alguém que diz 'sou operador IA'. 4-6 linhas."*

3. *"Começas um post de blog intitulado 'Porque é que 90% das pessoas que dizem usar IA na verdade a estêo a usar mal'. Escreve os primeiros 3 parágrafos."*

4. *"Estás em direto numa aula da tua comunidade. Acabaste de mostrar uma demo de uma skill. Fecha o bloco a transitar para o próximo tema."*

5. *"Explicas ao teu cunhado que nêo percebe nada de tecnologia o que é o Claude Code. Sem jargêo, sem condescendência. 3-4 frases."*

---

#### Registo C · Conversacional / Próximo

Anuncia: *"Último registo. O conversacional. É como falas com a tua gente próxima: WhatsApp com amigos, DMs, notas de voz, mensagens à equipa. Aqui sai a tua voz mais autêntica."*

**Se Via artefactos**:
- 5-8 mensagens de WhatsApp com amigos próximos (anonimiza-as se for preciso, NêO as reformules)
- Transcrições de notas de voz que mandes
- DMs de Instagram com pessoas de confiança

⚠️ Importante: NêO peças mensagens que o operador queira manter privadas. Em caso de dúvida, melhor via simulaçêo.

**Se Via simulaçêo**:

1. *"Um amigo escreve-te às 22h: 'pá acabei de ver o teu direto, fiquei em pulgas. diz-me o que faço para começar'. Responde-lhe."*

2. *"Estás num grupo de WhatsApp de amigos. Sai o tema 'a IA vai tirar todos os empregos'. Mete a tua opiniêo em 2-3 mensagens."*

3. *"Mandas uma nota de voz ao teu sócio a explicar-lhe rápido porque é que mudaste de opiniêo sobre um cliente. Transcreve-a como se a estivesses a falar."*

4. *"Um amigo pergunta-te por WhatsApp se vale a pena montar uma agência de IA agora. Respondes o que pensas a sério."*

5. *"Escreves a alguém que admiras (um criador, uma referência) por DM de Instagram para irem tomar um café. Sem pareceres fanboy."*

---

### Passo 5 · 6 perguntas calibradoras

Independentemente das URLs e da via do Passo 4, fazer 6 perguntas adicionais que captam dimensões que as simulações nêo cobrem bem:

**Pergunta 1 · Tom dominante** (multi-select):
- (a) Formal e autoridade — proposta corporativa
- (b) Divulgativo profissional — explicas com clareza sem ser corporate
- (c) Próximo e direto — como falas com um amigo
- (d) Provocador — opiniões fortes, sem medo de ofender
- (e) Caloroso e empático — humano, vulnerável
- (f) Técnico e específico — dados, números, precisêo

**Pergunta 2 · Vocabulário de que foges** (texto livre):
- "Que palavras nunca usas porque soam a corporate / a vende-banha / a AI?"

**Pergunta 3 · Frases-assinatura** (texto livre):
- "Há frases que repetes muito e sêo tuas? Dá-me 2-3"

**Pergunta 4 · Jargêo próprio** (texto livre):
- "Tens termos próprios ou do teu nicho que uses constantemente? (ex. 'operador IA', 'aterrar o sistema', 'no-fluff')"

**Pergunta 5 · Anti-modelos** (texto livre):
- "Diz-me uma conta de LinkedIn / um criador / um autor cujo tom DETESTAS. (Para o evitar)"

**Pergunta 6 · Modelo a aspirar** (texto livre):
- "Diz-me uma conta / autor / podcaster com um tom parecido ao que queres ter"

### Passo 6 · Análise combinada

Combinar todas as fontes:
- Texto scrapeado das URLs (se houve)
- Material de artefactos (se via A)
- Respostas às 15 simulações (se via B ou misto)
- Respostas das 6 perguntas calibradoras
- Voice profile prévio (se forneceu)

Extrair:

**Personalidade** (3-5 traits):
- É seguro / inseguro? Otimista / cauto? Concreto / abstrato? Caloroso / frio?

**Spectrum do tom** (quantificado 0-10):
- Formality: 0 (próximo) — 10 (formal)
- Directness: 0 (rodeios) — 10 (sem rodeios)
- Humor: 0 (sério) — 10 (muito humor)
- Authority: 0 (humilde) — 10 (afirmativo)
- Warmth: 0 (distante) — 10 (próximo)

**Vocabulário**:
- Palavras-assinatura (as que aparecem ≥3 vezes em samples scrapeados/simulações)
- Palavras proibidas (da pergunta 2 + AI tells do humanizer + as que NUNCA apareceram em simulações do seu registo mas sim em padrões de IA)
- Jargêo próprio (da pergunta 4)
- Muletas autênticas (palavras que repete muitas vezes e que fazem parte da sua assinatura)

**Estrutura típica** por registo:
- Comprimento médio de frase
- Uso de listas vs prosa
- Posiçêo da opiniêo (no início? no final? entrelaçada?)
- Como abre / como fecha

### Passo 7 · Validaçêo intermédia

ANTES de gerar os 8 ficheiros, devolver ao operador uma análise breve:

```
Tenho material dos 3 registos e das 6 perguntas. Antes de gerar o voice-profile final, devolvo-te o que deteto. Confirma se te encaixa:

**Registo Profissional (A):**
- Tom: [uma frase descritiva]
- Estrutura típica: [como abre, desenvolve, fecha]
- Palavras/frases recorrentes: [3-5 exemplos extraídos do material]
- O que NêO fazes: [2-3 coisas que evitas]

**Registo Divulgativo (B):** [mesmo formato]
**Registo Conversacional (C):** [mesmo formato]

**Spectrum global:**
- Formality: X/10
- Directness: X/10
- Humor: X/10
- Authority: X/10
- Warmth: X/10

Faz sentido? Há algo a matizar ou corrigir antes de eu gerar os ficheiros finais?
```

Espera confirmaçêo ou correçêo. Se o utilizador corrige, integra. Se diz "perfeito", passa ao Passo 8.

### Passo 8 · Geraçêo de output · 8 ficheiros

#### 8.1 · `voice-profile.md`

```markdown
# Voice Profile — [Nome operador]

> Gerado: YYYY-MM-DD · v2 (dupla via)
> Fontes: web + LinkedIn + 15 simulações + 6 perguntas calibradoras
> Via usada: artefactos / simulaçêo / misto

## Personalidade
- Trait 1
- Trait 2
- Trait 3

## Spectrum do tom
- Formality: X/10
- Directness: X/10
- Humor: X/10
- Authority: X/10
- Warmth: X/10

## Palavras-assinatura (uso frequente, marcam a voz)
- ...

## Vocabulário proibido (nunca usar)
- ...

## Jargêo próprio (termos do nicho que uso de forma natural)
- ...

## Muletas autênticas (NêO eliminar, fazem parte da minha marca)
- ...

## Estrutura típica por registo
**Registo A (Profissional):**
- Comprimento médio de frase: X palavras
- Listas vs prosa: 60/40 prosa
- Opiniêo: no início do bloco
- Cierre: pergunta aberta ou chamada concreta

**Registo B (Divulgativo):** [...]
**Registo C (Conversacional):** [...]

## Anti-modelo
- "Nêo quero soar como [criador X], cujo tom é [Y]"

## Modelo a aspirar
- "Tom parecido a [criador Z], cuja virtude é [W]"
```

#### 8.2 · `samples.md`

10-15 frases representativas:
- 5 de inputs scrapeados ou artefactos (extraídas com critério · nêo genéricas)
- 5 das 15 simulações (as mais autênticas)
- 5 sintéticas a seguir o voice profile (para validar internamente)

#### 8.3 · `register-a-formal.md`

```markdown
# Registo A · Formal

## Quando usá-lo
- Email a cliente premium ou C-level
- Proposta comercial
- Contrato ou documento legal
- Pitch a investidor

## Regras
- Frases longas e bem construídas (15-25 palavras)
- Vocabulário preciso, sem jargêo
- Zero emojis
- Sem abreviaturas

## Vocabulário permitido
[lista do voice-profile aplicada]

## Vocabulário proibido neste registo
[palavras do voice-profile que NêO se aplicam aqui]

## Template email cliente
[preencher conforme voice-profile + regras formais]

## Exemplo (das simulações ou samples)
[Frase do operador adaptada a tom formal]
```

#### 8.4 · `register-b-divulgativo.md`

```markdown
# Registo B · Divulgativo

## Quando usá-lo
- LinkedIn post / artigo
- Blog post
- Video script (YouTube, talk)
- Newsletter (corpo)
- Twitter thread (longos)

## Regras
- Frases mistas (10-20 palavras), variar ritmo
- Linguagem clara, sem jargêo desnecessário mas com jargêo próprio OK
- 0-2 emojis intencionais no máximo
- Apoiar-se em números concretos

## Estrutura típica para LinkedIn post
1. Hook (1-2 frases contundentes)
2. Contexto pessoal
3. Insight (a liçêo)
4. Detalhe concreto
5. Pergunta ou chamada no final

## Exemplo (rebuild de samples do operador)
[Sample do voice-profile reescrito em B]
```

#### 8.5 · `register-c-cercano.md`

```markdown
# Registo C · Próximo

## Quando usá-lo
- WhatsApp grupo comunidade
- Respostas a comentários em LinkedIn/Instagram
- DMs a leads quentes
- Mensagens Slack à equipa
- Captions curtas em stories

## Regras
- Frases curtas (5-12 palavras)
- Tom coloquial, contrações permitidas
- 1-3 emojis OK se forem relevantes
- Tutear sempre

## Vocabulário permitido
[palavras-assinatura + slang próprio + casual]

## Exemplo
[Uma das simulações do registo C do operador]
```

#### 8.6 · `audit-prompt.md` *(novo na v2)*

```markdown
# Audit Prompt — Brand Voice Checker

Prompt de sistema para auditar se um texto está na tua voz ou nêo.

## Como usá-lo

Cola-o como instruçêo de sistema (Claude Project, ChatGPT GEM, instruçêo inicial) acompanhado do teu `voice-profile.md`. Depois passa-lhe qualquer texto a auditar.

## Prompt

És um auditor de voz de [Nome do operador]. A tua única missêo é verificar se um texto está escrito na voz de [Nome], e em que registo (A profissional / B divulgativo / C conversacional).

Procedimento:
1. Lê o voice-profile.md em anexo.
2. Lê o texto a auditar.
3. Identifica o registo provável conforme o contexto (LinkedIn = A, Reel = B, WhatsApp = C).
4. Audita em 4 dimensões:
   - Tom (coincide com o registo?)
   - Estrutura (usa a estrutura típica do registo?)
   - Vocabulário (usa palavras-assinatura? usa anti-vocabulário?)
   - Spectrum 0-10 (ajusta-se aos valores do operador?)
5. Dá uma pontuaçêo de 0 a 10 por dimensêo.
6. Marca com ✗ as palavras/frases que sêo anti-voz e propõe substituiçêo concreta.
7. Devolve uma versêo corrigida só se a pontuaçêo geral for < 7.

Output formato:
- Registo detetado: [A/B/C]
- Pontuaçêo geral: X/10
- Detalhe por dimensêo: T:X E:X V:X S:X
- Anti-voz detetada: [lista com substituições]
- Versêo corrigida: [só se <7]
```

#### 8.7 · `vocabulary.md` *(novo na v2)*

```markdown
# Vocabulary · [Nome operador]

## Palavras e frases que USAS

### Registo A · Profissional
- [palavra] — contexto: [exemplo de uso]
- [10-15 entradas]

### Registo B · Divulgativo
- [10-15 entradas]

### Registo C · Conversacional
- [10-15 entradas]

## Palavras e frases que NUNCA usas (anti-vocabulário)

### Anti-corporate (nêo em A)
- "Estimado/a", "Cordialmente", "Fico ao seu dispor"
- [palavras detetadas da análise]

### Anti-hype (nêo em B)
- "Game changer", "Revolucionário"
- [específicos conforme análise]

### Anti-genérico de IA (nêo em nenhum registo)
- "Nêo só X mas também Y"
- "No mundo atual..."
- [outros AI tells do humanizer]

## Muletas autênticas

Palavras/frases que repetes muito de forma natural. NêO eliminar · fazem parte da tua marca:
- [Muleta 1]
- [3-5 mais]
```

#### 8.8 · `installation.md` *(novo na v2)*

```markdown
# Como instalar o teu Voice Profile em qualquer sistema

## Opçêo 1 · iAmasters OS (este repo)

Já está instalado. As skills `marketing-*` usam-no automaticamente ao iniciar sessêo.

## Opçêo 2 · Claude (Claude Desktop ou claude.ai)

1. Cria um Project novo ou edita o atual
2. Em "Project Instructions" cola o conteúdo do `voice-profile.md`
3. Adiciona no final: "Antes de responder a qualquer prompt, escreve no registo indicado do voice-profile. Se nêo for indicado registo, pergunta qual usar."

## Opçêo 3 · ChatGPT GEM

1. ChatGPT → "Criar um GEM"
2. Nome: "A minha voz · [O teu nome]"
3. Instruções: cola `voice-profile.md`
4. Knowledge: sobe `voice-profile.md` + `vocabulary.md`
5. Conversation starters: "Escreve no meu registo A", "Audita este texto com a minha voz"

## Opçêo 4 · Qualquer LLM

No início de cada sessêo, cola:

> Aqui está o meu voice profile. Lê-o. Tudo o que gerares a seguir deve estar num dos meus 3 registos. Se nêo souberes qual usar, pergunta-me.
> [conteúdo de voice-profile.md]

## Manutençêo

- Cada 3 meses revê o teu voice-profile.md. A tua voz evolui.
- Se fizeres alterações grandes (nova linha de negócio, mudança de tom), volta a executar `marketing-brand-voice`.
- O `audit-prompt.md` serve para verificar outputs suspeitos. Usa-o quando um output "nêo te soar a ti".
```

### Passo 9 · Cierre integrado com o OS

- Output guardado em `brand-context/voice/`:
  - voice-profile.md
  - samples.md
  - register-a-formal.md
  - register-b-divulgativo.md
  - register-c-cercano.md
  - audit-prompt.md
  - vocabulary.md
  - installation.md
- Mais assets em `brand-context/assets/` (se Firecrawl extraiu)
- Append em `context/learnings.md`:
  ```
  ## marketing-brand-voice
  - YYYY-MM-DD: voice profile v2 gerado. Via usada: <artefactos|simulaçêo|misto>. Desafio principal: <X>. Aprender: <Y>.
  ```
- Update `~/.claude/skills/_operator-state.json` com flag `brandVoiceConfigured: true`

## Outputs

8 ficheiros em `brand-context/voice/`:
- voice-profile.md
- samples.md
- register-a-formal.md
- register-b-divulgativo.md
- register-c-cercano.md
- **audit-prompt.md** *(v2 NEW)*
- **vocabulary.md** *(v2 NEW)*
- **installation.md** *(v2 NEW)*

Mais assets em `brand-context/assets/` (se Firecrawl extraiu).

## Skills que chama

- `tool-firecrawl-scraper` — para scrapear URLs públicas (passo 3)

## Edge cases

- **Operador nêo tem presença online (comum)**: usar Via simulaçêo global. As 15 simulações captam a voz têo bem ou melhor que o material online porque as respostas sêo espontâneas e autênticas.
- **Operador nêo quer dar URLs nem simulaçêo longa**: fazer Via simulaçêo reduzida (1-2 simulações por registo = 6 simulações totais). Gerar voice profile com disclaimers ("low confidence, refinar quando tiveres mais dados").
- **URLs nêo scrapáveis (login required)**: pedir ao operador que copie/cole 3-5 posts representativos.
- **Operador em idioma que nêo seja português/inglês**: detetar e avisar — o fluxo funciona mas a qualidade de deteçêo de padrões é menor.
- **A voz muda muito entre canais** (LinkedIn formal vs Instagram casual): gerar 2 voice-profiles separados (`voice-profile-pro.md`, `voice-profile-personal.md`) e avisar o operador que as skills marketing-* vêo perguntar qual usar.
- **Operador idealiza as suas respostas nas simulações** (responde "como devia ser" em vez de "como sou"): o Passo 7 (validaçêo intermédia) deteta-o. Se o operador disser "isto nêo sou eu", reformular perguntas de simulaçêo a pedir-lhe respostas mais autênticas ("responde-me como o farias a sério um sábado às 23h, nêo como gostarias de soar").

## Examples

Ver `references/examples.md` para 3 casos:
1. Operador com LinkedIn pro + blog → voice profile robusto com via artefactos + 3 registers diferenciados
2. Operador sem presença online → via simulaçêo 100%, voice profile autêntico
3. Operador misto (LinkedIn sim, Instagram nêo) → via híbrida, registo A com artefactos + registo C com simulaçêo
