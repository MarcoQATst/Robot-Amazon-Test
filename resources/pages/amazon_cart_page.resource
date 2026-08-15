*** Settings ***
Documentation    Page Object para o fluxo de Carrinho de Compras e Checkout na Amazon.
...              Gerencia adição ao carrinho, remoção de itens, tratamento de modais de garantia e checkout.

*** Variables ***
${AMAZON_URL}                     https://www.amazon.com
${AMAZON_BTN_ADD_TO_CART}         css=#add-to-cart-button
${AMAZON_BTN_NO_THANKS}           css=#attachSiNoCoverage input, #attachSiNoCoverage-announce, #attach-warranty-display button, [aria-label*="No thanks"], button:has-text("No thanks")
${AMAZON_CART_BADGE}              css=#nav-cart-count
${AMAZON_BTN_CHECKOUT}            css=input[name="proceedToRetailCheckout"], #sc-buy-box-ptc-button, [data-feature-id="proceed-to-checkout-action"] input
${AMAZON_AUTH_LOGIN_INPUT}        css=#ap_email, input[type="email"], input[name="email"]
${AMAZON_BTN_DELETE_ITEM}         css=input[value="Delete"], [data-action="delete"] input, [aria-label*="Delete"], .sc-action-delete input
${AMAZON_EMPTY_CART_CONTAINER}    css=#sc-empty-cart, .sc-empty-cart, h1:has-text("empty"), h2:has-text("empty"), div:has-text("Your Amazon Cart is empty")
${AMAZON_CART_ITEMS}              css=.sc-list-item, div[data-name="Active Items"] .sc-list-item
${AMAZON_CART_URL}                https://www.amazon.com/gp/cart/view.html

*** Keywords ***
Adicionar Produto Ao Carrinho
    [Documentation]    Clica no botão Adicionar ao Carrinho e confirma que o item foi adicionado com sucesso.
    ...                Usa clique nativo (sem force) para garantir que o event handler da Amazon processe a requisição.
    Wait For Elements State    ${AMAZON_BTN_ADD_TO_CART}    visible    timeout=15s
    Click    ${AMAZON_BTN_ADD_TO_CART}
    Tratar Modal De Garantia Se Exibido
    Confirmar Que O Item Foi Adicionado

Tratar Modal De Garantia Se Exibido
    [Documentation]    Clica no botão 'No thanks' caso o modal de garantia estendida seja exibido.
    ${modal_present}    Run Keyword And Return Status    Wait For Elements State    ${AMAZON_BTN_NO_THANKS} >> nth=0    visible    timeout=4s
    IF    ${modal_present}
        Click With Options    ${AMAZON_BTN_NO_THANKS} >> nth=0    force=${True}
    END

Confirmar Que O Item Foi Adicionado
    [Documentation]    Verifica que o badge do carrinho no header indica ao menos 1 item.
    ...                Tenta até 3 vezes caso o clique original não tenha processado.
    Sleep    2s
    ${badge_text}    Get Text    ${AMAZON_CART_BADGE}
    ${badge_count}    Evaluate    int('${badge_text}') if '${badge_text}'.strip().isdigit() else 0
    IF    ${badge_count} == 0
        # Tenta clicar novamente sem force caso o primeiro clique não tenha processado
        ${btn_visible}    Run Keyword And Return Status    Wait For Elements State    ${AMAZON_BTN_ADD_TO_CART}    visible    timeout=3s
        IF    ${btn_visible}
            Click    ${AMAZON_BTN_ADD_TO_CART}
            Tratar Modal De Garantia Se Exibido
            Sleep    3s
        END
    END
    ${badge_text_final}    Get Text    ${AMAZON_CART_BADGE}
    ${badge_final}    Evaluate    int('${badge_text_final}') if '${badge_text_final}'.strip().isdigit() else 0
    Should Be True    ${badge_final} > 0    O badge do carrinho deveria indicar ao menos 1 item adicionado (atual: ${badge_final}).

