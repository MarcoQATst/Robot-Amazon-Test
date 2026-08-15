*** Settings ***
Documentation    Recurso base do framework de automação.
...              Centraliza a inicialização do navegador (Browser/Playwright),
...              configurações globais, teardowns e inclusão de bibliotecas.

Library    Browser    timeout=15s    enable_presenter_mode=False
Library    OperatingSystem
Library    String

Resource   components/navbar.resource
Resource   pages/login_page.resource
Resource   pages/home_page.resource
Resource   pages/amazon_search_page.resource
Resource   pages/amazon_cart_page.resource

*** Variables ***
${BASE_URL}    https://www.saucedemo.com
${BROWSER}     chromium
${HEADLESS}    False
${TIMEOUT}     10s

*** Keywords ***
Iniciar Sessao
    [Documentation]    Inicializa o navegador com as configurações especificadas.
    [Arguments]    ${url}=${BASE_URL}    ${browser}=${BROWSER}    ${headless}=${HEADLESS}
    New Browser    browser=${browser}    headless=${headless}
    New Context    viewport={'width': 1366, 'height': 768}    userAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36
    New Page       url=${url}
    Set Browser Timeout    ${TIMEOUT}

Encerrar Sessao
    [Documentation]    Fecha o contexto e o navegador ao fim de cada teste.
    Take Screenshot    filename=EMBED    fullPage=True
    Close Browser

Obter Dados Do Usuario
    [Documentation]    Carrega a massa de teste a partir do arquivo JSON.
    [Arguments]    ${tipo_usuario}
    ${file_content}    Get File    ${CURDIR}/../data/users.json
    ${json_data}       Evaluate    json.loads('''${file_content}''')    modules=json
    RETURN    ${json_data["${tipo_usuario}"]}

Obter Dados De Produtos
    [Documentation]    Carrega a massa de dados de produtos do arquivo JSON.
    [Arguments]    ${produto_key}
    ${file_content}    Get File    ${CURDIR}/../data/products.json
    ${json_data}       Evaluate    json.loads('''${file_content}''')    modules=json
    RETURN    ${json_data["${produto_key}"]}
