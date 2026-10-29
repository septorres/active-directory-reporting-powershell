#Requires -Version 5.1
<#
.SYNOPSIS
Exports a read-only Active Directory user report to CSV.
.DESCRIPTION
Portfolio adaptation of AD reporting work from 2023.
No accounts or group memberships are modified. No email is sent.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $SearchBase,
    [string] $OutputDirectory = (Join-Path (Get-Location) 'output'),
    [switch] $IncludeDisabled
)

$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory -ErrorAction Stop

if (-not (Test-Path -LiteralPath $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$outputFile = Join-Path $OutputDirectory "ad-users-$timestamp.csv"

$users = @(Get-ADUser -Filter '*' -SearchBase $SearchBase -Properties DisplayName, Department, Enabled, MemberOf)
if (-not $IncludeDisabled) {
    $users = @($users | Where-Object { $_.Enabled -eq $true })
}

$report = @($users | ForEach-Object {
    [pscustomobject]@{
        SamAccountName = $_.SamAccountName
        DisplayName    = $_.DisplayName
        Department     = $_.Department
        Enabled        = $_.Enabled
        DirectGroups   = @($_.MemberOf | Where-Object { $_ }).Count
    }
})

$report | Sort-Object SamAccountName | Export-Csv -LiteralPath $outputFile -Delimiter ';' -NoTypeInformation -Encoding UTF8
Write-Output "Report created: $outputFile ($($report.Count) users)"
