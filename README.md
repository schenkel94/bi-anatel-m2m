# Case BI - Anatel - M2M

# Mário Schenkel
### Data Analyst | Analytics Engineer

Transformo dados complexos em **insights estratégicos** para impulsionar decisões de negócio.

<p align="center">
  <a href="https://schenkel94.github.io/portfolio/">
    <img src="https://img.shields.io/badge/🌐 Portfólio-000?style=for-the-badge&logo=google-chrome&logoColor=white" />
  </a>
  <a href="https://www.linkedin.com/in/marioschenkel">
    <img src="https://img.shields.io/badge/🔗 LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" />
  </a>
</p>

Projeto de BI para analisar acessos moveis M2M no Brasil usando dados publicos da Anatel.

A entrega tem tres partes:

- tratamento dos CSVs brutos;
- geracao de uma base analitica em DuckDB;
- dashboard local no Metabase.

## Estrutura

```text
case/
  seeds/                         # CSVs brutos da Anatel
  notebooks/
    01_pipeline_camadas_dados.ipynb
  scripts/
    refresh_case.ps1
    start_metabase_case.ps1
  data/                          # arquivos gerados pelo notebook
```

## Tecnologias

- Python
- Pandas
- DuckDB
- Parquet
- Jupyter Notebook
- Metabase

## Atualizacao das seeds

O proprio notebook pode baixar e organizar os arquivos brutos da Anatel.

Na primeira etapa do notebook, ajuste:

```python
BAIXAR_DADOS_ANATEL = True
ANO_MINIMO_ACESSOS = 2025
```

Com isso, o ZIP publico da Anatel e baixado para `seeds/_downloads/`, os CSVs de acessos sao extraidos para `seeds/` e o arquivo de densidade e salvo em `seeds/densidades/`.

Para carregar todos os anos disponiveis, use:

```python
ANO_MINIMO_ACESSOS = None
```

Estrutura esperada depois do download:

```text
seeds/
  Acessos_Telefonia_Movel_2025_1S.csv
  Acessos_Telefonia_Movel_2025_2S.csv
  Acessos_Telefonia_Movel_2026_1S.csv
  densidades/
    Densidade_Telefonia_Movel.csv
```

## Como rodar

Na raiz do projeto:

```powershell
.\scripts\refresh_case.ps1
```

Depois abra e execute o notebook:

```text
notebooks/01_pipeline_camadas_dados.ipynb
```

O notebook cria as pastas em `data/` e gera o banco:

```text
data/03_analytics/case_bi.duckdb
```

## Camadas de dados

### Stage

Arquivos em `data/01_stage/`.

Aqui os CSVs brutos sao lidos, as colunas sao padronizadas e os dados sao salvos em Parquet.

### Quality

Arquivos em `data/02_quality/`.

Aqui o projeto filtra `Tipo de Produto = M2M` e faz checks simples de qualidade, como:

- base M2M com linhas;
- sem acessos negativos;
- periodos preenchidos;
- Connect presente na base.

### Analytics

Arquivos em `data/03_analytics/`.

Principais saidas:

- `case_bi.duckdb`
- `catalogo_marts.csv`
- `marts/*.parquet`
- `exports/*.csv`

Marts criados:

- `mart_m2m_empresa_mes`
- `mart_m2m_empresa_uf_mes`
- `mart_oportunidade_uf_mes`
- `mart_m2m_tecnologia_mes`
- `mart_radar_concorrentes`

## Metabase

Depois de gerar o DuckDB, suba o Metabase:

```powershell
.\scripts\start_metabase_case.ps1 -MetabaseJar "C:\caminho\metabase.jar" -PluginsDir "C:\caminho\plugins"
```

Depois acesse:

```text
http://localhost:3000
```

Os dashboards ja ficam salvos no banco interno do Metabase em `data/metabase-app-db/`.

Credenciais locais:

```text
email: case.bi@local.test
senha: CaseBI2026!
```

## Observacoes

- Os arquivos grandes sao versionados com Git LFS.
- O ZIP baixado fica em `seeds/_downloads/` e nao entra no Git.
- A base de densidade movel e usada apenas como apoio para leitura regional.
