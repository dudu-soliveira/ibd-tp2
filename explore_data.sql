-- =================================================================
-- Tabela: municipio_pretrat
-- =================================================================

-- Amostra dos 10 primeiros registros da tabela
SELECT *
FROM municipio_pretrat
LIMIT 10;

-- Contagem de valores não nulos para cada coluna
-- Conclusão: Nenhuma coluna possui valor nulo
SELECT
    COUNT(*) AS total,
    COUNT(codigo_municipio_completo) AS total_codigo_municipio_completo,
    COUNT(municipio) AS total_municipio,
    COUNT(codigo_uf) AS total_codigo_uf,
    COUNT(uf) AS total_uf,
    COUNT(codigo_regiao_geografica_intermediaria) AS total_codigo_regiao_geografica_intermediaria,
    COUNT(nome_regiao_geografica_intermediaria) AS total_nome_regiao_geografica_intermediaria,
    COUNT(codigo_regiao_geografica_imediata) AS total_codigo_regiao_geografica_imediata,
    COUNT(nome_regiao_geografica_imediata) AS total_nome_regiao_geografica_imediata,
    COUNT(codigo_municipio_incompleto) AS total_codigo_municipio_incompleto
FROM municipio_pretrat;


-- =================================================================
-- Tabela: semana
-- =================================================================

-- Amostra dos 10 primeiros registros da tabela
SELECT *
FROM semana
LIMIT 10;

-- Contagem de valores não nulos para cada coluna
-- Conclusão: Nenhuma coluna possui valor nulo
SELECT
    COUNT(*) AS total,
    COUNT(semana_ano) AS total_semana_ano,
    COUNT(inicio) AS total_inicio,
    COUNT(termino) AS total_termino
FROM semana;


-- =================================================================
-- Tabela: obito_pretrat
-- =================================================================

-- Amostra dos 10 primeiros registros da tabela
SELECT *
FROM obito_pretrat
LIMIT 10;

-- Contagem de valores não nulos para cada coluna
-- Conclusão: Nenhuma coluna possui valor nulo
SELECT
    COUNT(*) AS total,
    COUNT(uf) AS total_uf,
    COUNT(municipio) AS total_municipio,
    COUNT(semana_epidemiologica) AS total_semana_epidemiologica,
    COUNT(populacao) AS total_populacao,
    COUNT(casos_novos_semana) AS total_casos_novos_semana,
    COUNT(casos_acumulados) AS total_casos_acumulados,
    COUNT(incidencia_100mil_hab) AS total_incidencia_100mil_hab,
    COUNT(obitos_novos_semana) AS total_obitos_novos_semana,
    COUNT(obitos_acumulados) AS total_obitos_acumulados,
    COUNT(taxa_mortalidade_100mil_hab) AS total_taxa_mortalidade_100mil_hab
FROM obito_pretrat;


-- =================================================================
-- Tabela: vacina_pretrat
-- =================================================================

-- Amostra dos 10 primeiros registros da tabela
SELECT *
FROM vacina_pretrat
LIMIT 10;

-- Contagem de valores não nulos para cada coluna
-- Conclusão: Nenhuma coluna possui valor nulo
SELECT
    COUNT(*) AS total,
    COUNT(cod_ibge) AS total_cod_ibge,
    COUNT(data) AS total_data,
    COUNT(municipio) AS total_municipio,
    COUNT(total_de_doses_aplicadas) AS total_de_doses_aplicadas,
    COUNT(primeira_dose) AS total_primeira_dose,
    COUNT(segunda_dose) AS total_segunda_dose,
    COUNT(terceira_dose) AS total_terceira_dose,
    COUNT(dose_reforco) AS total_dose_reforco,
    COUNT(primeira_dose_reforco) AS total_primeiro_dose_reforco,
    COUNT(segunda_dose_reforco) AS total_segundo_dose_reforco,
    COUNT(terceira_dose_reforco) AS total_terceiro_dose_reforco,
    COUNT(dose_adicional) AS total_dose_adicional,
    COUNT(dose_unica) AS total_dose_unica
FROM vacina_pretrat;
