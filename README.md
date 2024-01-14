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

**Para acessar o arquivo no Colab, clique no link abaixo:**
 - [Projeto no Colab](https://colab.research.google.com/drive/17lsOdQxSAA1CTmmYqIMOUsk_MFFr6r8Q?usp=sharing)

## Fonte dos Dados
Os dados foram obtidos de uma formação, portanto está indisponível para download.

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

### 1. Quantos produtos são comercializados e qual o mais vendido?
```SQL
SELECT DISTINCT CODIGO_DO_PRODUTO, NOME_DO_PRODUTO FROM tabela_de_produtos 
	ORDER BY CODIGO_DO_PRODUTO DESC;
```
<p align="left">
  <img alt="Dashboard" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/a87baa66-80c2-4d9f-882d-d27ade924631">
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
  <img alt="Dashboard" width="95%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/6c5468a8-6500-47dd-b599-43bb7c153f4d">
</p>

Temos o resultado de 31 produtos sendo comercializados.
E também o top 5 produtos mais vendidos.

### 2. Qual o cliente mais fiel?
```SQL
SELECT NOME, VOLUME_DE_COMPRA FROM tabela_de_clientes 
	ORDER BY VOLUME_DE_COMPRA desc LIMIT 5;
```
<p align="left">
  <img alt="Dashboard" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/7399d564-9e87-4076-b296-f793153274ea">
</p>

```SQL
SELECT NOME, ENDERECO_1, CIDADE, BAIRRO, ESTADO, CEP 
	FROM tabela_de_clientes 
	WHERE CPF = 50534475787;
```
<p align="left">
  <img alt="Dashboard" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/0cb3b642-5141-4a43-86cc-7cabb5e47792">
</p>
Nesses 4 anos Abel Silva é o o cliente que mais comprou com um volume de $ 26.000.

Em um cenário onde aconteça um sorteio, Abel teria mais bilhetes e probabilidade maior de ganhar, com seu endereço é possível ter uma previsão de um frete se precisar enviar algum prêmio para esse cliente.

### 3. Em um cenário onde todos os vendedores tem o mesmo salário-base e eles recebem um percentual de vendas. Qual o vendedor com maior percentual de comissão?
```SQL
SELECT NOME, PERCENTUAL_COMISSAO FROM tabela_de_vendedores 
	ORDER BY PERCENTUAL_COMISSAO DESC;
```
<p align="left">
  <img alt="Dashboard" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/212b8fc9-b838-4c7d-97ae-787907c99228">
</p>

```SQL
SELECT v.NOME, COUNT(nf.MATRICULA) as Quantidade_Vendida FROM notas_fiscais nf
	INNER JOIN tabela_de_vendedores v
    	ON nf.MATRICULA = v.matricula
	GROUP BY v.NOME
	ORDER BY Quantidade_Vendida DESC;
```

<p align="left">
  <img alt="Dashboard" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/2904c45f-ece2-4b80-9a1b-48b9f7081e4b">
</p>
Roberta e Péricles são os vendedores que mais ganham comissão.
Porém quando verificamos o volume de vendas de cada vendedor, vemos que Péricles não tem nenhuma venda, então Roberta é a vendedora com mais comissão.
Também é possível avaliar que dos outros dois vendedores, ela é a que menos vendeu.
Cabe uma avaliação da Roberta e também avaliar uma promoção para o Márcio e a Cláudia.

### 4. Quantos clientes ainda não compraram no nosso site?
```SQL
SELECT 
    COUNT(*) AS NUNCA_COMPRARAM
FROM tabela_de_clientes
WHERE PRIMEIRA_COMPRA = 0
GROUP BY PRIMEIRA_COMPRA;
```
<p align="left">
  <img alt="" width="80%" src="https://github.com/MateusRamos10/SQL_Marketing/assets/43836795/4780299f-342e-44ef-876f-4a770e52e052">
</p>

Na tabela de cliente há uma coluna que expressa se um cliente cadastro já fez uma compra ou não, ao fazer essa agregação temos o resultado de quantos cliente estão inativos no site de compras.

### 5. Qual o estado que mais comprou?



### 6. Qual o melhor vendedor?



### 7. Quais os níveis de senioridade dos vendedores de acordo com o tempo na empresa? 
**Senior > 3 anos 
Pleno > 2 e < 3 anos
Junior 0 a 2 anos
Sendo que nossa base tem registros de 2014 a 2017**



### 8. Qual a venda que teve o maior faturamento?



### 9. Qual a venda que teve a maior quantidade?



### 10. Qual geração compra mais, X,Y ou Z? Quero lançar um novo sabor, qual meu publico alvo?



### 11. Quero fazer um evento, em que região posso promover esse evento?



### 12. Em um sorteio que cada cliente ganha 1 bilhete por compra, qual cliente tem mais chance de ganhar e qual a localização desse cliente, antecipando o valor do frete em um envio de produtos?




































## Resultados



