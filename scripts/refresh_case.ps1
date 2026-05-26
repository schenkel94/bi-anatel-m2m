$ErrorActionPreference = "Stop"

# Confere os arquivos de entrada e instala as dependencias do notebook.

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $ProjectRoot

Write-Host ""
Write-Host "== Case BI ==" -ForegroundColor Cyan
Write-Host "Projeto: $ProjectRoot"

if (-not (Test-Path ".\seeds")) {
    throw "Pasta .\seeds nao encontrada. Crie a pasta e coloque os CSVs da Anatel antes de rodar."
}

$SeedFiles = Get-ChildItem -Path ".\seeds" -Filter "*.csv" -File
if ($SeedFiles.Count -eq 0) {
    throw "Nenhum CSV encontrado em .\seeds. Baixe os arquivos da Anatel antes de rodar."
}

Write-Host ""
Write-Host "Arquivos brutos encontrados:" -ForegroundColor Cyan
$SeedFiles | ForEach-Object {
    Write-Host ("- {0} ({1:N2} MB)" -f $_.Name, ($_.Length / 1MB))
}

Write-Host ""
Write-Host "Instalando/validando dependencias Python..." -ForegroundColor Cyan
python -m pip install -r .\requirements.txt

Write-Host ""
Write-Host "Notebook principal:" -ForegroundColor Green
Write-Host "notebooks\01_pipeline_camadas_dados.ipynb"
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Cyan
Write-Host "1. Abra o notebook no VS Code/Jupyter."
Write-Host "2. Rode as celulas em ordem."
Write-Host "3. Use o DuckDB gerado em data\03_analytics no Metabase."
Write-Host ""
