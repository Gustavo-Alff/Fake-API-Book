*** Settings ***
Documentation    Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Library          RequestsLibrary
Library          Collections

*** Variable ***
${URL_API}       https://fakerestapi.azurewebsites.net/api/
&{BOOK_15}       ID=15
 ...             Title=Book 15
 ...             PageCount=1500
&{BOOK_201}     ID=201
...             Title=Meu novo Book
...             Description=Meu novo livro conta coisas fantásticas
...             PageCount=523
...             Excerpt=Meu Novo livro é massa
...             PublishDate=2018-04-26T17:58:14.765Z
&{BOOK_150}     ID=150
...             Title=Book 150 alterado
...             Description=Descrição do book 150 alteada
...             PageCount=600
...             Excerpt=Resumo do book 150 alteado
...             PublishDate=2017-04-26T15:58:14.765Z

*** Keywords ***
####SETUP E TEARDOWNS
Conectar a minha API
  Create Session                 fakeAPI     ${URL_API}
  ${HEADERS}     Create Dictionary    content-type=application/json
  Set Suite Variable    ${HEADERS}
#### Ações
Quando requisito todos os livros
    ${RESPOSTA}                  Get Request     fakeAPI     Books
    log                          ${RESPOSTA.text}
    Set Test Variable            ${RESPOSTA}

Quando requisito o livro "${ID_LIVRO}"
    ${RESPOSTA}                  Get Request     fakeAPI     Books/${ID_LIVRO}
    log                          ${RESPOSTA.text}
    Set Test Variable            ${RESPOSTA}

Quando cadastro um novo livro
    ${RESPOSTA}                   Post Request   fakeAPI    Books
    ...                           data={"ID": ${BOOK_201.ID},"Title": "${BOOK_201.Title}","Description": "${BOOK_201.Description}","PageCount": ${BOOK_201.PageCount},"Excerpt": "${BOOK_201.Excerpt}","PublishDate": "${BOOK_201.PublishDate}"}
    ...                           headers=${HEADERS}
    Log                           ${RESPOSTA.text}
    Set Test Variable             ${RESPOSTA}
Quando altero os dados de Titles, Descriptons e Excerpt do livro "${ID_LIVRO}"
    ${RESPOSTA}                   Put Request    fakeAPI    Books/${ID_LIVRO}
    ...                           data={"ID": ${BOOK_150.ID},"Title": "${BOOK_150.Title}","Description": "${BOOK_150.Description}","PageCount": ${BOOK_150.PageCount},"Excerpt": "${BOOK_150.Excerpt}","PublishDate": "${BOOK_150.PublishDate}"}
    ...                           headers=${HEADERS}
    Log                           ${RESPOSTA.text}
    Set Test Variable             ${RESPOSTA}

Quando excluo o livro "${ID_LIVRO}"
    ${RESPOSTA}                   Delete Request    fakeAPI    Books/${ID_LIVRO}
    Log                           ${RESPOSTA.text}
    Set Test Variable             ${RESPOSTA}
# Conferencias
E o Status code é
  [Arguments]                    ${STATUSCODE_DESEJADO}
  Should Be Equal As Strings     ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

Então confirmo que o status code diferente de 
  [Arguments]                    ${STATUSCODE_DESEJADO}
  Should Not Be Equal As Strings     ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

E confirmo que o status code diferente de 
  [Arguments]                    ${STATUSCODE_DESEJADO}
  Should Not Be Equal As Strings     ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

Então será retornado todos os "${QTDE_LIVROS}" livros
  Length Should Be               ${RESPOSTA.json()}         ${QTDE_LIVROS}

Então não deve conter a quantidade de "${QTDE_LIVROS}" livros 
  Should Not Be Equal               ${RESPOSTA.json()}         ${QTDE_LIVROS}

Então todos os dados do livro 15 retornaram corretamente
  Dictionary Should Contain Item      ${RESPOSTA.json()}    ID    ${BOOK_15.ID}
  Dictionary Should Contain Item      ${RESPOSTA.json()}    Title    ${BOOK_15.Title}
  Dictionary Should Contain Item      ${RESPOSTA.json()}    PageCount    ${BOOK_15.PageCount}
  Should Not Be Empty                 ${RESPOSTA.json()["Description"]}
  Should Not Be Empty                 ${RESPOSTA.json()["Excerpt"]}
  Should Not Be Empty                 ${RESPOSTA.json()["PublishDate"]}

Então todos os dados do novo livro retornam corretamente "201"
  Dictionary Should Contain Item      ${RESPOSTA.json()}    ID    ${BOOK_201.ID}
  Dictionary Should Contain Item      ${RESPOSTA.json()}    Title    ${BOOK_201.Title}
  Dictionary Should Contain Item      ${RESPOSTA.json()}    PageCount    ${BOOK_201.PageCount}
  Should Not Be Empty                 ${RESPOSTA.json()["Description"]}
  Should Not Be Empty                 ${RESPOSTA.json()["Excerpt"]}
  Should Not Be Empty                 ${RESPOSTA.json()["PublishDate"]}

Então todos os dados alterados retornam corretamente "${ID_LIVRO}"
    Conferir livro    ${ID_LIVRO}

Então confiro se excluiu o livro "${ID_LIVRO}" corretamente
    Should Be Empty     ${RESPOSTA.content}
