<<<<<<< HEAD
# 🤖 Robot Framework + Playwright (Browser Library) E2E Automation

[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.0%2B-blue.svg?logo=robot-framework)](https://robotframework.org/)
[![Playwright Browser](https://img.shields.io/badge/Library-Browser%20(Playwright)-2ea44f.svg?logo=playwright)](https://robotframework-browser.org/)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB.svg?logo=python)](https://www.python.org/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF.svg?logo=github-actions)](https://github.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> Projeto modelo de automação de testes End-to-End (E2E) estruturado segundo os mais rigorosos padrões de engenharia de qualidade de software (QA), com arquitetura em camadas (**Page Object Model**), escrita em **BDD/Gherkin**, **Data-Driven Testing**, relatórios detalhados com screenshots automáticos e integração contínua (**CI/CD**).

---

## 🏛️ Arquitetura do Projeto

O projeto adota o padrão **Page Object Model (POM)** combinado com **Keyword-Driven Testing** e **Data-Driven Testing**, garantindo alta manutenibilidade, separação de responsabilidades e reuso de componentes:

```
robot-automation/
├── .github/
│   └── workflows/
│       └── robot-tests.yml        # Pipeline CI/CD no GitHub Actions (execução e upload de artefatos)
├── config/
│   ├── env.dev.yaml               # Configurações do ambiente de desenvolvimento
│   └── env.stage.yaml             # Configurações do ambiente de homologação/staging
├── data/
│   ├── users.json                 # Massa de dados de usuários e credenciais (Fixtures / Data-Driven)
│   └── products.json              # Massa de dados de busca de produtos e filtros
├── resources/
│   ├── base.resource              # Inicialização do navegador, hooks globais e teardowns
│   ├── components/
│   │   └── navbar.resource        # Componentes compartilhados da UI (Header, Menus, Modais)
│   └── pages/
│       ├── login_page.resource         # Localizadores e keywords da tela de Login (Page Object)
│       ├── home_page.resource          # Localizadores e keywords da tela inicial (Page Object)
│       ├── amazon_search_page.resource # Page Object de busca, filtros e produtos na Amazon
│       └── amazon_cart_page.resource   # Page Object de carrinho e checkout na Amazon
├── tests/
│   ├── smoke/
│   │   └── health_check.robot          # Testes de fumaça rápidos para validação de sanidade
│   └── e2e/
│       ├── login.robot                 # Suítes de autenticação (BDD: Positivo/Negativo/Logout)
│       ├── amazon_search.robot         # Suíte E2E da Amazon (Jornada completa, busca vazia e sem resultados)
│       └── amazon_checkout.robot       # Suíte E2E da Amazon (Adição ao carrinho e checkout deslogado)
├── results/                       # Diretório centralizado para relatórios, logs e screenshots
│   └── .gitkeep
├── scripts/
│   └── run_tests.ps1              # Script auxiliar para execução flexível no PowerShell
├── .gitignore                     # Controle de exclusão de artefatos e arquivos temporários
├── requirements.txt               # Dependências Python do projeto
└── README.md                      # Documentação completa do projeto
```

---

## 🛠️ Tecnologias e Bibliotecas

- **[Robot Framework](https://robotframework.org/)**: Framework genérico de automação orientado a palavras-chave (Keywords) e BDD.
- **[Browser Library (Playwright)](https://robotframework-browser.org/)**: Biblioteca moderna de automação web baseada em Playwright (rápida, estável e com auto-waiting).
- **[Pabot](https://pabot.org/)**: Execução de testes em paralelo para redução de tempo de execução.
- **[GitHub Actions](https://github.com/features/actions)**: Pipeline de integração contínua para validação em builds automatizados.

---

## 🚀 Pré-requisitos

1. **Python 3.10 ou superior**: [Download Python](https://www.python.org/downloads/)
2. **Node.js 18 ou superior** (necessário para os binários do Playwright): [Download Node.js](https://nodejs.org/)
3. **Git**: [Download Git](https://git-scm.com/)

---

## 📦 Instalação e Configuração

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/robot-automation.git
   cd robot-automation
   ```

2. **Crie e ative um ambiente virtual Python:**
   ```bash
   # Windows (PowerShell)
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1

   # Linux / macOS
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Instale as dependências:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Inicialize a biblioteca Browser (instalação dos navegadores do Playwright):**
   ```bash
   rfbrowser init
   ```

---

## 🧪 Como Executar os Testes

### 1. Usando o Script Auxiliar (PowerShell no Windows)

```powershell
# Executar todos os testes com interface gráfica
.\scripts\run_tests.ps1

# Executar apenas Smoke Tests
.\scripts\run_tests.ps1 -Tag smoke

# Executar testes de regressão em modo headless (sem abrir a janela)
.\scripts\run_tests.ps1 -Tag regression -Headless True
```

### 2. Comandos Diretos do Robot Framework

```bash
# Executar todos os testes salvando relatórios na pasta results/
robot -d results tests/

# Executar apenas testes com a tag @smoke
robot -d results -i smoke tests/

# Executar apenas testes de regressão
robot -d results -i regression tests/

# Executar em modo Headless (ideal para servidores / CI)
robot -d results -v HEADLESS:True tests/

# Executar suítes em paralelo utilizando Pabot (multiprocessamento)
pabot --processes 2 -d results tests/
```

---

## 📊 Relatórios e Evidências

Após a execução, todos os relatórios e evidências ficam centralizados no diretório `results/`:

- **`report.html`**: Visão executiva e estatísticas gerais dos testes.
- **`log.html`**: Detalhamento passo a passo de cada Keyword executada, parâmetros e mensagens.
- **`output.xml`**: Dados brutos para integração com ferramentas de CI/CD (ex: Allure, SonarQube).
- **Screenshots**: Em caso de falha (ou por configuração), os prints da tela são capturados e embutidos diretamente no `log.html`.

Para abrir o relatório no navegador:
```powershell
# Windows
start results\report.html
```

---

## 🔄 Integração Contínua (CI/CD)

O repositório possui uma pipeline configurada via **GitHub Actions** (`.github/workflows/robot-tests.yml`) que:
1. É disparada automaticamente a cada `push` ou `pull request` nas branches principais (`main`, `master`, `develop`).
2. Executa a suíte de testes em ambiente Linux em modo headless.
3. Disponibiliza o download dos relatórios (`log.html`, `report.html`) como artefatos da build por até 14 dias.

---

## 💡 Boas Práticas Adotadas

- ✅ **Page Object Model (POM)**: Isolamento de seletores e fluxos de cada página em arquivos `.resource` dedicados.
- ✅ **Testes com BDD / Gherkin**: Cenários legíveis tanto para desenvolvedores quanto para analistas de negócio e POs.
- ✅ **Massa de Testes Externa (Data-Driven)**: Separação de dados de entrada e validações em arquivo JSON (`data/users.json`).
- ✅ **Resiliência e Auto-Wait**: Aproveitamento do mecanismo nativo de espera inteligente do Playwright/Browser Library, eliminando `Sleeps` arbitrários.
- ✅ **Evidências Automáticas**: Screenshots embutidos no log para facilitar a análise de causa raiz de falhas.

---

## 👨‍💻 Autor

Desenvolvido por Marco Aurelio Gomes — QA / Test Automation Engineer.

- LinkedIn: [Marco Aurelio Gomes](https://www.linkedin.com/in/marcoaurelioqa)
- GitHub: @seu-usuario (substitua pelo seu usuário)

Um projeto pensado para demonstrar padrões profissionais de automação com Robot Framework e Playwright. Contribuições, issues e sugestões são bem-vindas.

