[![author](https://img.shields.io/badge/author-mateusramos-red.svg)](https://www.linkedin.com/in/mateus-simoes-ramos/) ![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)
# Storytelling usando SQL em uma Análise Exploratória
<p align="center">
	<img alt="Capa SQL" width="75%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/14801ef6-65f6-4cbc-876c-065b5cf85533">
</p>

<p align="right">
<a href="https://br.freepik.com/vetores-gratis/ilustracao-do-conceito-abstrato-de-armazenamento-de-big-data_12291144.htm#page=2&query=people%20sql&position=0&from_view=search&track=ais&uuid=2f3d7578-d259-48d6-add8-34cc7949006b" >Imagem de vectorjuice
</a> no Freepik
</p>
<br>

## Objetivo do Estudo
O objetivo deste projeto é realizar uma análise exploratória de uma base de dados que contém: **produtos, clientes, vendedores e nota fiscal** para identificar informações a fim de contextualizar os dados para melhorar o direcionamento do negócio. Para concentrar na **análise de dados** não irei realizar algumas operações importantes de SQL como executar um **CRUD** ou verificar 
se as tabelas estão cumprindo as **formas normais**, embora será aplicado algumas dessas regras para melhorar a compreenssão das consultas.
O contexto é uma loja que comercializa sucos e quer potencializar suas vendas usando dados.

**Para acessar o arquivo com as perguntas no Colab, clique no link abaixo:**
 - [Projeto no Colab](https://colab.research.google.com/drive/17lsOdQxSAA1CTmmYqIMOUsk_MFFr6r8Q?usp=sharing)

## Fonte dos Dados
Os dados foram obtidos de uma formação, portanto para fazer o download, apenas pelo arquivo disponível nesse repositório.

## Tecnologias Utilizadas
<p align="left">  
	<a href="https://www.mysql.com/" target="_blank" rel="noreferrer"> <img src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/8bfd0366-37bc-4a57-8a2a-f38b380c8ba5" alt="SQL" width="60" height="60"/> 
	</a>
  <a href="https://colab.google/" target="_blank" rel="noreferrer"> <img src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/f59f8f0b-c39c-49e3-843e-824d73b73478" alt="Colab Google" width="85" height="50"/> 
	</a>
  <a href="https://jupyter.org/" target="_blank" rel="noreferrer"> <img src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/50b56155-da53-4c88-9f6b-132edaf99ba2" alt="Jupyter Notebook" width="50" height="50"/> 
	</a>
</p>

---

<br>
<br>

## Mãos a obra...

> Caso prefira, clique abaixo para pular o desenvolvimento deste trabalho direto para os Resultados.
> <br>
> **[Resultados](#resultados)**

### 1. Entendendo os Dados
O foco nesse trabalho é fazer uma análise dos dados. Então partindo do pressuposto que os dados já foram gerados, limpos e carregados no SGBD escolhido, é necessário fazer uma primeira análise para entender os dados que estão contidos e quais informações esses dados podem fornecer. 

### 1.1 Diagrama ER
O MySQL Worchbench tem uma função que gera um esquema visual das tabelas (Diagrama Entidade-Relacionamento), que será um guia para as consultas. Abaixo estão os passos para gerar esse diagrama automaticamente:

<!--
Estudar e melhorar a análise e a descrição desse ponto
-->

>Database/Reverse Engineer
>
> Clique em Next/Selecione a Base de Dados/Next/Finish

<p align="center">
  <img alt="Diagrama EER" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/48073776-5abf-4f37-aa1a-20343c8c5bea">
</p>

Como resultado dessa representação, temos algumas respostas:

**tabela_de_vendedores** 1 pra N **notas_fiscais** <br>
> Um vendedor pode estar relacionado a muitas notas fiscais

**tabela_de_clientes** 1 pra N **notas_fiscais** <br>
> Um cliente pode estar relacionado a muitas notas fiscais

**notas_fiscais** 1 pra N **itens_notas_fiscais** <br>
> Uma nota fiscal pode estar relacionado a muitos dados fiscais dos itens

**tabela_de_produtos** 1 pra N **itens_notas_fiscais**
> Um produto pode estar relacionado a muitos dados fiscais dos itens
<br>
Vemos que a tabela **notas_fiscais** é central e interliga todas as outras. Lembrando que aqui não tem "certo e errado", são as regras do negócio que indicam qual deve ser o relacionamento entre as tabelas.

### 1.2 Exploração inicial
Após analisar o relacionamento entre as tabelas, é necessário conhecer quais os registros que cada tabela tem, para esse passo, usei SELECT para ver todos os cabeçalhos das tabelas.

```SQL
SELECT * FROM notas_fiscais LIMIT 10;
SELECT * FROM itens_notas_fiscais LIMIT 10;
SELECT * FROM tabela_de_clientes LIMIT 10;
SELECT * FROM tabela_de_produtos LIMIT 10;
SELECT * FROM tabela_de_vendedores LIMIT 10;
```

Após ver os cabeçalhos, também é ncessário ver a quantidade de linhas para saber qual o tamanho do nosso database. Temos os seguintes resultados acerca das nossas tabelas.

Nome da Tabela | Quantidade de Linhas | Quantidade de Colunas | Valores Nulos
---------------|----------------------|-----------------------|---------------
itens_notas_fiscais  | 213364 | 4  | 0
notas_fiscais        | 87877  | 5  | 0 
tabela_de_clientes   | 15     | 14 | 0
tabela_de_produtos   | 31     | 6  | 0
tabela_de_vendedores | 4      | 6  | 0

```SQL
SELECT COUNT(*) FROM notas_fiscais;
SELECT COUNT(MATRICULA) FROM notas_fiscais;
```
> COUNT(*) retorna todas as linhas, independente de ter valores nulos ou não.
 <br>
 
Para saber se tem valores nulos, basta apenas comparar a quantidade de valores de uma coluna com a quantidade de total de linhas, se o número for o mesmo, não tem valores nulos, se o número for menor, significa que contém valores nulos por que o **COUNT nome_coluna** não contabiliza valores nulos.
<br>

Mais uma maneira de verificar os valores nulos é usando **WHERE + IS NULL**

```SQL
SELECT COUNT(*) FROM tabela_de_clientes 
WHERE ENDERECO_1 IS NULL;
```

---

Outra representação que o MySQL Workbench tem, é uma representação das propriedades da tabela, basta apenas dar um clique simples na tabela, e na parte inferior esquerda, então é mostrado essa representação. Informações como chave primária, colunas com valores inteiros, decimal, texto... 

<p align="center">
  <img alt="Dashboard" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/0c13a233-563d-4990-b3d4-39c95eb2e972">
</p>

<br>
<br>

---

### 2 Análise Exploratória
Após visualizar o cabeçalho de todas as tabelas, verificar as informações com mais atenção e conhecer como está estruturado a base de dados, já se pode usar a criatividade e aplicar as consultas para extrair as informações e análises direcionadas pelos dados e pelas **perguntas**. Para a organização desse etapa, separei algumas **perguntas e contextos** para serem respondidas pelos dados:

<br>
<br>
<br>

### 1. Quantos produtos são comercializados e qual o mais vendido?
```SQL
SELECT DISTINCT CODIGO_DO_PRODUTO, NOME_DO_PRODUTO FROM tabela_de_produtos 
	ORDER BY CODIGO_DO_PRODUTO DESC;
```
<p align="left">
  <img alt="Dashboard" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/a87baa66-80c2-4d9f-882d-d27ade924631">
</p>

```SQL
SELECT inf.CODIGO_DO_PRODUTO, p.NOME_DO_PRODUTO, COUNT(inf.QUANTIDADE) AS Total_Vendas 
	FROM itens_notas_fiscais inf
	INNER JOIN tabela_de_produtos p
    ON inf.CODIGO_DO_PRODUTO = p.CODIGO_DO_PRODUTO
    GROUP BY CODIGO_DO_PRODUTO
    ORDER BY Total_Vendas desc
    LIMIT 5; 
```
<p align="left">
  <img alt="Dashboard" width="73%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/6c5468a8-6500-47dd-b599-43bb7c153f4d">
</p>

Temos o resultado de 31 produtos sendo comercializados.
E também o top 5 produtos mais vendidos.

<br>
<br>
<br>

### 2. Qual o cliente mais fiel?
```SQL
SELECT NOME, VOLUME_DE_COMPRA FROM tabela_de_clientes 
	ORDER BY VOLUME_DE_COMPRA desc LIMIT 5;
```
<p align="left">
  <img alt="Dashboard" width="55%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/7399d564-9e87-4076-b296-f793153274ea">
</p>

Nesses 4 anos Abel Silva é o o cliente que mais comprou com um volume de $ 26.000.

<br>
<br>
<br>

### 3. Em um cenário onde todos os vendedores tem o mesmo salário-base e eles recebem um percentual de vendas. Qual o vendedor com maior percentual de comissão?
```SQL
SELECT NOME, PERCENTUAL_COMISSAO FROM tabela_de_vendedores 
	ORDER BY PERCENTUAL_COMISSAO DESC;
```
<p align="left">
  <img alt="Dashboard" width="55%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/212b8fc9-b838-4c7d-97ae-787907c99228">
</p>

```SQL
SELECT v.NOME, COUNT(nf.MATRICULA) as Quantidade_Vendida FROM notas_fiscais nf
	INNER JOIN tabela_de_vendedores v
    	ON nf.MATRICULA = v.matricula
	GROUP BY v.NOME
	ORDER BY Quantidade_Vendida DESC;
```

<p align="left">
  <img alt="Dashboard" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/2904c45f-ece2-4b80-9a1b-48b9f7081e4b">
</p>
Roberta e Péricles são os vendedores que mais ganham comissão.
Porém quando verificamos o volume de vendas de cada vendedor, vemos que Péricles não tem nenhuma venda, então Roberta é a vendedora com mais comissão.
Também é possível avaliar que dos outros dois vendedores, ela é a que menos vendeu.
Cabe uma avaliação da Roberta e também avaliar uma promoção para o Márcio e a Cláudia.

<br>
<br>
<br>

### 4. Quantos clientes ainda não compraram no nosso site?
```SQL
SELECT 
    COUNT(*) AS NUNCA_COMPRARAM
FROM tabela_de_clientes
WHERE PRIMEIRA_COMPRA = 0
GROUP BY PRIMEIRA_COMPRA;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/4780299f-342e-44ef-876f-4a770e52e052">
</p>

```SQL
SELECT NOME, PRIMEIRA_COMPRA
FROM tabela_de_clientes 
WHERE PRIMEIRA_COMPRA=0;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/ce763d93-05a9-41e2-addf-8f1787b8da78">
</p>

Na tabela de cliente há uma coluna que expressa se um cliente cadastrado já fez uma compra ou não, isso seria interessante para campanhas marketing ou cupons direcionadas a esses 

<br>
<br>
<br>

### 5. Qual o estado que mais comprou?
```SQL
SELECT inf.NUMERO, SUM(QUANTIDADE) AS Total_itens, nf.CPF, tbc.ESTADO 
FROM itens_notas_fiscais inf, notas_fiscais nf, tabela_de_clientes tbc
WHERE inf.NUMERO = nf.NUMERO
AND nf.CPF = tbc.CPF
GROUP BY inf.NUMERO LIMIT 5;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/02987432-e10a-4745-a3cd-c06fd18f3070">
</p>

Para resolver essa questão, precisei recuperar informações de 3 tabelas distintas.
Iniciei por fazer uma contagem da tabela *itens_nota_fiscal*, então agrupei todos os itens por nota. Após essa etapa, recuperei na tabela *notas_fiscais*, o CPF dos clientes. E por fim, recuperei na tabela *tabela_de_clientes*, os estados cadastrados por cliente para fazer um agrupamento por estados da quantidade de produtos vendidos.

```SQL
SELECT ESTADO, COUNT(Total_itens) AS Total FROM
    (SELECT inf.NUMERO, SUM(QUANTIDADE) AS Total_itens, nf.CPF, tbc.ESTADO 
     FROM itens_notas_fiscais inf, notas_fiscais nf, tabela_de_clientes tbc
     WHERE inf.NUMERO = nf.NUMERO
     AND nf.CPF = tbc.CPF
     GROUP BY inf.NUMERO) 
     AS subconsulta
GROUP BY ESTADO
ORDER BY Total DESC;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/0656e4f6-e667-4ea4-8ad2-aa6856d285cb">
</p>

A primeira instrução criada virou uma subconsulta para a segunda instrução, chegando na resposta requerida com 50395 itens vendidos para o estado do Rio de Janeiro e 37482 para o Estado de São Paulo. Informação validade pela quantidade de registros na tabela *notas_fiscais*.

<br>
<br>
<br>

### 6. Qual o melhor vendedor?
```SQL
SELECT tdv.NOME Nome, nf.MATRICULA ID_Vendedor, COUNT(NF.MATRICULA) Total_Vendas
FROM notas_fiscais nf
INNER JOIN tabela_de_vendedores tdv
USING (MATRICULA)
GROUP BY NF.MATRICULA;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/e5690285-49ee-41b6-bec1-9c9b0ec7c144">
</p>

Para responder essa pergunta, fiz uma contagem na tabela de notas fiscal quantas vezes apareceu o ID dos vendedores e fiz uma agregação. Também fiz uma junção das tabelas para recuperar o nome do vendedor de acordo com o ID encontrado na nota fiscal.

<br>
<br>
<br>

### 7. Quais os níveis de senioridade dos vendedores de acordo com o tempo na empresa? 
**<p>Senior > 3 anos </p>**
**<p> Pleno > 2 e < 3 anos </p>**
**<p> Junior 0 a 2 anos </p>**
**<p> Sendo que nossa base tem registros de 2014 a 2017 e estamos no ano de 2018 </p>**
	
```SQL
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
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/374d568b-130c-4533-804b-503d8bcd7166">
</p>
Usando *TIMESTAMPDIFF*, conseguimos fazer cálculo entre as datas, classificando os vendedores de acordo com seu tempo de trabalho.
Mesmo sabendo que experiência não se mede apenas com o tempo de trabalho, essa é uma métrica para encontrar essa resposta.

<br>
<br>
<br>

### 8. Qual a venda que teve o maior faturamento?
```SQL
SELECT 
    inf.NUMERO AS Nota_fiscal,
    ROUND(SUM(inf.PRECO * inf.QUANTIDADE), 2) AS Valor_Total
FROM itens_notas_fiscais inf	
GROUP BY inf.NUMERO
ORDER BY Valor_Total desc LIMIT 5;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/6fc2cb1e-3a48-42a0-b9c3-622c378cc1cf">
</p>

A maior venda foi no valor de $ 9211.09

<br>
<br>
<br>

### 9. Qual a venda que teve a maior quantidade de produtos?
```SQL
SELECT NUMERO Nota_fiscal, SUM(QUANTIDADE) Quantidade_Itens FROM itens_notas_fiscais 
GROUP BY NUMERO
ORDER BY Quantidade_itens desc
LIMIT 5;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/1dd1c296-7800-4b6c-87c6-a7fcb1ee07a0">
</p>

A nota fiscal com mais itens tem a quantidade 381 unidades.

<br>
<br>
<br>

### 10. Qual geração compra mais, X,Y ou Z? Quero lançar um novo sabor, qual meu pÚblico alvo?
```SQL
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
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/714d0b68-9160-4599-9b13-d3835c85d721">
</p>
Temos 13 clientes na geração Y e apenas 2 na geração Z, pode ser uma informação relevante antes de fazer uma campanha de marketing.

<br>
<br>
<br>

### 11. Quero fazer um evento, em que região posso promover esse evento?
```SQL
SELECT CIDADE, COUNT(CIDADE) 
FROM tabela_de_clientes 
GROUP BY CIDADE;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/a633a239-2017-440f-9c91-03959e347fa0">
</p>
Todos os nossos clientes são de São Paulo e do Rio de Janeiro.

<br>
<br>
<br>

### 12. Em um sorteio que cada cliente ganha 1 bilhete por compra, qual cliente tem mais chance de ganhar e qual a localização desse cliente, antecipando o valor do frete em um envio de produtos?
```SQL
SELECT tdc.NOME, COUNT(nf.NUMERO) Quantidade_notas 
FROM notas_fiscais nf INNER JOIN tabela_de_clientes tdc
USING (CPF)
GROUP BY nf.CPF
ORDER BY Quantidade_notas DESC
LIMIT 5;
```
<p align="left">
  <img alt="" width="65%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/ade94998-a02e-4a85-9a07-b40ba7b813a1">
</p>

Com 6384 notas fiscais emitidas, Petra Oliveira teria mais chances de ganhar, caso houvesse um sorteio.

<br>
<br>
<br>

## Resultados <a id="resultados"></a>
Projeto iniciado com uma base de dados em SQL.
- Fiz uma análise inicial para entender a base;
- Criado a relação visual entre as tabelas;
- Realizado consultas com as cláulas como SELECT, WHERE, GROUP BY, ORDER BY, LIMIT;
- Realizado consultas usando a expressão CASE, função COUNT, ALIASES e junções com JOIN.

Deixo abaixo algumas conclusões extraídas dos dados e caso tenha dúvida, sugestão ou alguma correção, deixo meu linkedin abaixo:
	
[Vamos no conectar!](https://www.linkedin.com/in/mateus-simoes-ramos/)

---
## Produtos

<p align="center">
  <img alt="" width="30%" src="https://github.com/MateusRamos10/Analise_Exploratoria_de_vendas_usando_SQL/assets/43836795/c2cdac56-849e-4f81-96cd-bfe82ccd4b82">
</p>

Há 31 produtos comercializados, com 50395 itens vendidos para o Rio e 37482 para São Paulo

---
## Clientes

<p align="center">
  <img alt="" width="30%" src="https://github.com/MateusRamos10/Analise_Exploratoria_de_vendas_usando_SQL/assets/43836795/b8d57a7f-edb5-46aa-8a90-5e6882f795b0">
</p>

Compradores apenas de São Paulo e do Rio de Janeiro, em uma hipótese de promover algum evento ou filial envolvendo logística, essa é uma informação importante.

6 clientes nunca compraram nenhum produto, cupons e promoções podem ser oferecidos para primeira compra.

Caso houvesse um sorteio, o cliente com mais bilhetes pela quantidade de ordens geradas é a Petra Oliveira com 6384 notas geradas, antecipar um frente para calcular um envio de prêmio no endereço dessa cliente.

87% dos nossos clientes pertencem a geração Y, uma informação como esta pode indicar um tipo de consumo ou um meio de comunição preferido. 

As gerações tem maneiras diferentes de consumo e pode ser algo importante na hora de definir uma campanha marketing.

---
## Funcionários

<p align="center">
  <img alt="" width="30%" src="https://github.com/MateusRamos10/Analise_Exploratoria_de_vendas_usando_SQL/assets/43836795/0b176311-9abf-452a-ba28-a1920e903d23">
</p>

Sabemos também que os vendedores mais eficientes e mais antigos da empresa (Márcio e Cláudia) tem a menor porcentagem de comissão, isso não corresponde a lógica.
Um deles não é vendedor pois não tem nenhum registro de vendas resultando em um erro no Dataset (Péricles).

<br>
<br
	
Esse trabalho foi desenvolvimento a fim de mostrar algumas de minhas habilidades em SQL e espero que tenha gostado! Deixo abaixo meu contato:

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mateus-simoes-ramos/)&nbsp;
[![Email](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:mateusramos.oficial@gmail.com)&nbsp;
[![Perfil DIO](https://img.shields.io/badge/-Meu%20Perfil%20na%20DIO-000?style=for-the-badge)](https://web.dio.me/users/mateusramos_oficial?tab=skills)
*mailto: mateusramos.oficial@gmail.com*
<!-- Meu site -->



