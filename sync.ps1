# sync.ps1 — push the current branch (and tags) to both DemoBoost remotes.
#
# Why this exists:
#   Git Credential Manager only stores one credential per host (github.com),
#   so a single `git push` cannot authenticate against both the personal
#   account (brucero-ui) and the Microsoft EMU account (brucerosato_microsoft).
#   This script bypasses GCM by using the `gh` CLI's per-account tokens
#   directly in the push URL.
#
# Prereqs:
#   - `gh` CLI installed and signed in to BOTH accounts:
#       gh auth login   # complete once for brucero-ui
#       gh auth login   # complete once for brucerosato_microsoft
#   - Run from the repo root.
#
# Usage:
#   .\sync.ps1                    # push current branch + tags to both
#   .\sync.ps1 -Branch main       # push a specific branch
#   .\sync.ps1 -Force             # force-push (use with care)
#   .\sync.ps1 -SkipEmu           # personal only
#   .\sync.ps1 -SkipPersonal      # EMU only

[CmdletBinding()]
param(
  [string]$Branch,
  [switch]$Force,
  [switch]$SkipPersonal,
  [switch]$SkipEmu
)

$ErrorActionPreference = 'Stop'

if (-not $Branch) {
  $Branch = (git rev-parse --abbrev-ref HEAD).Trim()
}

$personalUser = 'brucero-ui'
$emuUser      = 'brucerosato_microsoft'
$personalUrl  = 'github.com/brucero-ui/demoboost.git'
$emuUrl       = 'github.com/brucerosato_microsoft/demoboost.git'

function Push-Remote {
  param(
    [string]$User,
    [string]$HostPath,
    [string]$Label
  )

  Write-Host "==> Pushing $Branch to $Label ($User)..." -ForegroundColor Cyan

  $token = (& gh auth token --user $User 2>$null).Trim()
  if (-not $token) {
    throw "No gh token for $User. Run: gh auth login (and select $User)."
  }

  $url = "https://x-access-token:$token@$HostPath"
  $args = @('-c', 'credential.helper=', 'push', $url, $Branch, '--tags')
  if ($Force) { $args += '--force' }

  & git @args
  if ($LASTEXITCODE -ne 0) {
    throw "Push to $Label failed (exit $LASTEXITCODE)."
  }
  Write-Host "    OK: $Label updated." -ForegroundColor Green
}

if (-not $SkipPersonal) {
  Push-Remote -User $personalUser -HostPath $personalUrl -Label 'brucero-ui (public)'
}

if (-not $SkipEmu) {
  Push-Remote -User $emuUser -HostPath $emuUrl -Label 'brucerosato_microsoft (EMU)'
}

Write-Host ""
Write-Host "Done. Note: GitHub Releases are NOT replicated by git push." -ForegroundColor Yellow
Write-Host "After tagging a release, create it on each remote with:" -ForegroundColor Yellow
Write-Host "  gh release create vX.Y.Z DemoBoost_X_Y_Z.zip --repo brucero-ui/demoboost ..." -ForegroundColor DarkGray
Write-Host "  gh release create vX.Y.Z DemoBoost_X_Y_Z.zip --repo brucerosato_microsoft/demoboost ..." -ForegroundColor DarkGray
