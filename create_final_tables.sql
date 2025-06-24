-- =================================================================
-- Criação do novo esquema de tabelas normalizado
-- =================================================================

BEGIN;

-- Tabela para armazenar as Unidades da Federação
CREATE TABLE uf (
    codigo_uf CHAR(2) PRIMARY KEY,
    nome CHAR(2) NOT NULL
);

-- Tabela para armazenar as Regiões Intermediárias
CREATE TABLE regiao_intermediaria (
    codigo_regiao_intermediaria CHAR(4) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Tabela para armazenar as Regiões Imediatas
CREATE TABLE regiao_imediata (
    codigo_regiao_imediata CHAR(6) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Tabela para armazenar os dados dos municípios
CREATE TABLE municipio (
    codigo_municipio CHAR(6) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    codigo_uf CHAR(2) NOT NULL,
    codigo_regiao_intermediaria CHAR(4) NOT NULL,
    codigo_regiao_imediata CHAR(6) NOT NULL,
    populacao INT NOT NULL
);

-- Tabela para armazenar os óbitos por semana
CREATE TABLE obito (
    cod_ibge CHAR(6) NOT NULL,
    semana_epidemiologica VARCHAR(7) NOT NULL,
    obitos_novos_semana INT NOT NULL,
    PRIMARY KEY (cod_ibge, semana_epidemiologica)
);

-- Tabela para armazenar os casos de COVID-19 por semana
CREATE TABLE caso (
    cod_ibge CHAR(6) NOT NULL,
    semana_epidemiologica VARCHAR(7) NOT NULL,
    casos_novos_semana INT NOT NULL,
    PRIMARY KEY (cod_ibge, semana_epidemiologica)
);

-- Tabela para armazenar os dados de vacinação
CREATE TABLE vacina (
    cod_ibge CHAR(6) NOT NULL,
    data DATE NOT NULL,
    total_de_doses_aplicadas INT NOT NULL,
    primeira_dose INT NOT NULL,
    segunda_dose INT NOT NULL,
    terceira_dose INT NOT NULL,
    dose_reforco INT NOT NULL,
    primeira_dose_reforco INT NOT NULL,
    segunda_dose_reforco INT NOT NULL,
    terceira_dose_reforco INT NOT NULL,
    dose_adicional INT NOT NULL,
    dose_unica INT NOT NULL,
    PRIMARY KEY (cod_ibge, data)
);

-- Adicionando restrições NOT NULL à tabela semana
ALTER TABLE semana
    ALTER COLUMN inicio SET NOT NULL,
    ALTER COLUMN termino SET NOT NULL;

-- =================================================================
-- Migração dos dados das tabelas antigas para as novas
-- =================================================================

-- Inserindo dados na tabela uf
INSERT INTO uf (codigo_uf, nome)
SELECT DISTINCT CAST(codigo_uf AS CHAR(2)), uf
FROM municipio_pretrat;

-- Inserindo dados na tabela regiao_intermediaria
INSERT INTO regiao_intermediaria (codigo_regiao_intermediaria, nome)
SELECT DISTINCT CAST(codigo_regiao_geografica_intermediaria AS CHAR(4)), nome_regiao_geografica_intermediaria
FROM municipio_pretrat;

-- Inserindo dados na tabela regiao_imediata
INSERT INTO regiao_imediata (codigo_regiao_imediata, nome)
SELECT DISTINCT CAST(codigo_regiao_geografica_imediata AS CHAR(6)), nome_regiao_geografica_imediata
FROM municipio_pretrat;

-- Tabela temporária para otimizar a junção entre municipio e óbito
-- Foi criado uma CTE para corrigir os dados de óbitos antes de realizar a junção
CREATE TEMPORARY TABLE temp_mp_op AS
WITH obitos_corrigidos AS (
    SELECT
        op2.uf,
        op2.municipio,
        '53-2020' AS semana_epidemiologica,
        op2.populacao,
        op1.casos_novos_semana + op2.casos_novos_semana AS casos_novos_semana,
        op2.casos_acumulados,
        op2.incidencia_100mil_hab,
        op1.obitos_novos_semana + op2.obitos_novos_semana AS obitos_novos_semana,
        op2.obitos_acumulados,
        op2.taxa_mortalidade_100mil_hab
    FROM obito_pretrat op1 JOIN obito_pretrat op2 ON (op1.uf = op2.uf AND op1.municipio = op2.municipio)
    WHERE op1.semana_epidemiologica = '53-2020' AND op2.semana_epidemiologica = '53-2021'
    UNION
    SELECT *
    FROM obito_pretrat
    WHERE semana_epidemiologica <> '53-2020' AND semana_epidemiologica <> '53-2021'
)
SELECT
    SUBSTRING(CAST(mp.codigo_municipio_completo AS TEXT), 1, 6) as codigo_municipio,
    mp.municipio as nome,
    CAST(mp.codigo_uf AS CHAR(2)) AS codigo_uf,
    CAST(mp.codigo_regiao_geografica_intermediaria AS CHAR(4)) AS codigo_regiao_intermediaria,
    SUBSTRING(CAST(mp.codigo_regiao_geografica_imediata AS TEXT), 1, 6) AS codigo_regiao_imediata,
    oc.populacao,
    oc.semana_epidemiologica,
    oc.obitos_novos_semana,
    oc.casos_novos_semana
FROM municipio_pretrat mp JOIN obitos_corrigidos oc ON (mp.municipio = oc.municipio AND mp.uf = oc.uf);

-- Inserindo dados na tabela municipio
INSERT INTO municipio (codigo_municipio, nome, codigo_uf, codigo_regiao_intermediaria, codigo_regiao_imediata, populacao)
SELECT DISTINCT codigo_municipio, nome, codigo_uf, codigo_regiao_intermediaria, codigo_regiao_imediata, populacao
FROM temp_mp_op;

-- Inserindo dados na tabela obito
INSERT INTO obito (cod_ibge, semana_epidemiologica, obitos_novos_semana)
SELECT codigo_municipio, semana_epidemiologica, obitos_novos_semana
FROM temp_mp_op;

-- Inserindo dados na tabela caso
INSERT INTO caso (cod_ibge, semana_epidemiologica, casos_novos_semana)
SELECT codigo_municipio, semana_epidemiologica, casos_novos_semana
FROM temp_mp_op;

-- Inserindo dados na tabela vacina
INSERT INTO vacina (cod_ibge, data, total_de_doses_aplicadas, primeira_dose, segunda_dose, terceira_dose, dose_reforco, primeira_dose_reforco, segunda_dose_reforco, terceira_dose_reforco, dose_adicional, dose_unica)
SELECT
    SUBSTRING(CAST(cod_ibge AS TEXT), 1, 6),
    data,
    total_de_doses_aplicadas,
    primeira_dose,
    segunda_dose,
    terceira_dose,
    dose_reforco,
    primeira_dose_reforco,
    segunda_dose_reforco,
    terceira_dose_reforco,
    dose_adicional,
    dose_unica
FROM vacina_pretrat;

-- Limpando a tabela temporária que não é mais necessária
DROP TABLE temp_mp_op;

-- =================================================================
-- Adicionando as Chaves Estrangeiras
-- =================================================================

-- Adiciona as restrições para a tabela 'municipio'
ALTER TABLE municipio
    ADD CONSTRAINT fk_municipio_uf FOREIGN KEY (codigo_uf) REFERENCES uf(codigo_uf),
    ADD CONSTRAINT fk_municipio_intermediaria FOREIGN KEY (codigo_regiao_intermediaria) REFERENCES regiao_intermediaria(codigo_regiao_intermediaria),
    ADD CONSTRAINT fk_municipio_imediata FOREIGN KEY (codigo_regiao_imediata) REFERENCES regiao_imediata(codigo_regiao_imediata);

-- Adiciona as restrições para a tabela 'obito'
ALTER TABLE obito
    ADD CONSTRAINT fk_obito_municipio FOREIGN KEY (cod_ibge) REFERENCES municipio(codigo_municipio),
    ADD CONSTRAINT fk_obito_semana FOREIGN KEY (semana_epidemiologica) REFERENCES semana(semana_ano);

-- Adiciona as restrições para a tabela 'caso'
ALTER TABLE caso
    ADD CONSTRAINT fk_caso_municipio FOREIGN KEY (cod_ibge) REFERENCES municipio(codigo_municipio),
    ADD CONSTRAINT fk_caso_semana FOREIGN KEY (semana_epidemiologica) REFERENCES semana(semana_ano);

-- Adiciona a restrição para a tabela 'vacina'
ALTER TABLE vacina
    ADD CONSTRAINT fk_vacina_municipio FOREIGN KEY (cod_ibge) REFERENCES municipio(codigo_municipio);

-- =================================================================
-- Removendo Tabelas de Pré-tratamento que não são mais necessárias
-- =================================================================

DROP TABLE municipio_pretrat;
DROP TABLE obito_pretrat;
DROP TABLE vacina_pretrat;

COMMIT;
