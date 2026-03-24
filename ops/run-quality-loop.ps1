# run-quality-loop.ps1 — Boucle de qualité post-run Budgex
# Exécuter depuis la racine du projet : .\.claude\ops\run-quality-loop.ps1

$report = @{
    timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    project   = "budgex"
    checks    = @{}
    summary   = ""
    status    = "UNKNOWN"
}

Write-Host "=== QUALITY LOOP BUDGEX ===" -ForegroundColor Cyan
Write-Host "$(Get-Date -Format 'HH:mm:ss') Démarrage..."
Write-Host ""

function Invoke-Check {
    param(
        [string]$Label,
        [scriptblock]$Command,
        [scriptblock]$SuccessCondition
    )

    Write-Host $Label -NoNewline
    try {
        $output = & $Command 2>&1
        $outputStr = $output -join "`n"
        $exitCode = $LASTEXITCODE

        $result = & $SuccessCondition $outputStr $exitCode
        return @{
            Output   = $outputStr
            ExitCode = $exitCode
            Success  = $result
            Error    = $null
        }
    } catch {
        return @{
            Output   = ""
            ExitCode = -1
            Success  = $false
            Error    = "$_"
        }
    }
}

# 1. PHPUnit
$result = Invoke-Check -Label "[1/5] PHPUnit..." `
    -Command { php bin/phpunit --colors=never } `
    -SuccessCondition { param($out, $code) ($code -eq 0) -and ($out -match "OK") }

if ($result.Error) {
    $report.checks.phpunit = "ERROR: $($result.Error)"
    Write-Host " ⚠️ Erreur" -ForegroundColor Yellow
} elseif ($result.Success) {
    $report.checks.phpunit = "OK"
    Write-Host " ✅" -ForegroundColor Green
} else {
    $report.checks.phpunit = "FAIL"
    Write-Host " ❌" -ForegroundColor Red
}

# 2. Doctrine schema validate
$result = Invoke-Check -Label "[2/5] Doctrine schema..." `
    -Command { php bin/console doctrine:schema:validate --no-interaction } `
    -SuccessCondition { param($out, $code) ($code -eq 0) -and ($out -match "\[OK\]") }

if ($result.Error) {
    $report.checks.doctrine_schema = "ERROR: $($result.Error)"
    Write-Host " ⚠️ Erreur" -ForegroundColor Yellow
} elseif ($result.Success) {
    $report.checks.doctrine_schema = "OK"
    Write-Host " ✅" -ForegroundColor Green
} else {
    $report.checks.doctrine_schema = "FAIL"
    Write-Host " ❌" -ForegroundColor Red
}

# 3. Lint YAML
$result = Invoke-Check -Label "[3/5] Lint YAML..." `
    -Command { php bin/console lint:yaml config/ --parse-tags --no-interaction } `
    -SuccessCondition { param($out, $code) ($code -eq 0) -and ($out -notmatch "ERROR") }

if ($result.Error) {
    $report.checks.lint_yaml = "ERROR: $($result.Error)"
    Write-Host " ⚠️ Erreur" -ForegroundColor Yellow
} elseif ($result.Success) {
    $report.checks.lint_yaml = "OK"
    Write-Host " ✅" -ForegroundColor Green
} else {
    $report.checks.lint_yaml = "FAIL"
    Write-Host " ❌" -ForegroundColor Red
}

# 4. Lint Twig
$result = Invoke-Check -Label "[4/5] Lint Twig..." `
    -Command { php bin/console lint:twig templates/ --no-interaction } `
    -SuccessCondition { param($out, $code) ($code -eq 0) -and ($out -notmatch "ERROR") }

if ($result.Error) {
    $report.checks.lint_twig = "ERROR: $($result.Error)"
    Write-Host " ⚠️ Erreur" -ForegroundColor Yellow
} elseif ($result.Success) {
    $report.checks.lint_twig = "OK"
    Write-Host " ✅" -ForegroundColor Green
} else {
    $report.checks.lint_twig = "FAIL"
    Write-Host " ❌" -ForegroundColor Red
}

# 5. PHPStan (si disponible)
Write-Host "[5/5] PHPStan..." -NoNewline
if (Test-Path "vendor/bin/phpstan" -or Test-Path "vendor/bin/phpstan.bat") {
    $result = Invoke-Check -Label "" `
        -Command { php vendor/bin/phpstan analyse src/ --level=5 --no-progress --no-ansi } `
        -SuccessCondition { param($out, $code) ($code -eq 0) -and ($out -match "No errors") }

    if ($result.Error) {
        $report.checks.phpstan = "ERROR: $($result.Error)"
        Write-Host " ⚠️ Erreur" -ForegroundColor Yellow
    } elseif ($result.Success) {
        $report.checks.phpstan = "OK (level 5)"
        Write-Host " ✅" -ForegroundColor Green
    } else {
        $report.checks.phpstan = "FAIL"
        Write-Host " ❌" -ForegroundColor Red
    }
} else {
    $report.checks.phpstan = "NOT_INSTALLED"
    Write-Host " ⏭️ Non installé" -ForegroundColor Gray
}

# --- Synthèse ---
$fails = $report.checks.Values | Where-Object { $_ -like "FAIL*" -or $_ -like "ERROR*" }

if ($fails.Count -eq 0) {
    $report.status = "SUCCESS"
    $report.summary = "Tous les checks passent."
} else {
    $report.status = "FAILED"
    $report.summary = "$($fails.Count) check(s) en échec : $($fails -join ', ')"
}

Write-Host ""
Write-Host "=== RÉSULTAT : $($report.status) ===" -ForegroundColor $(if ($report.status -eq "SUCCESS") { "Green" } else { "Red" })
Write-Host $report.summary
Write-Host ""

# Écriture du rapport JSON
$report_dir = ".claude/ops/reports"
New-Item -ItemType Directory -Force -Path $report_dir | Out-Null
$report_path = "$report_dir/quality-loop-last.json"
$report | ConvertTo-Json -Depth 5 | Set-Content -Path $report_path -Encoding UTF8
Write-Host "Rapport sauvegardé : $report_path" -ForegroundColor Gray