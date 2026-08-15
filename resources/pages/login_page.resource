*** Settings ***
Documentation    Page Object com elementos e ações da página de Login.

*** Variables ***
${LOGIN_INPUT_USER}     id=user-name
${LOGIN_INPUT_PASS}     id=password
${LOGIN_BTN_SUBMIT}     id=login-button
${LOGIN_MSG_ERROR}      css=[data-test="error"]

*** Keywords ***
Acessar A Pagina De Login
    [Documentation]    Garante que os elementos de login estão visíveis na página.
    Wait For Elements State    ${LOGIN_INPUT_USER}    visible    timeout=10s
    Wait For Elements State    ${LOGIN_BTN_SUBMIT}    visible    timeout=10s

Preencher Credenciais
    [Documentation]    Preenche o usuário e a senha nos campos correspondentes.
    [Arguments]    ${username}    ${password}
    IF    '${username}' != '${EMPTY}'
        Fill Text    ${LOGIN_INPUT_USER}    ${username}
    END
    IF    '${password}' != '${EMPTY}'
        Fill Secret    ${LOGIN_INPUT_PASS}    $password
    END

Submeter Formulario De Login
    [Documentation]    Clica no botão para realizar o login.
    Click    ${LOGIN_BTN_SUBMIT}

Realizar Login
    [Documentation]    Keyword de alto nível para fluxo completo de autenticação.
    [Arguments]    ${username}    ${password}
    Acessar A Pagina De Login
    Preencher Credenciais    ${username}    ${password}
    Submeter Formulario De Login

Validar Mensagem De Erro
    [Documentation]    Valida que a mensagem de erro esperada é exibida na tela.
    [Arguments]    ${mensagem_esperada}
    Wait For Elements State    ${LOGIN_MSG_ERROR}    visible    timeout=5s
    Get Text    ${LOGIN_MSG_ERROR}    ==    ${mensagem_esperada}
