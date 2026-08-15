<#
.SYNOPSIS
    Script auxiliar para execução de testes automatizados com Robot Framework.
.DESCRIPTION
    Permite executar suítes de testes de forma simples no Windows PowerShell,
    direcionando automaticamente os logs e relatórios para a pasta ./results.
.PARAMETER Tag
    Tag dos testes a serem executados (ex: smoke, regression, login_positivo).
.PARAMETER Headless
    Define se o navegador roda em segundo plano (True ou False). Padrão: False.
.PARAMETER Suite
    Caminho da suíte ou pasta de testes (Padrão: tests/).
.EXAMPLE
    .\scripts\run_tests.ps1 -Tag smoke
    .\scripts\run_tests.ps1 -Tag regression -Headless True
#>

param (
    [string]$Tag = "",
    [string]$Headless = "False",
    [string]$Suite = "tests"
)

$resultsDir = Join-Path $PSScriptRoot "..\results"

$tagDisplay = if ($Tag -ne "") { $Tag } else { "Todas" }

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " 🤖 Iniciando Execução dos Testes Robot Framework" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Suíte:    $Suite"
Write-Host "Tag:      $tagDisplay"
Write-Host "Headless: $Headless"
Write-Host "Resultados em: $resultsDir"
Write-Host "--------------------------------------------------"

$robotArgs = @(
    "-d", $resultsDir,
    "-v", "HEADLESS:$Headless"
)

if ($Tag -ne "") {
    $robotArgs += @("-i", $Tag)
}

$robotArgs += $Suite

robot @robotArgs

$exitCode = $LASTEXITCODE

Write-Host "--------------------------------------------------"
if ($exitCode -eq 0) {
    Write-Host "✅ Todos os testes passaram com sucesso!" -ForegroundColor Green
} else {
    Write-Host "❌ Ocorreram falhas durante a execução dos testes." -ForegroundColor Red
}
Write-Host "📄 Relatório disponível em: $resultsDir\report.html" -ForegroundColor Yellow
Write-Host "=================================================="

exit $exitCode
