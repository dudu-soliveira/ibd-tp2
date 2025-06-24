-- =================================================================
-- Tabela: vacina_pretrat
-- =================================================================

-- Conta o número total de registros na tabela de vacinação.
SELECT COUNT(*)
FROM vacina_pretrat;
-- Contagem: 3433001

-- Verifica se a junção entre vacina_pretrat e municipio_pretrat resulta em perda de dados.
-- Compara a contagem total de linhas da tabela de vacinas com a contagem da junção.
SELECT COUNT(*)
FROM vacina_pretrat vp JOIN municipio_pretrat mp ON vp.cod_ibge = (mp.codigo_municipio_completo / 10);
-- Contagem: 3433001

-- ============ Conclusão: As contagens são iguais, logo a junção é considerada segura. ============


-- =================================================================
-- Tabela: obito_pretrat
-- =================================================================

-- Conta o número total de registros na tabela de óbitos.
SELECT COUNT(*)
FROM obito_pretrat;
-- Contagem = 1520610

-- Verifica se a junção entre obito_pretrat e municipio_pretrat resulta em perda de dados.
-- Compara a contagem total de linhas da tabela de óbitos com a contagem da junção.
SELECT COUNT(*)
FROM obito_pretrat op JOIN municipio_pretrat mp ON (op.municipio = mp.municipio AND op.uf = mp.uf);
-- Contagem = 1520610

-- ============ Conclusão: As contagens são iguais, logo a junção é considerada segura. ============

-- Verifica se a junção entre obito_pretrat e semana resulta em perda de dados.
-- Compara a contagem total de linhas da tabela de óbitos com a contagem da junção.
SELECT COUNT(*)
FROM obito_pretrat op JOIN semana s ON (op.semana_epidemiologica = s.semana_ano);
-- Contagem: 1515040

-- ============ Conclusão: As contagens são diferentes, logo há perda de dados na junção. ============

-- Verificando quais dados foram perdidos na junção entre obito_pretrat e semana.
SELECT *
FROM obito_pretrat op LEFT JOIN semana s ON (op.semana_epidemiologica = s.semana_ano)
WHERE s.semana_ano IS NULL;
-- Todos os dados são referentes à semana epidemiológica '53-2021', a qual não é uma semana válida.
-- Após análise da fonte dos dados é possível identificar que essa semana se refere ao período de
-- 01/01/2021 a 02/01/2021, o qual pertence à semana epidemiológica '53-2020'.

-- ============ Conclusão: É necessário juntar os dados das semanas epidemiológicas '53-2020' e '53-2021' ============

-- Conta o número de registros para a semana epidemiológica '53-2020'.
SELECT COUNT(*)
FROM obito_pretrat
WHERE semana_epidemiologica = '53-2020';
-- Contagem: 5570

-- Conta o número de registros para a semana epidemiológica '53-2021'.
SELECT COUNT(*)
FROM obito_pretrat
WHERE semana_epidemiologica = '53-2021';
-- Contagem: 5570

-- Conta quantos municípios possuem registros para AMBAS as semanas, '53-2020' e '53-2021'.
SELECT COUNT(*)
FROM obito_pretrat op1 JOIN obito_pretrat op2 ON (op1.uf = op2.uf AND op1.municipio = op2.municipio)
WHERE op1.semana_epidemiologica = '53-2020' AND op2.semana_epidemiologica = '53-2021';
-- Contagem: 5570

-- ============ Conclusão: As contagens são iguais, logo será possível agregar os dados sem perda de informação. ============

-- Seleciona e agrega os dados das semanas '53-2020' e '53-2021' para inspeção.
SELECT
    op1.casos_novos_semana + op2.casos_novos_semana AS casos_novos_semana,
    op1.casos_novos_semana as op1_casos,
    op2.casos_novos_semana as op2_casos,
    op1.obitos_novos_semana + op2.obitos_novos_semana AS obitos_novos_semana,
    op1.obitos_novos_semana as op1_obitos,
    op2.obitos_novos_semana as op2_obitos,
    op1.uf,
    op1.municipio,
    op1.semana_epidemiologica,
    op1.populacao
FROM obito_pretrat op1 JOIN obito_pretrat op2 ON (op1.uf = op2.uf AND op1.municipio = op2.municipio)
WHERE op1.semana_epidemiologica = '53-2020' AND op2.semana_epidemiologica = '53-2021';
