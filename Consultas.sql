-- MÃOS A OBRA
-- Exploração Inicial
SELECT * FROM notas_fiscais LIMIT 10;

SELECT * FROM itens_notas_fiscais LIMIT 10;

SELECT * FROM tabela_de_clientes LIMIT 10;

SELECT * FROM tabela_de_produtos LIMIT 10;

SELECT * FROM tabela_de_vendedores LIMIT 10;

SELECT COUNT(*) FROM notas_fiscais;

SELECT COUNT(MATRICULA) FROM notas_fiscais;

SELECT COUNT(*) FROM tabela_de_clientes 
WHERE ENDERECO_1 IS NULL;

-- 1. Quantos produtos são comercializados e qual o mais vendido?
SELECT DISTINCT CODIGO_DO_PRODUTO, NOME_DO_PRODUTO FROM tabela_de_produtos 
	ORDER BY CODIGO_DO_PRODUTO DESC;

SELECT inf.CODIGO_DO_PRODUTO, p.NOME_DO_PRODUTO, COUNT(inf.QUANTIDADE) AS Total_Vendas 
	FROM itens_notas_fiscais inf
	INNER JOIN tabela_de_produtos p
    ON inf.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
    GROUP BY CODIGO_DO_PRODUTO
    ORDER BY Total_Vendas desc
    LIMIT 5; 
    
-- 2. Qual o cliente mais fiel?
SELECT NOME, VOLUME_DE_COMPRA FROM tabela_de_clientes 
	ORDER BY VOLUME_DE_COMPRA desc LIMIT 5;
    
-- 3. Em um cenário onde todos os vendedores tem o mesmo salário-base e eles recebem um 
-- percentual de vendas. Qual o vendedor com maior percentual de comissão?
SELECT NOME, PERCENTUAL_COMISSAO FROM tabela_de_vendedores 
	ORDER BY PERCENTUAL_COMISSAO DESC;
    
SELECT v.NOME, COUNT(nf.MATRICULA) as Quantidade_Vendida FROM notas_fiscais nf
	INNER JOIN tabela_de_vendedores v
    	ON nf.MATRICULA = v.matricula
GROUP BY v.NOME
ORDER BY Quantidade_Vendida DESC;

-- 4. Quantos clientes ainda não compraram no nosso site?
SELECT 
    COUNT(*) AS NUNCA_COMPRARAM
FROM tabela_de_clientes
WHERE PRIMEIRA_COMPRA = 0
GROUP BY PRIMEIRA_COMPRA;

SELECT NOME, PRIMEIRA_COMPRA
FROM tabela_de_clientes 
WHERE PRIMEIRA_COMPRA=0;

-- 5. Qual o estado que mais comprou?
SELECT inf.NUMERO, SUM(QUANTIDADE) AS Total_itens, nf.CPF, tbc.ESTADO 
FROM itens_notas_fiscais inf, notas_fiscais nf, tabela_de_clientes tbc
WHERE inf.NUMERO = nf.NUMERO
AND nf.CPF = tbc.CPF
GROUP BY inf.NUMERO LIMIT 5;

SELECT ESTADO, COUNT(Total_itens) AS Total FROM
    (SELECT inf.NUMERO, SUM(QUANTIDADE) AS Total_itens, nf.CPF, tbc.ESTADO 
     FROM itens_notas_fiscais inf, notas_fiscais nf, tabela_de_clientes tbc
     WHERE inf.NUMERO = nf.NUMERO
     AND nf.CPF = tbc.CPF
     GROUP BY inf.NUMERO) 
     AS subconsulta
GROUP BY ESTADO
ORDER BY Total DESC;

-- 6. Qual o melhor vendedor?
SELECT tdv.NOME Nome, nf.MATRICULA ID_Vendedor, COUNT(NF.MATRICULA) Total_Vendas
FROM notas_fiscais nf
INNER JOIN tabela_de_vendedores tdv
USING (MATRICULA)
GROUP BY NF.MATRICULA;

-- 7. Quais os níveis de senioridade dos vendedores de acordo com o tempo na empresa?
-- Senior > 3 anos 
-- Pleno > 2 
-- e < 3 anos Junior 0 a 2 anos 
-- Sendo que nossa base tem registros de 2014 a 2017 e estamos no ano de 2018
SELECT
    NOME,
    DATA_ADMISSAO,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, DATA_ADMISSAO, '2018-01-01') > 3 THEN 'Senior'
        WHEN TIMESTAMPDIFF(YEAR, DATA_ADMISSAO, '2018-01-01') >= 2 AND TIMESTAMPDIFF(YEAR, DATA_ADMISSAO, '2018-01-01') <= 3 THEN 'Pleno'
        WHEN TIMESTAMPDIFF(YEAR, DATA_ADMISSAO, '2018-01-01') >= 0 AND TIMESTAMPDIFF(YEAR, DATA_ADMISSAO, '2018-01-01') < 2 THEN 'Junior'
        ELSE 'Outra Categoria'
    END AS Categoria
FROM
    tabela_de_vendedores;
    
-- 8. Qual a venda que teve o maior faturamento?
SELECT 
    inf.NUMERO AS Nota_fiscal,
    ROUND(SUM(inf.PRECO * inf.QUANTIDADE), 2) AS Valor_Total
FROM itens_notas_fiscais inf	
GROUP BY inf.NUMERO
ORDER BY Valor_Total desc LIMIT 5;

-- 9. Qual a venda que teve a maior quantidade de produtos?
SELECT NUMERO Nota_fiscal, SUM(QUANTIDADE) Quantidade_Itens FROM itens_notas_fiscais 
GROUP BY NUMERO
ORDER BY Quantidade_itens desc
LIMIT 5;

-- 10. Qual geração compra mais, X,Y ou Z? Quero lançar um novo sabor, qual meu pÚblico alvo?
SELECT
    NOME,
    DATA_DE_NASCIMENTO,
    CASE
        WHEN YEAR(DATA_DE_NASCIMENTO) BETWEEN 1965 AND 1980 THEN 'Geração X'
        WHEN YEAR(DATA_DE_NASCIMENTO) BETWEEN 1981 AND 1996 THEN 'Geração Y (Millennials)'
        WHEN YEAR(DATA_DE_NASCIMENTO) BETWEEN 1997 AND 2010 THEN 'Geração Z'
        WHEN YEAR(DATA_DE_NASCIMENTO) >= 2011 THEN 'Geração Alfa'
        ELSE 'Outra Geração'
    END AS Geracao
FROM
    tabela_de_clientes;
    
-- 11. Quero fazer um evento, em que região posso promover esse evento?
SELECT CIDADE, COUNT(CIDADE) 
FROM tabela_de_clientes 
GROUP BY CIDADE;

-- 12. Em um sorteio que cada cliente ganha 1 bilhete por compra, qual cliente tem mais chance de ganhar 
-- e qual a localização desse cliente, antecipando o valor do frete em um envio de produtos?
SELECT tdc.NOME, COUNT(nf.NUMERO) Quantidade_notas 
FROM notas_fiscais nf INNER JOIN tabela_de_clientes tdc
USING (CPF)
GROUP BY nf.CPF
ORDER BY Quantidade_notas DESC
LIMIT 5;