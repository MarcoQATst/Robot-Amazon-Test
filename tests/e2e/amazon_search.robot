*** Settings ***
Documentation    Suíte de testes E2E para o portal Amazon cobrindo fluxos Positivos e Negativos.
...              - Cenário Positivo / Jornada Completa: Busca, refino por filtros e abertura de detalhes do produto.
...              - Cenários Negativos / Edge Cases: Busca sem resultados e busca com termo vazio.
Resource         ../../resources/base.resource

Test Setup       Iniciar Sessao    url=https://www.amazon.com
Test Teardown    Encerrar Sessao

*** Test Cases ***
Cenário Positivo: Jornada completa de busca, filtragem e visualização de produto
    [Documentation]    Valida o fluxo feliz (Happy Path) de ponta a ponta:
    ...                1. Pesquisa por "fone de ouvido"
    ...                2. Valida os resultados encontrados
    ...                3. Aplica o filtro "Wireless"
    ...                4. Acessa os detalhes do primeiro produto e valida as informações
    [Tags]    e2e    amazon    positivo    smoke    jornada_completa
    ${produto}    Obter Dados De Produtos    fone_de_ouvido
    Dado que o usuário está no portal da Amazon
    Quando realiza a pesquisa pelo produto "${produto}[termo_busca]"
    Então os resultados de busca para "${produto}[termo_busca]" devem ser exibidos
    Quando aplica o filtro de conectividade "${produto}[filtro_conectividade]"
    Então a lista de produtos filtrados deve ser atualizada
    Quando seleciona o primeiro produto da lista
    Então a página de detalhes do produto deve ser exibida com sucesso

Cenário Negativo: Busca por termo inexistente ou caracteres inválidos
    [Documentation]    Garante que ao buscar por um termo sem correspondência, o sistema trata a pesquisa sem quebras.
    [Tags]    e2e    amazon    negativo    busca_invalida
    ${produto}    Obter Dados De Produtos    termo_inexistente
    Dado que o usuário está no portal da Amazon
    Quando realiza a pesquisa pelo produto "${produto}[termo_busca]"
    Então o sistema deve processar a busca sem quebras para o termo "${produto}[termo_busca]"

Cenário Negativo: Submissão de busca sem preenchimento de termo
    [Documentation]    Valida o comportamento da aplicação ao submeter uma pesquisa em branco.
    [Tags]    e2e    amazon    negativo    busca_vazia
    ${produto}    Obter Dados De Produtos    busca_vazia
    Dado que o usuário está no portal da Amazon
    Quando realiza a pesquisa pelo produto "${produto}[termo_busca]"
    Então o sistema deve manter a integridade da página inicial sem erros

*** Keywords ***
Dado que o usuário está no portal da Amazon
    Acessar O Portal Da Amazon

Quando realiza a pesquisa pelo produto "${termo}"
    Pesquisar Por Produto    ${termo}

Quando aplica o filtro de conectividade "${filtro}"
    Aplicar Filtro De Conectividade    ${filtro}

Quando seleciona o primeiro produto da lista
    Acessar Detalhes Do Primeiro Produto

Então os resultados de busca para "${termo}" devem ser exibidos
    Validar Resultados Da Pesquisa Exibidos    ${termo}

Então a lista de produtos filtrados deve ser atualizada
    Validar Resultados Da Pesquisa Exibidos    fone de ouvido

Então a página de detalhes do produto deve ser exibida com sucesso
    Validar Pagina De Detalhes Do Produto

Então o sistema deve processar a busca sem quebras para o termo "${termo}"
    Validar Mensagem De Nenhum Resultado Encontrado    ${termo}

Então o sistema deve manter a integridade da página inicial sem erros
    Validar Que Permanece Na Pagina Inicial Ou Mantem Integridade
