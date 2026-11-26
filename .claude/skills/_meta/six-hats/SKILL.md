---
name: six-hats
description: Aplica o método dos 6 chapéus de Edward de Bono para analisar uma decisêo, problema ou estratégia a partir de 6 perspetivas separadas (processo, dados, riscos, oportunidades, criatividade, intuiçêo). Usa-o quando o utilizador pedir "analisa X a partir de vários ângulos", "ajuda-me a decidir Y", "o que achas de Z", ou quando a pergunta requeira estruturar pensamento sem cair em vieses. Output: análise estruturada por chapéu + síntese com recomendaçêo.
---

# six-hats

## Quando é invocada

- Utilizador pede: "analisa a partir de vários ângulos", "o que achas de", "ajuda-me a decidir", "prós e contras de"
- Utilizador tem uma decisêo grande pendente (lançar produto, fechar contrato, contratar pessoa, abandonar projeto)
- Outra skill deteta que a pergunta requer análise multi-perspetiva e nêo resoluçêo direta
- Utilizador menciona explicitamente "6 chapéus" ou "De Bono"

## Por que importa

A maioria das decisões empresariais é tomada misturando dados + emoções + medos + criatividade no mesmo parágrafo, e fica-se pela perspetiva favorita de quem decide. Os 6 chapéus **separam os modos de pensamento** para que cada um receba atençêo completa antes de misturar. Aplicado bem, evita decisões unilaterais e descobre ângulos invisíveis.

## Process

### Passo 1 · Confirmar o problema/decisêo a analisar

Antes de começar, certifica-te que tens claro O QUE se está a analisar. Se o utilizador for ambíguo:

```
Vamos aplicar os 6 chapéus. Para que funcione, preciso que a
pergunta esteja o mais concreta possível. Confirma:

  • Que decisêo ou problema vais analisar?
  • O que muda se a resposta for A vs B?
  • Há restrições duras (orçamento, data, pessoas)?

Resume em 2-3 frases.
```

Espera resposta clara antes de continuar.

### Passo 2 · Perguntar profundidade desejada

```
Dois modos:

  [1] Rápido — escrevo os 6 chapéus eu próprio (5 min, ~1500 palavras)
  [2] Profundo — percorremos os 6 juntos, tu contribuis em cada um
       (15-20 min, muito mais customizado)

Qual preferes?
```

Por defeito, se nêo responder, usa modo [1].

### Passo 3 · Percorrer os 6 chapéus POR ORDEM

**Nêo mistures chapéus.** Cada um tem a sua secçêo, esvazia-o antes de passar ao seguinte. A ordem é deliberada: começar por processo (azul) ancora, terminar por intuiçêo (vermelho) fecha com a sensaçêo gut.

#### 🔵 Azul · Controlo do processo

- Qual é o âmbito correto da análise? (nêo abarcar o que nêo é decidível)
- Qual é a métrica de sucesso? (1-3 KPIs concretos)
- Que decisões ficam fora de scope?
- Que experiência confirmaria a resposta sem precisar de pensar mais?

#### ⚪ Branco · Factos e dados objetivos

- Dados verificáveis: números, datas, evidência
- O que se sabe vs o que se julga saber
- Os dados que faltam (e como obtê-los rapidamente)
- Análogos ou casos semelhantes (nêo opiniões, factos)

#### ⚫ Preto · Crítica e riscos

- O que pode correr mal e com que probabilidade
- Custos ocultos (tempo, oportunidade, energia, reputaçêo)
- Worst case scenario (nêo para assustar, para dimensionar)
- Pressupostos que se estêo a dar como certos e podiam nêo ser

#### 🟡 Amarelo · Otimismo e oportunidades

- Melhor caso se tudo correr bem
- Quem/o que beneficia e como
- Efeitos de segunda ordem positivos (para além do primeiro benefício óbvio)
- Como amplifica isto outras áreas do negócio/vida

#### 🟢 Verde · Criatividade e ideias novas

- Brainstorm de alternativas (mínimo 5, idealmente 10+)
- Combinações das duas opções binárias numa terceira via
- O que faria alguém de fora do setor perante este problema
- O absurdo ou lateral (às vezes o insight vem daí)

