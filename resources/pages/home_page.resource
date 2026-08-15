*** Settings ***
Documentation    Page Object com elementos e ações da página Home / Catálogo de Produtos.

*** Variables ***
${HOME_TITLE}             css=.title
${HOME_INVENTORY_ITEMS}   css=.inventory_item
${HOME_SORT_SELECT}       css=[data-test="product-sort-container"]
${HOME_BTN_ADD_BACKPACK}  id=add-to-cart-sauce-labs-backpack

*** Keywords ***
Validar Pagina De Produtos Carregada
    [Documentation]    Verifica se a página de inventário foi carregada corretamente.
    Get Url    contains    inventory.html
    Wait For Elements State    ${HOME_TITLE}    visible    timeout=10s
    Get Text    ${HOME_TITLE}    ==    Products

Validar Quantidade De Produtos Listados
    [Documentation]    Valida se a lista de produtos contém itens.
    [Arguments]    ${quantidade_minima}=1
    ${items}    Get Element Count    ${HOME_INVENTORY_ITEMS}
    Should Be True    ${items} >= ${quantidade_minima}    A lista de produtos deveria ter ao menos ${quantidade_minima} itens.

Adicionar Produto Mochila Ao Carrinho
    [Documentation]    Adiciona o item Sauce Labs Backpack ao carrinho de compras.
    Wait For Elements State    ${HOME_BTN_ADD_BACKPACK}    visible    timeout=5s
    Click    ${HOME_BTN_ADD_BACKPACK}
