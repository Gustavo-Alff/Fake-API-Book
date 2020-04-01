*** Settings ***
Documentation    Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Resource         ResourcesAPI.robot
Suite Setup      Conectar a minha API

*** Test Case ***
Cenário 1: Buscar a listagem de todos os livros (GET em todos os livros)
        Quando requisito todos os livros
        E o Status code é     200
        Então será retornado todos os "200" livros
        

Cenário 2: Buscar um livro especifico (GET em livro especifico)
        Quando requisito o livro "15"
        E o Status code é     200
        #Alguns campos são aleatórios, por isso alguns campos são apenas para verificar que não estão vazios
        Então todos os dados do livro 15 retornaram corretamente

Cenário 3: Cadastrar um novo livro (POST)
        Quando cadastro um novo livro
        Então todos os dados do novo livro retornam corretamente "201"

Cenário 4: Alterar um livro (PUT)
    Quando altero os dados de Titles, Descriptons e Excerpt do livro "150"
    E o Status code é    200
    Então todos os dados alterados retornam corretamente "150"

Cenário 5: Deletar um livro (DELETE)
    Quando excluo o livro "200"
    E o Status code é    200
#   (o response body deve ser vazio)
    Então confiro se excluiu o livro "200" corretamente

Cenário 6: Verificar se não há problemas com o Servidor - Negativo
        Quando requisito todos os livros
        Então confirmo que o status code diferente de    500     
        E confirmo que o status code diferente de        501     
        E confirmo que o status code diferente de        502   
        E confirmo que o status code diferente de        503     
        E confirmo que o status code diferente de        504     
        E confirmo que o status code diferente de        505 

Cenário 1: conferir se tem mais livros
        Quando requisito todos os livros
        E o Status code é     200
        Então não deve conter a quantidade de "201" livros 
