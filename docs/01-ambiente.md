# 01 · Ambiente

## Hipervisor
[PREENCHER: VirtualBox / VMware / Hyper-V e versão]

## Máquinas virtuais

| VM | SO | vCPU | RAM | Disco |
|---|---|---|---|---|
| DC01 | Windows Server 2022 (avaliação) | 2 | 4 GB | [PREENCHER] |
| CLIENTE01 | Windows 10/11 (avaliação) | 2 | 4 GB | [PREENCHER] |
| WAZUH01 | Ubuntu Server 22.04 | [PREENCHER] | [PREENCHER] | [PREENCHER] |

## Rede
- Tipo: [NAT Network / host-only]
- Faixa: 192.168.56.0/24
- IPs fixos: DC01 `.10`, CLIENTE01 `.11`, WAZUH01 `.20`
- DNS dos clientes apontando para o DC01

## Evidências
![Lista de VMs](../imagens/01-vms.png)