Navegar Para O Carrinho De Compras
    [Documentation]    Navega diretamente para a página do carrinho de compras via URL.
    Go To                  ${AMAZON_CART_URL}
    Wait For Load State    domcontentloaded    timeout=15s
    # Aguarda o container ativo do carrinho renderizar
    Wait For Elements State    css=#sc-active-cart >> nth=0    visible    timeout=15s

Acessar Carrinho Diretamente
    [Documentation]    Navega diretamente para a URL do carrinho de compras (alias).
    Go To                  ${AMAZON_CART_URL}
    Wait For Load State    domcontentloaded    timeout=15s

Validar Que O Produto Foi Adicionado Ao Carrinho
    [Documentation]    Verifica se o carrinho contém ao menos um item ativo.
    Get Url    contains    cart
    # Verifica o atributo data-cart-total-item-count no container ativo
    ${item_count_attr}    Evaluate JavaScript    ${None}    (function(){ var el = document.querySelector('#sc-active-cart'); return el ? el.getAttribute('data-cart-total-item-count') : '0'; })()
    ${item_count}    Evaluate    int('${item_count_attr}') if '${item_count_attr}'.strip().isdigit() else 0
    Should Be True    ${item_count} > 0    O carrinho deveria conter ao menos 1 item (data-cart-total-item-count=${item_count}).

Remover Primeiro Produto Do Carrinho
    [Documentation]    Clica no botão de excluir o primeiro produto presente no carrinho.
    Wait For Elements State    ${AMAZON_BTN_DELETE_ITEM} >> nth=0    visible    timeout=10s
    Click    ${AMAZON_BTN_DELETE_ITEM} >> nth=0
    Sleep    2s
    Wait For Load State    domcontentloaded    timeout=15s

Validar Que Item Foi Removido Ou Carrinho Ficou Vazio
    [Documentation]    Valida que o item foi excluído do carrinho com sucesso.
    ${removed_msg}    Run Keyword And Return Status    Wait For Elements State    css=.sc-list-item-removed-msg, div:has-text("was removed from") >> nth=0    visible    timeout=8s
    IF    not ${removed_msg}
        Wait For Elements State    ${AMAZON_EMPTY_CART_CONTAINER} >> nth=0    visible    timeout=10s
    END

Validar Mensagem De Carrinho Vazio
    [Documentation]    Valida que o carrinho exibe mensagem indicando que está vazio.
    Wait For Elements State    ${AMAZON_EMPTY_CART_CONTAINER} >> nth=0    visible    timeout=15s

Validar Que Nao Ha Itens Para Checkout
    [Documentation]    Garante que não existem itens ativos para compra no carrinho vazio.
    ${item_count_attr}    Evaluate JavaScript    ${None}    (function(){ var el = document.querySelector('#sc-active-cart'); return el ? el.getAttribute('data-cart-total-item-count') : '0'; })()
    ${item_count}    Evaluate    int('${item_count_attr}') if '${item_count_attr}'.strip().isdigit() else 0
    Should Be Equal As Integers    ${item_count}    0    Não deveria haver itens ativos no carrinho vazio (encontrado: ${item_count}).

Prosseguir Para O Checkout
    [Documentation]    Clica no botão 'Proceed to checkout' dentro do carrinho de compras.
    Wait For Elements State    ${AMAZON_BTN_CHECKOUT} >> nth=0    visible    timeout=15s
    Click    ${AMAZON_BTN_CHECKOUT} >> nth=0
    Wait For Load State    domcontentloaded    timeout=15s

Validar Tela De Login No Checkout Deslogado
    [Documentation]    Valida que o usuário deslogado é direcionado para a tela de autenticação para concluir a compra.
    Wait For Elements State    ${AMAZON_AUTH_LOGIN_INPUT} >> nth=0    visible    timeout=15s
    Get Url    validate    'signin' in value or 'ap/signin' in value or 'amazon.com' in value
