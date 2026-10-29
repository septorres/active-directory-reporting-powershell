# Active Directory Reporting (PowerShell)

Projeto de portfólio baseado em rotinas de relatórios e auditorias de Active Directory com as quais trabalhei em **2023**. Os scripts foram **reescritos e simplificados em 2026**, usando parâmetros genéricos, para demonstrar o fluxo sem expor o ambiente corporativo original.

## O problema

Na administração de AD, era necessário consultar usuários em unidades organizacionais (OUs), revisar grupos e gerar relatórios CSV. O histórico inclui também diagnóstico de falhas de exportação quando o arquivo estava aberto em outro programa.

## O que está incluído

- `scripts/Get-AdUserReport.ps1`: consulta usuários de uma OU, com opção de incluir contas desativadas; exporta conta, nome, departamento, status e número de grupos diretos.
- `scripts/Get-AdGroupAudit.ps1`: identifica usuários com determinada quantidade mínima de grupos diretos.
- `samples/example-output.csv`: saída **fictícia** apenas para ilustrar o formato.

Os scripts consultam o Active Directory em **modo somente leitura**. Eles não desativam contas, alteram grupos ou enviam e-mails.

## Requisitos

- Windows PowerShell 5.1 com o módulo `ActiveDirectory` (RSAT).
- Permissões de leitura em um ambiente AD autorizado.
- Uma OU existente para informar em `-SearchBase`.

## Como executar

```powershell
.\scripts\Get-AdUserReport.ps1 -SearchBase 'OU=People,DC=example,DC=local'
.\scripts\Get-AdUserReport.ps1 -SearchBase 'OU=People,DC=example,DC=local' -IncludeDisabled
.\scripts\Get-AdGroupAudit.ps1 -SearchBase 'OU=People,DC=example,DC=local' -MinimumDirectGroups 2
```

Substitua a OU de exemplo por outra **do seu ambiente autorizado**. Os CSVs ficam em `output/` com data e hora no nome.

## Limitações e cuidados

- `MemberOf` não representa todas as permissões efetivas: não resolve grupos aninhados e pode não incluir o grupo primário.
- Em um AD real, os relatórios podem conter dados pessoais. Proteja, retenha e descarte os CSVs conforme as regras da organização.
- Este código **não foi executado contra um AD real** na preparação do portfólio.
- Scripts antigos que modificavam contas ou enviavam e-mails não foram publicados.

## Origem

- **2023:** experiência com consultas a OUs, grupos, relatórios CSV e investigação de erros de scripts PowerShell.
- **2026:** reescrita e simplificação para uma demonstração pública.

Esta versão é uma **adaptação para portfólio**; não é uma cópia literal do código usado em 2023 nem foi apresentada como código de produção.
