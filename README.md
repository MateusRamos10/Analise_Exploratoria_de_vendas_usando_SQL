[![author](https://img.shields.io/badge/author-mateusramos-red.svg)](https://www.linkedin.com/in/mateus-simoes-ramos/) ![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)
# Storytelling usando SQL em uma Análise Exploratória
<p align="center">
  <img alt="Dashboard" width="85%" src="https://github.com/MateusRamos10/Excel_Clients/assets/43836795/9b526b74-a74c-4644-a6e6-ff5d83740101">
</p>

## Objetivo do Estudo
O objetivo deste projeto é realizar uma análise exploratória de uma base de dados que contém: **produtos, clientes, vendedores e nota fiscal** para determinar uma padronização das informações a fim de contextualizar os dados para melhorar o direcionamento do negócio. O contexto é uma loja que comercializa sucos e quer potencializar suas vendas usando dados.

**Para acessar o arquivo no Colab, clique no link abaixo:**
 - [Projeto no Colab](https://colab.research.google.com/drive/17lsOdQxSAA1CTmmYqIMOUsk_MFFr6r8Q?usp=sharing)

## Fonte dos Dados
Os dados foram obtidos de um curso, portanto está indisponível para download.

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
O foco nesse trabalho é fazer uma análise dos dados. Então partindo do pressuposto que os dados já foram gerados, limpos e carregados no SGBD escolhido, é necessário fazer uma primeira análise para entender os dados que estão contidos e quais informações esses dados podem fornecer. O MySQL Worchbench tem uma função que gera um esquema visual das tabelas (diagrama EER), que será um guia para as consultas. Abaixo estão os passos para gerar esse diagrama automaticamente:

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













