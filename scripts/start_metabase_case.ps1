param(
    [int]$Port = 3000,
    [string]$MetabaseJar = $env:METABASE_JAR,
    [string]$PluginsDir = $env:METABASE_PLUGINS_DIR
)

$ErrorActionPreference = "Stop"

# Sobe um Metabase local usando o DuckDB gerado pelo notebook.

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$CaseDb = Join-Path $ProjectRoot "data\03_analytics\case_bi.duckdb"
$AppDbDir = Join-Path $ProjectRoot "data\metabase-app-db"
$NativeTmpDir = Join-Path $ProjectRoot "data\metabase-native-tmp"

if (-not (Test-Path $CaseDb)) {
    throw "Banco analitico nao encontrado em $CaseDb. Execute o notebook/pipeline antes de subir o Metabase."
}

if ([string]::IsNullOrWhiteSpace($MetabaseJar)) {
    throw "Informe o caminho do metabase.jar usando -MetabaseJar ou a variavel METABASE_JAR."
}

if ([string]::IsNullOrWhiteSpace($PluginsDir)) {
    throw "Informe a pasta de plugins usando -PluginsDir ou a variavel METABASE_PLUGINS_DIR."
}

if (-not (Test-Path $MetabaseJar)) {
    throw "metabase.jar nao encontrado em $MetabaseJar."
}

if (-not (Test-Path (Join-Path $PluginsDir "duckdb.metabase-driver.jar"))) {
    throw "Driver DuckDB do Metabase nao encontrado em $PluginsDir."
}

New-Item -ItemType Directory -Force -Path $AppDbDir, $NativeTmpDir | Out-Null

$env:MB_DB_FILE = Join-Path $AppDbDir "metabase.db"
$env:MB_PLUGINS_DIR = $PluginsDir
$env:MB_SITE_NAME = "Case BI Connect Virtueyes"
$env:MB_SITE_LOCALE = "pt-BR"
$env:MB_START_OF_WEEK = "monday"
$env:MB_JETTY_PORT = "$Port"
$env:JAVA_TOOL_OPTIONS = "-Djava.io.tmpdir=$NativeTmpDir"

Write-Host "Metabase do case iniciando em http://localhost:$Port"
Write-Host "Banco DuckDB do case:"
Write-Host $CaseDb.Replace("\", "/")

Set-Location (Split-Path -Parent $MetabaseJar)
java -jar $MetabaseJar
