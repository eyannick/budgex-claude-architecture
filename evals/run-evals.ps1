# run-evals.ps1 — Évaluateur de l'orchestrateur Budgex
# Usage : .\.claude\evals\run-evals.ps1 [-CaseId "eval-001"] [-Verbose]
# Sans paramètre : exécute tous les cas

param(
    [string]$CaseId = "",
    [switch]$Verbose
)

$cases_path = ".claude/evals/eval-cases.json"
$results_dir = ".claude/evals/results"
$responses_dir = ".claude/evals/responses"

New-Item -ItemType Directory -Force -Path $results_dir | Out-Null
New-Item -ItemType Directory -Force -Path $responses_dir | Out-Null

function Test-ContainsAll {
    param(
        [string]$Text,
        [array]$Terms,
        [ref]$Issues,
        [ref]$Score,
        [ref]$MaxScore,
        [string]$Label
    )

    foreach ($term in $Terms) {
        $MaxScore.Value++
        if ($Text -match [regex]::Escape($term)) {
            $Score.Value++
        } else {
            $Issues.Value += "$Label absent : $term"
        }
    }
}

function Test-NotContainsAny {
    param(
        [string]$Text,
        [array]$Terms,
        [ref]$Issues,
        [ref]$Score,
        [ref]$MaxScore,
        [string]$Label
    )

    foreach ($term in $Terms) {
        $MaxScore.Value++
        if ($Text -notmatch [regex]::Escape($term)) {
            $Score.Value++
        } else {
            $Issues.Value += "$Label présent : $term"
        }
    }
}

function Test-Sequence {
    param(
        [string]$Text,
        [array]$Terms
    )

    $pos = 0
    foreach ($term in $Terms) {
        $idx = $Text.IndexOf($term, $pos, [System.StringComparison]::OrdinalIgnoreCase)
        if ($idx -lt 0) { return $false }
        $pos = $idx + $term.Length
    }
    return $true
}

# Charger les cas
$cases = Get-Content $cases_path -Raw | ConvertFrom-Json

if ($CaseId) {
    $cases = $cases | Where-Object { $_.id -eq $CaseId }
    if (-not $cases) {
        Write-Host "Cas '$CaseId' introuvable." -ForegroundColor Red
        exit 1
    }
}

Write-Host "=== EVALS BUDGEX-ORCHESTRATOR ===" -ForegroundColor Cyan
Write-Host "Cas à évaluer : $($cases.Count)"
Write-Host ""
Write-Host "⚠️  Ces evals nécessitent une réponse manuelle de Claude Code." -ForegroundColor Yellow
Write-Host "   Pour chaque cas : soumets la requête à l'orchestrateur, copie la réponse"
Write-Host "   dans .claude/evals/responses/[id].txt, puis relance ce script."
Write-Host ""

$results = @()

foreach ($case in $cases) {
    $response_file = "$responses_dir/$($case.id).txt"

    Write-Host "--- $($case.id) : $($case.description)" -ForegroundColor White
    Write-Host "    Input : $($case.input)"

    if (-not (Test-Path $response_file)) {
        Write-Host "    ⏳ En attente de réponse dans $response_file" -ForegroundColor Gray
        $results += @{ id = $case.id; status = "PENDING"; score = 0; issues = @() }
        continue
    }

    $response = Get-Content $response_file -Raw
    $score = 0
    $max_score = 0
    $issues = @()

    if ($case.expected.must_contain) {
        Test-ContainsAll -Text $response -Terms $case.expected.must_contain `
            -Issues ([ref]$issues) -Score ([ref]$score) -MaxScore ([ref]$max_score) -Label "Élément attendu"
    }

    if ($case.expected.routing_category) {
        $max_score++
        if ($response -match [regex]::Escape($case.expected.routing_category)) { $score++ }
        else { $issues += "Routing attendu : $($case.expected.routing_category)" }
    }

    if ($case.expected.streams -and $case.expected.streams.Count -gt 0) {
        Test-ContainsAll -Text $response -Terms $case.expected.streams `
            -Issues ([ref]$issues) -Score ([ref]$score) -MaxScore ([ref]$max_score) -Label "Stream attendu"
    }

    if ($case.expected.must_not_streams -and $case.expected.must_not_streams.Count -gt 0) {
        Test-NotContainsAny -Text $response -Terms $case.expected.must_not_streams `
            -Issues ([ref]$issues) -Score ([ref]$score) -MaxScore ([ref]$max_score) -Label "Stream interdit"
    }

    if ($case.expected.must_not_contain) {
        Test-NotContainsAny -Text $response -Terms $case.expected.must_not_contain `
            -Issues ([ref]$issues) -Score ([ref]$score) -MaxScore ([ref]$max_score) -Label "Terme interdit"
    }

    if ($case.expected.profile) {
        $max_score++
        if ($response -match [regex]::Escape($case.expected.profile)) { $score++ }
        else { $issues += "Profil attendu : $($case.expected.profile)" }
    }

    if ($case.expected.sequence -and $case.expected.sequence.Count -gt 0) {
        $max_score++
        if (Test-Sequence -Text $response -Terms $case.expected.sequence) { $score++ }
        else { $issues += "Séquence attendue absente ou dans le mauvais ordre : $($case.expected.sequence -join ' -> ')" }
    }

    if ($case.expected.must_not_delegate -eq $true) {
        $max_score++
        if ($response -match "NO_DELEGATE") { $score++ }
        else { $issues += "NO_DELEGATE attendu" }
    }

    $pct = if ($max_score -gt 0) { [math]::Round(($score / $max_score) * 100) } else { 100 }
    $status = if ($pct -ge 80) { "PASS" } elseif ($pct -ge 50) { "PARTIAL" } else { "FAIL" }
    $color = if ($status -eq "PASS") { "Green" } elseif ($status -eq "PARTIAL") { "Yellow" } else { "Red" }

    Write-Host "    Score : $score/$max_score ($pct%) — $status" -ForegroundColor $color
    if ($Verbose -and $issues.Count -gt 0) {
        foreach ($issue in $issues) {
            Write-Host "      ⚠️  $issue" -ForegroundColor Yellow
        }
    }

    $results += @{
        id = $case.id
        status = $status
        score = $pct
        issues = $issues
    }
}

Write-Host ""
Write-Host "=== SYNTHÈSE ===" -ForegroundColor Cyan

$pass = ($results | Where-Object { $_.status -eq "PASS" }).Count
$partial = ($results | Where-Object { $_.status -eq "PARTIAL" }).Count
$fail = ($results | Where-Object { $_.status -eq "FAIL" }).Count
$pending = ($results | Where-Object { $_.status -eq "PENDING" }).Count

$completed = $results | Where-Object { $_.status -ne "PENDING" }
$average = if ($completed.Count -gt 0) {
    [math]::Round((($completed | Measure-Object -Property score -Average).Average), 1)
} else {
    0
}

Write-Host "PASS    : $pass"
Write-Host "PARTIAL : $partial"
Write-Host "FAIL    : $fail"
Write-Host "PENDING : $pending"
Write-Host "MOYENNE : $average%"

$report = @{
    timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    total = $cases.Count
    pass = $pass
    partial = $partial
    fail = $fail
    pending = $pending
    average = $average
    results = $results
}

$report_path = "$results_dir/evals-$(Get-Date -Format 'yyyy-MM-dd-HHmmss').json"
$report | ConvertTo-Json -Depth 6 | Set-Content $report_path -Encoding UTF8

Write-Host ""
Write-Host "Rapport sauvegardé : $report_path" -ForegroundColor Gray