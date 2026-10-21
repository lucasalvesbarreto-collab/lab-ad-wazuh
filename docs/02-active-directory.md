# 02 · Active Directory (IAM)

## Implantação
1. Instalação das funções AD DS e DNS.
2. Promoção do DC01 a controlador de domínio: `lab.local`.
3. Ingresso do CLIENTE01 no domínio.

## Estrutura
```
lab.local
├── Usuarios
│   ├── TI
│   ├── RH
│   └── Financeiro
├── Computadores
├── Grupos
└── Desativados
```
Criada com [`scripts/01-criar-estrutura-ad.ps1`](../scripts/01-criar-estrutura-ad.ps1).

## Controle de acesso
Pasta compartilhada com permissões NTFS por grupo (princípio do menor privilégio):

| Pasta | GG_TI | GG_RH | GG_Financeiro |
|---|---|---|---|
| TI | Modificar | Sem acesso | Sem acesso |
| RH | Sem acesso | Modificar | Sem acesso |
| Financeiro | Sem acesso | Sem acesso | Modificar |

[PREENCHER: ajuste conforme o que você configurou]

## GPO
- Política de senha: [PREENCHER: tamanho mínimo, complexidade, validade]
- Bloqueio de conta: [PREENCHER: tentativas e duração]

## Ciclo de vida do usuário

| Etapa | Ação | Como |
|---|---|---|
| **Admissão** | Criar conta, colocar na OU e grupo do setor, forçar troca de senha no 1º logon | `02-ciclo-de-vida-usuario.ps1 -Acao Criar` |
| **Mudança de setor** | Remover grupos antigos, adicionar os novos, mover de OU | `-Acao Transferir` |
| **Desligamento** | Desativar conta, remover de todos os grupos, mover para OU `Desativados` | `-Acao Desativar` |

### Evidências
![Estrutura de OUs](../imagens/02-ous.png)
![GPO de senha](../imagens/02-gpo-senha.png)
