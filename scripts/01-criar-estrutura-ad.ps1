<#
.SYNOPSIS
  Cria OUs, grupos e usuários de teste no domínio do laboratório.
.NOTES
  Execute no DC01 como administrador. Altere $Dominio se necessário.
  A senha NÃO fica no script: ela é solicitada na execução.
#>

Import-Module ActiveDirectory

$Dominio  = "DC=lab,DC=local"
$Setores  = @("TI","RH","Financeiro")
$Senha    = Read-Host "Senha inicial dos usuarios de teste" -AsSecureString

# OUs
foreach ($ou in @("Usuarios","Computadores","Grupos","Desativados")) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -SearchBase $Dominio -SearchScope OneLevel -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -Path $Dominio -ProtectedFromAccidentalDeletion $true
    }
}

foreach ($setor in $Setores) {
    # Sub-OU por setor
    $pathUsuarios = "OU=Usuarios,$Dominio"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$setor'" -SearchBase $pathUsuarios -SearchScope OneLevel -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $setor -Path $pathUsuarios
    }

    # Grupo de segurança por setor
    $grupo = "GG_$setor"
    if (-not (Get-ADGroup -Filter "Name -eq '$grupo'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $grupo -GroupScope Global -GroupCategory Security -Path "OU=Grupos,$Dominio"
    }

    # 2 usuarios de teste por setor
    1..2 | ForEach-Object {
        $login = "$($setor.ToLower()).user$_"
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$login'" -ErrorAction SilentlyContinue)) {
            New-ADUser -Name "$setor Usuario $_" `
                -SamAccountName $login `
                -UserPrincipalName "$login@lab.local" `
                -Path "OU=$setor,$pathUsuarios" `
                -AccountPassword $Senha `
                -ChangePasswordAtLogon $true `
                -Enabled $true
            Add-ADGroupMember -Identity $grupo -Members $login
            Write-Host "Criado: $login -> $grupo"
        }
    }
}
Write-Host "Estrutura concluida."
