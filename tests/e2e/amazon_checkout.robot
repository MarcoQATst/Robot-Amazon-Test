*** Settings ***
Documentation    Suíte de testes E2E para o fluxo de Carrinho e Checkout no portal Amazon.
...              Cobre cenários Positivos (Adição, Checkout, Remoção) e Negativos (Carrinho Vazio e Impedimento de Checkout).
Resource         ../../resources/base.resource

Test Setup       Iniciar Sessao    url=https://www.amazon.com
Test Teardown    Encerrar Sessao

*** Test Cases ***
Cenário Positivo: Adicionar produto ao carrinho e prosseguir para checkout como usuário deslogado
    [Documentation]    Valida o fluxo completo de compra sem autenticação prévia:
    ...                1. Busca por 'placa de video' e acessa o produto
    ...                2. Adiciona o item ao carrinho e trata o modal de garantia
    ...                3. Navega até o carrinho e valida o produto adicionado
    ...                4. Prossegue para a finalização de compra (Checkout)
    ...                5. Valida que o usuário deslogado é direcionado para a tela de login
    [Tags]    e2e    amazon    carrinho    checkout    positivo    smoke
    ${produto}    Obter Dados De Produtos    placa_de_video
    Dado que o usuário pesquisou e acessou os detalhes do produto "${produto}[termo_busca]"
    Quando adiciona o produto ao carrinho de compras
    E navega até o carrinho de compras
    Então o produto deve estar presente no carrinho
    Quando clica em prosseguir para o checkout
    Então deve ser redirecionado para a tela de autenticação da Amazon

Cenário Positivo: Adicionar e remover produto do carrinho de compras
    [Documentation]    Garante que o usuário pode limpar o carrinho excluindo os itens adicionados.
    [Tags]    e2e    amazon    carrinho    remocao    positivo
    ${produto}    Obter Dados De Produtos    placa_de_video
    Dado que o usuário pesquisou e acessou os detalhes do produto "${produto}[termo_busca]"
    Quando adiciona o produto ao carrinho de compras
    E navega até o carrinho de compras
    Então o produto deve estar presente no carrinho
    Quando remove o produto do carrinho de compras
    Então o carrinho de compras deve ficar vazio

Cenário Negativo: Acessar carrinho de compras vazio e validar impedimento de checkout
    [Documentation]    Valida que ao acessar o carrinho sem itens, o botão de checkout não é habilitado.
    [Tags]    e2e    amazon    carrinho    carrinho_vazio    negativo
    Dado que o usuário acessa o carrinho de compras diretamente sem adicionar itens
    Então deve visualizar a mensagem informando que o carrinho está vazio
    E o botão de prosseguir para o checkout não deve estar disponível

*** Keywords ***
Dado que o usuário pesquisou e acessou os detalhes do produto "${termo}"
    Acessar O Portal Da Amazon
    Pesquisar Por Produto    ${termo}
    Validar Resultados Da Pesquisa Exibidos    ${termo}
    Acessar Detalhes Do Primeiro Produto
    Validar Pagina De Detalhes Do Produto

Dado que o usuário acessa o carrinho de compras diretamente sem adicionar itens
    Acessar Carrinho Diretamente

Quando adiciona o produto ao carrinho de compras
    Adicionar Produto Ao Carrinho

E navega até o carrinho de compras
    Navegar Para O Carrinho De Compras

Quando remove o produto do carrinho de compras
    Remover Primeiro Produto Do Carrinho

Então o produto deve estar presente no carrinho
    Validar Que O Produto Foi Adicionado Ao Carrinho

Então o carrinho de compras deve ficar vazio
    Validar Que Item Foi Removido Ou Carrinho Ficou Vazio

Quando clica em prosseguir para o checkout
    Prosseguir Para O Checkout

Então deve ser redirecionado para a tela de autenticação da Amazon
    Validar Tela De Login No Checkout Deslogado

Então deve visualizar a mensagem informando que o carrinho está vazio
    Validar Mensagem De Carrinho Vazio

E o botão de prosseguir para o checkout não deve estar disponível
    Validar Que Nao Ha Itens Para Checkout
