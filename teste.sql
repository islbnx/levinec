WITH tab2020 AS (
    SELECT 
        nome_completo,
        email,
        tipo_do_produto,
        SUM(faturamento) AS faturamento_total_20,
        SUM(qtd_vendida) AS qtds_vendida_20
    FROM tabela_vendas
    WHERE ano_venda = 2020
        AND genero IN ("Masculino", "Feminino")
        AND estado_civil IN ("Casado", "Solteiro")
        AND nivel_escolar IN ("Superior Completo", "Superior Incompleto")
        AND continente = 'América do Norte'
        AND pais = 'Estados Unidos'
        AND tipo = 'Física'
    GROUP BY nome_completo, email, tipo_do_produto
),
tab2021 AS (
    SELECT 
        nome_completo,
        email,
        tipo_do_produto,
        SUM(faturamento) AS faturamento_total_21,
        SUM(qtd_vendida) AS qtds_vendida_21
    FROM tabela_vendas
    WHERE ano_venda = 2021
        AND genero IN ("Masculino", "Feminino")
        AND estado_civil IN ("Casado", "Solteiro")
        AND nivel_escolar IN ("Superior Completo", "Superior Incompleto")
        AND continente = 'América do Norte'
        AND pais = 'Estados Unidos'
        AND tipo = 'Física'
    GROUP BY nome_completo, email, tipo_do_produto
),
tabfull AS (
    SELECT 
        COALESCE(t20.nome_completo, t21.nome_completo) AS nome_completo,
        COALESCE(t20.email, t21.email) AS email,
        COALESCE(t20.tipo_do_produto, t21.tipo_do_produto) AS tipo_do_produtoo,
        t20.faturamento_total_20 AS faturamento_total_2020,
        t20.qtds_vendida_20 AS qtds_vendida_2020,
        t21.faturamento_total_21 AS faturamento_total_2021,
        t21.qtds_vendida_21 AS qtds_vendida_2021
    FROM tab2020 t20
    FULL JOIN tab2021 t21
        ON t20.nome_completo = t21.nome_completo
        AND t20.email = t21.email
),
cliente20 AS (
    SELECT
        tipo_do_produtoo AS produto_20,
        COUNT(nome_completo) AS qtd_clientes_20,
        SUM(faturamento_total_2020) AS faturamento_total_em_20
    FROM tabfull
    WHERE faturamento_total_2020 IS NOT NULL
    GROUP BY tipo_do_produtoo
),
cliente21_novos AS (
    SELECT 
        tipo_do_produtoo AS produto_21,
        COUNT(nome_completo) AS qtd_clientes_21_novo,
        SUM(faturamento_total_2021) AS faturamento_total_em_21_novo
    FROM tabfull
    WHERE faturamento_total_2020 IS NULL
        AND faturamento_total_2021 IS NOT NULL
    GROUP BY tipo_do_produtoo
),
cliente21_retornando AS (
    SELECT 
        tipo_do_produtoo,
        COUNT(nome_completo) AS qtd_clientes_21_retornando,
        SUM(faturamento_total_2021) AS faturamento_total_em_21_retornando
    FROM tabfull
    WHERE faturamento_total_2020 IS NOT NULL
        AND faturamento_total_2021 IS NOT NULL
    GROUP BY tipo_do_produtoo
),
cliente21_NAO_retornando AS (
    SELECT 
        tipo_do_produtoo,
        COUNT(nome_completo) AS qtd_clientes_21_NAO_retornando,
        SUM(faturamento_total_2021) AS faturamento_total_em_21_NAO_retornando
    FROM tabfull
    WHERE faturamento_total_2020 IS NOT NULL
        AND faturamento_total_2021 IS NULL
    GROUP BY tipo_do_produtoo
)
SELECT 
    *
FROM cliente20
CROSS JOIN cliente21_novos
CROSS JOIN cliente21_retornando
CROSS JOIN cliente21_NAO_retornando;
