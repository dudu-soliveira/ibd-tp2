# 🧪 Efeitos Epidemiológicos da Cobertura Vacinal no Brasil (TP2 - IBD)

> Projeto prático desenvolvido para a disciplina de **Introdução a Banco de Dados (DCC/UFMG)** com o objetivo de analisar o impacto da vacinação contra a COVID-19 na taxa de óbitos e infecções no Brasil, utilizando dados do **DataSUS**, **Ministério da Saúde** e **IBGE**.

## 👥 Autores

- Eduardo de Sousa  
- Guilherme Bueno  
- Gustavo Cabral  
- Matheus Soares  
- Renato Lucas

## 📊 Objetivo

Investigar a possível correlação entre **cobertura vacinal** e **taxas de mortalidade/incidência** de COVID-19 no Brasil durante os anos de 2021 a 2025. Utilizamos dados públicos de saúde, estruturamos um banco relacional e realizamos análises estatísticas e espaciais.

## 🗂️ Estrutura do Projeto

```
├── check.py                  # Script de verificação dos dados e integridade
├── concat.py                # Concatenação e unificação de bases
├── obitos.py                # Tratamento da base de óbitos
├── vacinas.py               # Tratamento da base de vacinação
├── create_db.sql            # Criação inicial do banco
├── create_final_tables.sql  # Normalização do banco com chaves e constraints
├── joins.sql                # Scripts de junção para análises cruzadas
├── explore_data.sql         # Análises SQL exploratórias
├── pyproject.toml           # Dependências do projeto
├── uv.lock                  # Lockfile do ambiente Python
├── .gitignore
├── .python-version
└── README.md
```

## 🧬 Fontes de Dados

- [Painel de Vacinação COVID-19 - Ministério da Saúde](https://infoms.saude.gov.br/extensions/SEIDIGI_DEMAS_Vacina_C19/SEIDIGI_DEMAS_Vacina_C19.html)
- [Painel de Casos e Óbitos COVID-19 - Ministério da Saúde](https://infoms.saude.gov.br/extensions/covid-19_html/covid-19_html.html)
- [Códigos de Municípios - IBGE](https://www.ibge.gov.br/explica/codigos-dos-municipios.php)
- [Calendário Epidemiológico - SINAN](https://portalsinan.saude.gov.br/calendario-epidemiologico)

## 🛠️ Como Executar o Projeto

### Pré-requisitos

- Python 3.10+
- PostgreSQL
- `uv` (opcional, para ambientes virtuais mais leves)
- Bibliotecas Python:
  ```bash
  pip install pandas sqlalchemy psycopg2
  ```

### Etapas

1. **Criação do Banco:**

   Execute os scripts SQL:
   ```bash
   psql -U seu_usuario -d ibd_tp2 -f create_db.sql
   psql -U seu_usuario -d ibd_tp2 -f create_final_tables.sql
   ```

2. **Tratamento dos Dados:**

   Execute os scripts de ingestão:
   ```bash
   python obitos.py
   python vacinas.py
   python concat.py
   ```

3. **Análises:**

   Utilize:
   - `explore_data.sql` para análise exploratória;
   - `joins.sql` para cruzamento de dados e geração de insights.

4. **Verificação (opcional):**
   ```bash
   python check.py
   ```

## 📈 Resultados Principais

- **Correlação negativa** entre vacinação acumulada e número de óbitos (ex.: R ≈ -0.78 em 2021).
- **Redução significativa** na mortalidade após avanço da vacinação.
- **Disparidades regionais**, com estados como Espírito Santo apresentando resposta sanitária mais eficaz.

> Gráficos, mapas e análises completas estão no [relatório em PDF](./Relatório TP2 IBD.pdf).

## 📌 Observações

- As bases de dados apresentavam desafios como:
  - Subnotificação.
  - Campos nulos inconsistentes.
  - Incompatibilidade temporal.
- Esses problemas foram tratados via scripts Python.

## 📚 Bibliografia

Este projeto baseou-se em fontes oficiais e publicações técnicas. A bibliografia completa está no relatório PDF.

## 🖇️ Repositório

📎 Repositório original: [github.com/dudu-soliveira/ibd-tp2](https://github.com/dudu-soliveira/ibd-tp2)

---

