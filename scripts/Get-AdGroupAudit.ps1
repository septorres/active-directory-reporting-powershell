#Requires -Version 5.1
<# Read-only audit of direct group membership for users in a chosen OU. #>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $SearchBase,
    [string] $OutputDirectory = (Join-Path (Get-Location) 'output'),
    [ValidateRange(1, 1000)]
    [int] $MinimumDirectGroups = 2
)

$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory -ErrorAction Stop
if (-not (Test-Path -LiteralPath $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$outputFile = Join-Path $OutputDirectory "ad-group-audit-$timestamp.csv"
$users = @(Get-ADUser -Filter '*' -SearchBase $SearchBase -Properties MemberOf, Enabled)

$rows = @($users | ForEach-Object {
    $user = $_
    $groups = @($user.MemberOf | Where-Object { $_ })
    if ($groups.Count -ge $MinimumDirectGroups) {
        [pscustomobject]@{
            SamAccountName    = $user.SamAccountName
            Enabled           = $user.Enabled
            DirectGroupCount  = $groups.Count
            DirectGroupDNs    = ($groups -join ' | ')
        }
    }
})

$rows | Sort-Object SamAccountName | Export-Csv -LiteralPath $outputFile -Delimiter ';' -NoTypeInformation -Encoding UTF8
Write-Output "Audit created: $outputFile ($($rows.Count) matching users)"
