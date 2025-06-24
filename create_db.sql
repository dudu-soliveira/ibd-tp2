-- =================================================================
-- Criação das Tabelas de Pré-tratamento
-- =================================================================

BEGIN;

SET DATESTYLE TO 'European';

-- Cria a tabela para armazenar os dados brutos dos municípios.
CREATE TABLE municipio_pretrat (
    codigo_municipio_completo INT PRIMARY KEY,
    municipio VARCHAR(255),
    codigo_uf INT,
    uf CHAR(2),
    codigo_regiao_geografica_intermediaria INT,
    nome_regiao_geografica_intermediaria VARCHAR(255),
    codigo_regiao_geografica_imediata INT,
    nome_regiao_geografica_imediata VARCHAR(255),
    codigo_municipio_incompleto INT
);

-- Cria a tabela para armazenar os dados brutos de óbitos por COVID-19.
CREATE TABLE obito_pretrat (
    uf CHAR(2),
    municipio VARCHAR(255),
    semana_epidemiologica VARCHAR(7),
    populacao INT,
    casos_novos_semana INT,
    casos_acumulados INT,
    incidencia_100mil_hab VARCHAR(255),
    obitos_novos_semana INT,
    obitos_acumulados INT,
    taxa_mortalidade_100mil_hab VARCHAR(255),
    PRIMARY KEY (uf, municipio, semana_epidemiologica)
);

-- Cria a tabela para armazenar os dados brutos de vacinação.
CREATE TABLE vacina_pretrat (
    cod_ibge INT,
    data DATE,
    municipio VARCHAR(255),
    total_de_doses_aplicadas INT,
    primeira_dose INT,
    segunda_dose INT,
    terceira_dose INT,
    dose_reforco INT,
    primeira_dose_reforco INT,
    segunda_dose_reforco INT,
    terceira_dose_reforco INT,
    dose_adicional INT,
    dose_unica INT,
    PRIMARY KEY (cod_ibge, data)
);

-- Cria a tabela para armazenar as semanas epidemiológicas.
CREATE TABLE semana (
    semana_ano VARCHAR(7) PRIMARY KEY,
    inicio DATE,
    termino DATE
);

-- =================================================================
-- Importação de Dados dos Arquivos CSV
-- NOTA: Substitua o caminho vazio ('') pelo caminho absoluto do seu arquivo.
-- =================================================================

\copy vacina_pretrat(cod_ibge, municipio, total_de_doses_aplicadas, primeira_dose, segunda_dose, terceira_dose, dose_reforco, primeira_dose_reforco, segunda_dose_reforco, terceiro_dose_reforco, dose_adicional, dose_unica, data) FROM '' DELIMITER ',' CSV HEADER;
\copy obito_pretrat(uf, municipio, populacao, casos_novos_semana, casos_acumulados, incidencia_100mil_hab, obitos_novos_semana, obitos_acumulados, taxa_mortalidade_100mil_hab, semana_epidemiologica) FROM '' DELIMITER ',' CSV HEADER;
\copy semana(semana_ano, inicio, termino) FROM '' DELIMITER ',' CSV HEADER;
\copy municipio_pretrat(codigo_uf, uf, codigo_regiao_geografica_intermediaria, nome_regiao_geografica_intermediaria, codigo_regiao_geografica_imediata, nome_regiao_geografica_imediata, codigo_municipio_incompleto, codigo_municipio_completo, municipio) FROM '' DELIMITER ',' CSV HEADER;

COMMIT;
