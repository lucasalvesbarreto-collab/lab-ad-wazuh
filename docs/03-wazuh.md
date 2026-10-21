# 03 · Wazuh (SIEM)

## Instalação
- Versão do Wazuh: [PREENCHER]
- Método: instalação "all-in-one" (manager + indexer + dashboard) no WAZUH01, conforme a documentação oficial: https://documentation.wazuh.com

## Agentes
Agentes instalados no DC01 e no CLIENTE01 com o comando gerado pelo dashboard.

![Agentes ativos](../imagens/03-agentes.png)

## Auditoria no Windows
Sem a auditoria avançada, os eventos de segurança não são gerados. Ativei em *Advanced Audit Policy Configuration*:

- Logon/Logoff → Audit Logon (sucesso e falha)
- Account Logon → Audit Credential Validation
- Account Management → User Account Management, Security Group Management

## Sysmon (opcional)
[PREENCHER: instalou? qual configuração?]

## Problemas encontrados e soluções
- [PREENCHER: por exemplo, agente "disconnected" por firewall ou DNS]
