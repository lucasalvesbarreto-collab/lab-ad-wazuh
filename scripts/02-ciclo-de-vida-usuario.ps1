<#
.SYNOPSIS
  Automatiza o ciclo de vida de um usuario: Criar, Transferir, Desativar.
.EXAMPLE
  .\02-ciclo-de-vida-usuario.ps1 -Acao Criar -Login maria.silva -Nome "Maria Silva" -Setor RH
  .\02-ciclo-de-vida-usuario.ps1 -Acao Transferir -Login maria.silva -Setor Financeiro
  .\02-ciclo-de-vida-usuario.ps1 -Acao Desativar -Login maria.silva
#>
param(
    [Parameter(Mandatory)][ValidateSet("Criar","Transferir","Desativar")][string]$Acao,
    [Parameter(Mandatory)][string]$Login,
    [string]$Nome,
    [ValidateSet("TI","RH","Financeiro")][string]$Setor
)

Import-Module ActiveDirectory
$Dominio = "DC=lab,DC=local"

switch ($Acao) {
    "Criar" {
        $senha = Read-Host "Senha inicial" -AsSecureString
        New-ADUser -Name $Nome -SamAccountName $Login -UserPrincipalName "$Login@lab.local" `
            -Path "OU=$Setor,OU=Usuarios,$Dominio" -AccountPassword $senha `
            -ChangePasswordAtLogon $true -Enabled $true
        Add-ADGroupMember -Identity "GG_$Setor" -Members $Login
        Write-Host "Usuario $Login criado em $Setor."
    }
    "Transferir" {
        $usuario = Get-ADUser $Login -Properties MemberOf
        foreach ($g in ($usuario.MemberOf | Get-ADGroup | Where-Object Name -like "GG_*")) {
            Remove-ADGroupMember -Identity $g -Members $Login -Confirm:$false
        }
        Add-ADGroupMember -Identity "GG_$Setor" -Members $Login
        Move-ADObject -Identity $usuario.DistinguishedName -TargetPath "OU=$Setor,OU=Usuarios,$Dominio"
        Write-Host "Usuario $Login transferido para $Setor."
    }
    "Desativar" {
        $usuario = Get-ADUser $Login -Properties MemberOf
        Disable-ADAccount -Identity $Login
        foreach ($g in ($usuario.MemberOf | Get-ADGroup)) {
            Remove-ADGroupMember -Identity $g -Members $Login -Confirm:$false
        }
        Move-ADObject -Identity $usuario.DistinguishedName -TargetPath "OU=Desativados,$Dominio"
        Write-Host "Usuario $Login desativado e movido para Desativados."
    }
}
