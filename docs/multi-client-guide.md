# Multi-Cliente Guide

> Como trabalhar com N clientes a partir de uma única instalaçêo do iAmasters OS.

## Quando usar multi-cliente

Ativa multi-cliente se:
- És freelance / agência com 2+ clientes em simultâneo
- Cada cliente tem voice + ICP + positioning distintos
- Queres separaçêo clara de outputs por cliente

NêO uses multi-cliente se:
- És single-business (trabalha diretamente na raiz do repo)
- Os teus "clientes" sêo verticais do mesmo produto (isso é 1 marca com sub-segmentos)

## Criar cliente novo

```bash
bash scripts/add-client.sh acme-corp freelance-ia
```

Isto cria `clients/acme-corp/` com:

```
clients/acme-corp/
├── CLAUDE.md                       # Overrides específicos
├── brand-context/
│   ├── voice/voice-profile.md      # (com placeholders do template)
│   ├── positioning/positioning.md
│   ├── icp/icp.md
│   └── assets/
├── context/
│   ├── soul.md
│   └── user.md
└── projects/
    └── briefs/
```

**Verticais disponíveis**:
- `freelance-ia` — operador IA solo
- `agencia-marketing` — agência pequena
- `formador-online` — coach/educador
- `consultoria-b2b` — high-ticket B2B
- `vazio` — sem template

## Trabalhar dentro de um cliente

```bash
cd clients/acme-corp
claude
```

O Claude Code arranca no contexto do cliente:
- Lê o `CLAUDE.md` raiz do repo (instruções gerais)
- + `clients/acme-corp/CLAUDE.md` (overrides específicos)
- + `clients/acme-corp/brand-context/` (voice, positioning, ICP do cliente)
- + `clients/acme-corp/context/` (soul, user, learnings do cliente)

## Herança e overrides

### O que se herda do repo raiz
- `CLAUDE.md` raiz (as instruções gerais)
- Skills do repo (`.claude/skills/`)
- Sinapsis (instalado global)

### O que é do cliente apenas
- `clients/<nome>/CLAUDE.md` (overrides)
- `clients/<nome>/brand-context/` (voice/positioning/ICP próprios)
- `clients/<nome>/context/` (soul/user do cliente)
- `clients/<nome>/projects/` (outputs apenas do cliente)

### Skills custom por cliente

Se um cliente requer uma skill que NêO se aplica a outros:

```bash
mkdir -p clients/acme-corp/.claude/skills/marketing/marketing-acme-special
# Criar SKILL.md, references/, etc.
```

Essa skill só está disponível quando trabalhas em `clients/acme-corp/`. Nêo se herda à raiz nem a outros clientes.

## Mudar de cliente

```bash
# Estás em clients/acme-corp
# Fecha o Claude Code (Ctrl+C × 2) ou executa /wrap-up

cd ../widget-shop  # outro cliente
claude
```

O operator-state global do Sinapsis persiste, mas o contexto específico do cliente muda automaticamente.

**Pro tip**: executa `/wrap-up` ANTES de mudar de cliente. Isso guarda o daily summary específico do cliente atual.

## Trabalhar na raiz vs no cliente

| Se trabalhas em... | Útil para... |
|---|---|
| Raiz do repo | Marketing do operador próprio (LinkedIn pessoal, blog, marca pessoal), gestêo interna |
| `clients/X/` | Qualquer output entregável ao cliente X (copy, reports, deliverables) |

Regra: nunca geres conteúdo do cliente desde a raiz. Sempre `cd clients/X` primeiro.

## Segurança: separaçêo de info

Por design, as skills NêO partilham info entre clientes automaticamente:
- Nêo somas dados do cliente A em respostas que vais entregar ao cliente B
- Nêo referencias casos do cliente A em propostas ao cliente B
- O `.gitignore` mantém `clients/<nome>/` fora do git público (configurar por utilizador se quiseres partilhar entre máquinas via repo privado)

Se queres usar info do cliente A para inspirar cliente B:
- Faz manual e consciente
- Gera "case study anonimizado" como output do cliente A
- Referencia o case study no cliente B

## Update.sh e multi-cliente

Quando executas `bash scripts/update.sh`:
- ✅ Skills do repo raiz atualizam-se
- ✅ Templates de `clients/_templates/` atualizam-se (se upstream tiver mudanças)
- ❌ Os teus clientes em `clients/<nome>/` NUNCA sêo tocados
- ❌ O teu brand-context, context, projects próprios NUNCA sêo tocados

Se queres "refrescar" um cliente com o último template:
- Faz manual: `cp -r clients/_templates/freelance-ia/X clients/<cliente>/X`
- Mas costuma ser má ideia: o template é ponto de partida, nêo destino

## Exemplos de fluxos típicos

### Fluxo 1 · Segunda-feira: 3 clientes

```bash
# Cliente A (freelance-ia)
cd clients/acme-corp && claude
> "Cria post LinkedIn sobre case study X" → marketing-copywriting gera com voice de Acme
> /wrap-up
exit

# Cliente B (agencia-marketing)
cd ../widget-shop && claude
> "Repurpose último vídeo do CEO em 5 peças" → marketing-content-repurposing
> /wrap-up
exit

# Cliente C (consultoria-b2b)
cd ../north-star-consult && claude
> "Redige proposta comercial para novo lead" → marketing-copywriting registo A
> /wrap-up
exit
```

### Fluxo 2 · Operador próprio + 1 cliente

```bash
# Marca pessoal: conteúdo próprio
cd /repos/iamasters-os
claude
> "Cria post LinkedIn sobre a minha experiência com cliente X (anonimizado)"
> /wrap-up
exit

# Cliente principal
cd clients/biggest-client && claude
> "Gera report mensal de KPIs"
> /wrap-up
```

## Best practices

1. **Sempre `cd` antes de `claude`**. Nêo trabalhar no cliente X desde a raiz.
2. **Wrap-up ao mudar de contexto**. Daily summary separa-se por cliente.
3. **Brand voice por cliente**, nêo partilhar entre clientes.
4. **Uma skill custom = um cliente** ou promovê-la para a raiz se aplicar a vários.
5. **Backup do cliente regularmente** se tiver info crítica (nêo do git público).

## Troubleshooting

### "O Claude nêo aplica voice do cliente"
- Verifica que estás `cd` no cliente correto antes de `claude`
- Verifica que `clients/<nome>/brand-context/voice/voice-profile.md` está preenchido (nêo placeholders {{...}})
- Verifica que `clients/<nome>/CLAUDE.md` referencia o path correto

### "Skills da raiz nêo aparecem ao estar em cliente"
- As skills da raiz (`.claude/skills/`) sêo globais no repo, deviam estar disponíveis
- Se nêo se invocam: reinicia o Claude Code (Ctrl+C × 2)
- Se persistir: executa `bash scripts/sync-synapsis.sh` (futura skill v0.5)

### "Misturo info de clientes acidentalmente"
- É sinal de nêo respeitar `cd clients/X` antes de trabalhar
- Implementa a regra: sair do Claude (Ctrl+C × 2) entre clientes, nêo abrir 2 sessões ao mesmo tempo
- Para 2 sessões simultâneas: usar 2 terminais com `cd` distinto cada um
