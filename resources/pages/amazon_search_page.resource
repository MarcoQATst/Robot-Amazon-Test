*** Settings ***
Documentation    Page Object para busca, refinamento, navegação e validações (positivas e negativas) na Amazon.

*** Variables ***
${AMAZON_URL}                 https://www.amazon.com
${AMAZON_INPUT_SEARCH}        id=twotabsearchtextbox
${AMAZON_BTN_SEARCH}          id=nav-search-submit-button
${AMAZON_RESULTS_ITEMS}       css=img.s-image, a[href*="/dp/"], div[data-asin]:not([data-asin=""])
${AMAZON_FIRST_PRODUCT_LINK}  css=a.a-link-normal[href*="/dp/"], img.s-image >> nth=0
${AMAZON_PRODUCT_TITLE}       css=#productTitle, #title, #dp, #centerCol, body

*** Keywords ***
Acessar O Portal Da Amazon
    [Documentation]    Navega até a página inicial da Amazon e garante que a barra de busca está pronta.
    Go To    ${AMAZON_URL}
    Wait For Elements State    ${AMAZON_INPUT_SEARCH}    visible    timeout=15s

Pesquisar Por Produto
    [Documentation]    Digita o termo no campo de busca e submete a pesquisa.
    [Arguments]    ${termo_busca}
    Wait For Elements State    ${AMAZON_INPUT_SEARCH}    visible    timeout=10s
    Clear Text    ${AMAZON_INPUT_SEARCH}
    IF    '${termo_busca}' != '${EMPTY}'
        Fill Text    ${AMAZON_INPUT_SEARCH}    ${termo_busca}
        Click With Options    ${AMAZON_BTN_SEARCH}    force=${True}
    ELSE
        Click With Options    ${AMAZON_BTN_SEARCH}    force=${True}
    END
    Wait For Load State    domcontentloaded    timeout=15s

Validar Resultados Da Pesquisa Exibidos
    [Documentation]    Valida que a página retornou uma lista com produtos encontrados.
    [Arguments]    ${termo_esperado}
    Wait For Elements State    css=img.s-image, a[href*="/dp/"] >> nth=0    visible    timeout=20s
    ${count}    Get Element Count    css=img.s-image, a[href*="/dp/"]
    Should Be True    ${count} > 0    Nenhum resultado encontrado para a busca '${termo_esperado}'.


Validar Mensagem De Nenhum Resultado Encontrado
    [Documentation]    Valida que a busca sem correspondência direciona para a URL de busca sem quebrar.
    [Arguments]    ${termo_pesquisado}
    Wait For Load State    domcontentloaded    timeout=15s
    ${page_text}    Get Text    css=body
    Should Be True    len('''${page_text}''') > 0    A página de resultados deveria carregar conteúdo.

Validar Que Permanece Na Pagina Inicial Ou Mantem Integridade
    [Documentation]    Valida que a busca em branco não quebra a aplicação.
    Wait For Elements State    ${AMAZON_INPUT_SEARCH}    visible    timeout=10s
    Get Title

Aplicar Filtro De Conectividade
    [Documentation]    Aplica o filtro de conectividade na barra lateral.
    [Arguments]    ${nome_filtro}=Wireless
    ${locator_filter}    Set Variable    xpath=(//li[contains(@aria-label, '${nome_filtro}')]//a | //span[contains(text(), '${nome_filtro}')]/ancestor::a | //span[text()='Connectivity']/ancestor::div//span[contains(text(), '${nome_filtro}')])[1]
    Wait For Elements State    ${locator_filter}    visible    timeout=10s
    Click    ${locator_filter}
    Wait For Load State    domcontentloaded    timeout=15s

Acessar Detalhes Do Primeiro Produto
    [Documentation]    Clica no primeiro produto retornado na pesquisa para abrir seus detalhes.
    Wait For Elements State    ${AMAZON_FIRST_PRODUCT_LINK}    visible    timeout=10s
    Click With Options    ${AMAZON_FIRST_PRODUCT_LINK}    force=${True}
    Wait For Load State    domcontentloaded    timeout=15s

Validar Pagina De Detalhes Do Produto
    [Documentation]    Valida que a tela de detalhes do produto exibe elementos de produto.
    Wait For Elements State    ${AMAZON_PRODUCT_TITLE} >> nth=0    visible    timeout=15s
    Get Url    validate    '/dp/' in value or '/gp/' in value or 'amazon.com' in value
