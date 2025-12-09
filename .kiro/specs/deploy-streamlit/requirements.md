# Documento de Requisitos - Deploy do Monitor de Validades

## Introdução

Este documento especifica os requisitos para realizar o deploy da aplicação Monitor de Validades, um sistema de monitoramento de validades de materiais em estoque que integra dados do SAP. A aplicação é desenvolvida em Python usando Streamlit e precisa ser disponibilizada para acesso via web.

## Glossário

- **Sistema**: Aplicação Monitor de Validades
- **Streamlit**: Framework Python para criação de aplicações web interativas
- **Streamlit Cloud**: Plataforma de hospedagem gratuita para aplicações Streamlit
- **SAP**: Sistema ERP de onde os dados são extraídos
- **Dashboard**: Interface web interativa para visualização de dados
- **Repositório Git**: Sistema de controle de versão onde o código está armazenado
- **Ambiente de Produção**: Ambiente onde a aplicação estará disponível para usuários finais

## Requisitos

### Requisito 1

**User Story:** Como desenvolvedor, eu quero preparar o repositório Git para deploy, para que o código esteja organizado e pronto para hospedagem.

#### Acceptance Criteria

1. WHEN o repositório é inicializado THEN o Sistema SHALL conter um arquivo .gitignore configurado para Python e Streamlit
2. WHEN arquivos sensíveis existem THEN o Sistema SHALL excluir credenciais, senhas e dados confidenciais do controle de versão
3. WHEN o repositório é verificado THEN o Sistema SHALL conter um arquivo README.md com instruções de uso e deploy
4. WHEN a estrutura de pastas é analisada THEN o Sistema SHALL manter a organização atual com pasta data/ para arquivos Excel

### Requisito 2

**User Story:** Como desenvolvedor, eu quero configurar o ambiente de deploy no Streamlit Cloud, para que a aplicação possa ser hospedada gratuitamente.

#### Acceptance Criteria

1. WHEN o deploy é configurado THEN o Sistema SHALL criar um arquivo requirements.txt com todas as dependências necessárias
2. WHEN dependências específicas do Windows são identificadas THEN o Sistema SHALL remover ou adaptar bibliotecas incompatíveis com Linux (pywin32, win32com)
3. WHEN o Streamlit Cloud lê a configuração THEN o Sistema SHALL especificar a versão correta do Python
4. WHEN a aplicação inicia THEN o Sistema SHALL carregar dados da pasta data/ sem erros de caminho

### Requisito 3

**User Story:** Como desenvolvedor, eu quero adaptar o código para funcionar em ambiente cloud, para que a aplicação execute corretamente sem dependências do Windows.

#### Acceptance Criteria

1. WHEN o código de atualização SAP é identificado THEN o Sistema SHALL separar o script Atualizar.py da aplicação principal
2. WHEN caminhos de arquivo são processados THEN o Sistema SHALL usar caminhos relativos compatíveis com Linux
3. WHEN a aplicação é executada THEN o Sistema SHALL funcionar apenas em modo leitura dos dados já exportados
4. WHEN imports são verificados THEN o Sistema SHALL remover dependências de win32com e pywin32 do código principal

### Requisito 4

**User Story:** Como desenvolvedor, eu quero criar documentação de deploy, para que outros possam entender e manter o processo.

#### Acceptance Criteria

1. WHEN a documentação é criada THEN o Sistema SHALL incluir um guia passo-a-passo de deploy no Streamlit Cloud
2. WHEN instruções de atualização são fornecidas THEN o Sistema SHALL explicar como atualizar os arquivos Excel de dados
3. WHEN limitações são documentadas THEN o Sistema SHALL listar funcionalidades que não funcionam em cloud (atualização automática SAP)
4. WHEN troubleshooting é necessário THEN o Sistema SHALL fornecer soluções para problemas comuns de deploy

### Requisito 5

**User Story:** Como usuário final, eu quero acessar o dashboard via navegador web, para que eu possa monitorar validades de qualquer lugar.

#### Acceptance Criteria

1. WHEN o deploy é concluído THEN o Sistema SHALL fornecer uma URL pública acessível
2. WHEN um usuário acessa a URL THEN o Sistema SHALL carregar o dashboard em menos de 10 segundos
3. WHEN o dashboard é exibido THEN o Sistema SHALL mostrar todas as visualizações e métricas corretamente
4. WHEN filtros são aplicados THEN o Sistema SHALL responder de forma interativa sem erros

### Requisito 6

**User Story:** Como administrador, eu quero um processo de atualização de dados, para que as informações no dashboard permaneçam atualizadas.

#### Acceptance Criteria

1. WHEN dados precisam ser atualizados THEN o Sistema SHALL fornecer instruções para upload de novos arquivos Excel
2. WHEN arquivos são atualizados no repositório THEN o Sistema SHALL fazer redeploy automático no Streamlit Cloud
3. WHEN o processo de atualização é executado THEN o Sistema SHALL manter o histórico de versões no Git
4. WHEN dados inválidos são carregados THEN o Sistema SHALL exibir mensagens de erro claras

### Requisito 7

**User Story:** Como desenvolvedor, eu quero configurar variáveis de ambiente, para que configurações sensíveis sejam gerenciadas de forma segura.

#### Acceptance Criteria

1. WHEN configurações são necessárias THEN o Sistema SHALL usar o arquivo .streamlit/config.toml para configurações do Streamlit
2. WHEN secrets são necessários THEN o Sistema SHALL usar o sistema de secrets do Streamlit Cloud
3. WHEN a aplicação inicia THEN o Sistema SHALL carregar configurações sem expor valores sensíveis nos logs
4. WHEN configurações são alteradas THEN o Sistema SHALL aplicar mudanças sem necessidade de modificar código
