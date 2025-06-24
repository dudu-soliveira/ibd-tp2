-- =================================================================
-- Verificação de Integridade das Junções
-- =================================================================

-- Verifica se a junção entre vacina_pretrat e municipio_pretrat resulta em perda de dados.
-- Compara a contagem total de linhas da tabela de vacinas com a contagem da junção.
-- Conclusão: As contagens são iguais, logo a junção é considerada segura.
SELECT COUNT(*)
FROM vacina_pretrat;

SELECT COUNT(*)
FROM vacina_pretrat vp JOIN municipio_pretrat mp ON vp.cod_ibge = (mp.codigo_municipio_completo / 10);

-- Verifica se a junção entre obito_pretrat e municipio_pretrat resulta em perda de dados.
-- Compara a contagem total de linhas da tabela de óbitos com a contagem da junção.
-- Conclusão: As contagens são iguais, logo a junção é considerada segura.
SELECT count(*)
FROM obito_pretrat;

SELECT count(*)
FROM obito_pretrat op JOIN municipio_pretrat mp ON (op.municipio = mp.municipio AND op.uf = op.uf);
