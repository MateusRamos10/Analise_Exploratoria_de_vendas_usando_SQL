[![author](https://img.shields.io/badge/author-mateusramos-red.svg)](https://www.linkedin.com/in/mateus-simoes-ramos/) ![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)
# Storytelling usando SQL em uma Análise Exploratória
<p align="center">
  <img alt="Dashboard" width="85%" src="https://github.com/MateusRamos10/Excel_Clients/assets/43836795/9b526b74-a74c-4644-a6e6-ff5d83740101">
</p>

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

### 2 Análise Exploratória
Após visualizar o cabeçalho de todas as tabelas, verificar as informações com mais atenção e conhecer como está estruturado a base de dados, já se pode usar a criatividade e aplicar as consultas para extrair as informações e análises direcionadas pelos dados e pelas **perguntas**. Para a organização desse etapa, separei as **perguntas e contextos** para serem respondidas pelos dados:

**1. Qual o melhor produto?**



**2. Qual o melhor cliente?**



**3. Em um cenário onde todos os vendedores tem o mesmo salário-base e eles recebem um percentual de acordo com as vendas. Qual o vendedor com maior percentual de comissão?**



**4. Quantos clientes ainda não compraram no nosso site?**



**5. Qual o melhor estado?**



**6. Qual o melhor vendedor?**



**7. Quais os níveis de senioridade dos vendedores de acordo com o tempo na empresa? 
	Senior > 3 anos
	Pleno > 2 e < 3 anos
	Junior 0 a 2 anos
Sendo que nossa base tem registros de 2014 a 2017**



**8. Qual a venda que teve o maior faturamento?**



**9. Qual a venda que teve a maior quantidade?**



**10. Qual geração compra mais, X,Y ou Z? Quero lançar um novo sabor, qual meu publico alvo?**



**11. Quero fazer um evento, em que região posso promover esse evento?**



**12. Em um sorteio que cada cliente ganha 1 bilhete por compra, qual cliente tem mais chance de ganhar e qual a localização desse cliente, antecipando o valor do frete em um envio de produtos?**




































## Resultados


