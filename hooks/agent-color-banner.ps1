param(
    [Parameter(ValueFromPipeline = $true)]
    $InputObject
)

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

    $data = $raw | ConvertFrom-Json -ErrorAction Stop
} catch {
    exit 0
}

$agentType = ""
if ($data.agent_type) {
    $agentType = "$($data.agent_type)".ToLower()
} elseif ($env:CLAUDE_AGENT_TYPE) {
    $agentType = "$env:CLAUDE_AGENT_TYPE".ToLower()
}

if ([string]::IsNullOrWhiteSpace($agentType)) {
    exit 0
}

switch ($agentType) {
    "budgex-orchestrator" { $color = "Cyan";       $label = "[ORCHESTRATOR]" }
    "budgex-backend"      { $color = "Blue";       $label = "[BACKEND]" }
    "budgex-frontend"     { $color = "Magenta";    $label = "[FRONTEND]" }
    "budgex-database"     { $color = "DarkYellow"; $label = "[DATABASE]" }
    "budgex-qa"           { $color = "Green";      $label = "[QA]" }
    "budgex-finance"      { $color = "Yellow";     $label = "[FINANCE]" }
    "budgex-seo"          { $color = "DarkGreen";  $label = "[SEO]" }
    default               { $color = "Gray";       $label = "[AGENT]" }
}

Write-Host ""
Write-Host "$label $agentType" -ForegroundColor $color
Write-Host ""

exit 0