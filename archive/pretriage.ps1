# pretriage.ps1 - Triage local avant appel Claude
# Usage : .\.claude\ops\pretriage.ps1 -Query "description de la tache"

param(
    [Parameter(Mandatory=$true)]
    [string]$Query
)

$query_lower = $Query.ToLower()

$stream = "unknown"
$confidence = "LOW"
$profile = "safe"

$backend_keywords = @("entite", "entity", "migration", "service", "voter", "controleur",
                       "controller", "repository", "phpunit", "test", "securite", "security",
                       "auth", "login", "password", "doctrine", "config", "relation")
$frontend_keywords = @("template", "twig", "css", "js", "javascript", "affichage", "responsive",
                        "mobile", "bouton", "formulaire", "bootstrap", "ui", "layout", "card")
$seo_keywords = @("title", "meta", "canonical", "robots", "noindex", "sitemap",
                  "indexation", "balise", "h1", "seo")
$qa_keywords = @("tester", "valider", "verifier", "couverture", "lint", "qualite",
                 "phpstan", "regression")

$backend_score  = ($backend_keywords  | Where-Object { $query_lower -match $_ }).Count
$frontend_score = ($frontend_keywords | Where-Object { $query_lower -match $_ }).Count
$seo_score      = ($seo_keywords      | Where-Object { $query_lower -match $_ }).Count
$qa_score       = ($qa_keywords       | Where-Object { $query_lower -match $_ }).Count

$max_score = [Math]::Max([Math]::Max($backend_score, $frontend_score),
                          [Math]::Max($seo_score, $qa_score))

if ($max_score -eq 0) {
    $stream     = "NO_DELEGATE"
    $confidence = "MEDIUM"
} elseif ($max_score -ge 3) {
    $confidence = "HIGH"
} elseif ($max_score -ge 2) {
    $confidence = "MEDIUM"
} else {
    $confidence = "LOW"
}

if ($backend_score  -eq $max_score -and $max_score -gt 0) { $stream = "backend"  }
if ($frontend_score -eq $max_score -and $max_score -gt 0) { $stream = "frontend" }
if ($seo_score      -eq $max_score -and $max_score -gt 0) { $stream = "seo"      }
if ($qa_score       -eq $max_score -and $max_score -gt 0) { $stream = "qa"       }

if ($backend_score -ge 2 -and $frontend_score -ge 2) {
    $stream = "backend+frontend (MULTI_STREAM)"
}

$deep_keywords = @("securite", "security", "auth", "voter", "migration", "incident", "prod")
$is_deep = ($deep_keywords | Where-Object { $query_lower -match $_ }).Count -gt 0
if ($is_deep) { $profile = "deep" }

Write-Host ""
Write-Host "=== PRETRIAGE BUDGEX ===" -ForegroundColor Cyan
Write-Host "Query      : $Query"
Write-Host "Stream     : $stream" -ForegroundColor Yellow

$conf_color = switch ($confidence) {
    "HIGH"   { "Green"  }
    "MEDIUM" { "Yellow" }
    default  { "Red"    }
}
Write-Host "Confiance  : $confidence" -ForegroundColor $conf_color

$prof_color = if ($profile -eq "deep") { "Red" } else { "White" }
Write-Host "Profil     : $profile" -ForegroundColor $prof_color
Write-Host ""
Write-Host "Scores     : backend=$backend_score | frontend=$frontend_score | seo=$seo_score | qa=$qa_score"
Write-Host ""

if ($confidence -eq "LOW") {
    Write-Host "ATTENTION : Confiance faible - clarifier la requete avant d'appeler Claude" -ForegroundColor Red
}
if ($profile -eq "deep") {
    Write-Host "ATTENTION : Profil DEEP detecte - validation QA requise" -ForegroundColor Yellow
}
Write-Host ""