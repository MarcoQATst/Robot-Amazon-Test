*** Settings ***
Documentation    Ações e elementos do componente de Navegação / Header compartilhado.

*** Variables ***
${NAV_BURGER_MENU}    id=react-burger-menu-btn
${NAV_LOGOUT_LINK}    id=logout_sidebar_link
${NAV_CART_BADGE}     css=.shopping_cart_badge
${NAV_CART_LINK}      css=.shopping_cart_link

*** Keywords ***
Abrir Menu Lateral
    [Documentation]    Clica no botão de menu hamburguer.
    Click    ${NAV_BURGER_MENU}
    Wait For Elements State    ${NAV_LOGOUT_LINK}    visible    timeout=5s

Realizar Logout
    [Documentation]    Abre o menu e efetua o logout da aplicação.
    Abrir Menu Lateral
    Click    ${NAV_LOGOUT_LINK}
    Wait For Elements State    id=login-button    visible    timeout=5s

Validar Quantidade De Itens No Carrinho
    [Documentation]    Valida o número exibido no badge do carrinho de compras.
    [Arguments]    ${quantidade_esperada}
    Get Text    ${NAV_CART_BADGE}    ==    ${quantidade_esperada}
