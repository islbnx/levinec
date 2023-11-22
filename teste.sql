-- Juntando tabelas
WITH tab1 AS
(
       SELECT *
       FROM   bd_vendas AS t1
       JOIN   bd_cliente AS t2
       ON     t1.id_cliente = t2.id_cliente
       JOIN   bd_loja AS t3
       ON     t1.id_loja = t3.id_loja
       JOIN   bd_localidade AS t4
       ON     t3.id_localidade = t4.id_localidade
       JOIN   bd_produtos AS t5
       ON     t1.sku = t5.sku ), 
    tabelavendas AS
        (
       SELECT data_da_venda,
              DAY(data_da_venda) AS dia_venda,
              MONTH(data_da_venda) AS mes_venda,
              YEAR(data_da_venda) AS ano_venda,
              ordem_de_compra,
              qtd_vendida,
                     concat(primeiro_nome," ", sobrenome) AS nome_completo,
              email,
              CASE
                     WHEN genero = 'F' THEN 'Feminino'
                     WHEN genero = 'M' THEN 'Masculino'
                     ELSE 'Outros'
              END                                 AS genero,
              year(now()) - year(data_nascimento) AS idade,
              CASE
                     WHEN estado_civil = 'S' THEN 'Solteiro'
                     WHEN estado_civil = 'C' THEN 'Casado'
                     ELSE 'Outro'
              END AS estado_civil,
              num_filhos,
              nivel_escolar,
              nome_da_loja,
              tipo,
              gerente_loja,
              pais,
              continente,
              produto,
              marca,
              tipo_do_produto,
              preco_unitario,
              custo_unitario,
              (qtd_vendida * preco_unitario) - custo_unitario AS faturamento,
              observacao
       FROM   tab1)
SELECT *
FROM   tabelavendas