#### 🔴 Vermelho · Intuiçêo e emoções

- Sem justificar: o que te diz o corpo?
- Que opçêo ENTUSIASMA e qual DRENA?
- Se tivesses de decidir AGORA com 5 segundos, o que dizes?
- Se a resposta evidente fosse "nêo" mas algo te empurra para "sim", o que é esse algo?

### Passo 4 · Síntese com recomendaçêo

Após os 6 chapéus, escreve uma secçêo final com:

1. **Decisêo recomendada** em 1 frase clara
2. **Razêo principal** (1-2 frases, geralmente combina amarelo + branco)
3. **Riscos a vigiar** (os 2-3 mais prováveis do chapéu preto)
4. **Plano de açêo imediato** (próximos 3 passos por ordem)
5. **Quando mudar de opiniêo** (que sinal novo faria reconsiderar)

### Passo 5 · Output empacotado

Se a análise for relevante para guardar:
- Gerar ficheiro em `projects/six-hats/<YYYY-MM-DD>-<tema-corto>.md` com toda a análise
- Se o utilizador a vai partilhar (com sócio, equipa, conselheiro), invocar `tool-visual-explainer` para empacotar em HTML partilhável
- Append em `context/decisions-log.md` com a decisêo final se efetivamente se tomar uma

### Passo 6 · Fecho e aprendizagem

- Se a sessêo ensinou algo nêo óbvio sobre como o utilizador pensa (preferências, vieses, valores), append em `context/learnings.md` em `## six-hats`
- Se se identificou uma decisêo, propõe no wrap-up gravá-la em `context/decisions-log.md`

## Outputs

- Análise no chat estruturada por chapéu + síntese
- Opcional: ficheiro `projects/six-hats/<YYYY-MM-DD>-<tema>.md`
- Opcional: HTML partilhável via `tool-visual-explainer`
- Opcional: entrada em `context/decisions-log.md` se se tomar decisêo

## Skills que chama

- **`tool-visual-explainer`** (opcional) — para empacotar análise em HTML partilhável
- **`decisions-log`** (opcional) — se a sessêo fechar com uma decisêo, registá-la append-only

## Edge cases

- **Pergunta demasiado vaga** ("o que faço com a minha vida?"): aplica primeiro o chapéu azul para delimitar. Se nêo se delimita, sugere usar outra skill (mentoria, nêo análise).
- **Pergunta puramente operativa** ("que cor de botêo uso?"): os 6 chapéus sêo overkill. Sugere decidir diretamente ou usar A/B test.
- **Utilizador está emocionalmente carregado** (acabou de perder cliente, contrato roto): NêO aplicar imediatamente, pedir 24h de cooldown — o chapéu vermelho em quente enviesa o resto.
- **Decisêo já tomada**: o utilizador quer validaçêo, nêo análise. Aplica só chapéu preto (riscos) para fazer "premortem". Nêo simules análise aberta se nêo o é.
- **Tempo limitado** (<5 min disponíveis): usa a versêo "Rápido" e escreve os 6 chapéus diretos, sem esperar input por chapéu.

## Examples

Ver `references/examples.md` para 2 exemplos completos:
1. "Lanço o curso agora ou espero pelo Q4?" (decisêo binária com dados)
2. "Contrato esta pessoa ou continuo sozinho mais 3 meses?" (decisêo emocional com dados moles)

## Notas operativas

- **NêO uses os 6 chapéus para tudo.** É overkill para decisões <30 min de impacto. Reserva para decisões que importam.
- **O chapéu vermelho vai no fim, nêo no início.** Se o meteres no início, os dados posteriores enviesam-se a justificar a intuiçêo. No fim, contrasta com o aprendido.
- **Chapéu verde com mínimo 5 ideias sempre.** Se só te ocorrem 2, nêo estás em modo verde a sério — continuas a avaliar, nêo a criar.
- **Nêo mistures chapéus na mesma frase.** Se uma ideia é "isto é boa oportunidade MAS com risco de X", separa: amarelo diz oportunidade, preto diz risco. Cada um no seu sítio.
