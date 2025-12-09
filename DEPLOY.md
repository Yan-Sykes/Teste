# 🚀 Guia Detalhado de Deploy - Monitor de Validades

Este documento fornece instruções detalhadas para realizar o deploy da aplicação Monitor de Validades no Streamlit Cloud.

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Pré-requisitos](#pré-requisitos)
3. [Preparação do Ambiente](#preparação-do-ambiente)
4. [Deploy Passo a Passo](#deploy-passo-a-passo)
5. [Processo de Atualização de Dados](#processo-de-atualização-de-dados)
6. [Verificação e Testes](#verificação-e-testes)
7. [Troubleshooting Detalhado](#troubleshooting-detalhado)
8. [Manutenção e Monitoramento](#manutenção-e-monitoramento)

## 🎯 Visão Geral

### Arquitetura de Deploy

```
┌─────────────────────────────────────────┐
│      Ambiente Windows Local (Privado)   │
├─────────────────────────────────────────┤
│  ┌──────────────┐    ┌──────────────┐  │
│  │ Atualizar.py │───▶│  SAP System  │  │
│  │ (win32com)   │    │              │  │
│  └──────────────┘    └──────────────┘  │
│         │                               │
│         ▼                               │
│  ┌──────────────────────────────────┐  │
│  │   Arquivos Excel (data/)         │  │
│  └──────────────────────────────────┘  │
│         │                               │
│         │ (Manual: Git commit + push)  │
└─────────┼───────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────┐
│         GitHub Repository               │
├─────────────────────────────────────────┤
│  - Monitor.py                           │
│  - requirements.txt                     │
│  - data/*.xlsx                          │
│  - .streamlit/config.toml               │
└─────────┬───────────────────────────────┘
          │
          │ (Auto-deploy on push)
          ▼
┌─────────────────────────────────────────┐
│       Streamlit Cloud (Linux)           │
├─────────────────────────────────────────┤
│  ┌──────────────────────────────────┐  │
│  │   Arquivos Excel (data/)         │  │
│  │   (Read-only, from Git)          │  │
│  └──────────────────────────────────┘  │
│         │                               │
│         ▼                               │
│  ┌──────────────┐                      │
│  │  Monitor.py  │                      │
│  │ (Streamlit)  │◀────── Usuários      │
│  │              │        (Browser)     │
│  └──────────────┘                      │
└─────────────────────────────────────────┘
```

### Separação de Responsabilidades

**Ambiente Local (Windows)**:
- Execução do script `Atualizar.py`
- Integração com SAP via win32com
- Exportação de dados para Excel
- Commit e push para GitHub

**Streamlit Cloud (Linux)**:
- Hospedagem da aplicação web
- Leitura de dados Excel do repositório
- Visualização e análise de dados
- Acesso público via navegador

## 🔧 Pré-requisitos

### Contas Necessárias

1. **Conta GitHub**
   - Acesse: https://github.com/signup
   - Gratuita
   - Necessária para hospedar o código

2. **Conta Streamlit Cloud**
   - Acesse: https://share.streamlit.io
   - Gratuita
   - Faça login com sua conta GitHub

### Software Necessário

1. **Git**
   - Windows: https://git-scm.com/download/win
   - Verificar instalação: `git --version`

2. **Python 3.8 ou superior**
   - Windows: https://www.python.org/downloads/
   - Verificar instalação: `python --version`

3. **Editor de Texto** (opcional)
   - VS Code, Notepad++, ou similar

### Conhecimentos Recomendados

- Comandos básicos de Git
- Navegação em terminal/prompt de comando
- Conceitos básicos de Python (opcional)

## 🛠️ Preparação do Ambiente

### Etapa 1: Verificar Estrutura do Projeto

Certifique-se de que seu projeto tem a seguinte estrutura:

```
monitor-validades/
├── .streamlit/
│   └── config.toml
├── data/
│   ├── Mb51_SAP.xlsx
│   ├── Sq00_Validade.xlsx
│   └── Vencimentos_SAP.xlsx
├── Monitor.py
├── requirements.txt
├── .gitignore
└── README.md
```

### Etapa 2: Verificar requirements.txt

Abra o arquivo `requirements.txt` e confirme que contém apenas dependências compatíveis com Linux:

```txt
streamlit>=1.28.0
pandas>=2.0.0
numpy>=1.24.0
plotly>=5.17.0
openpyxl>=3.1.0
```

**IMPORTANTE**: Remova qualquer referência a:
- `pywin32`
- `win32com`
- `pythoncom`
- `psutil` (se não for usado em Monitor.py)

### Etapa 3: Verificar .gitignore

Certifique-se de que o arquivo `.gitignore` existe e contém:

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
ENV/

# Streamlit
.streamlit/secrets.toml

# Dados sensíveis
*.env
.env.local
*_credentials.json
*_secrets.yaml
*password*

# IDEs
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

### Etapa 4: Verificar Arquivos de Dados

Confirme que os arquivos Excel estão na pasta `data/`:

```bash
dir data\*.xlsx
```

Verifique o tamanho dos arquivos (limite GitHub: 100MB por arquivo):

```bash
dir data\*.xlsx /s
```

## 🚀 Deploy Passo a Passo

### Fase 1: Inicializar Repositório Git Local

#### Passo 1.1: Abrir Terminal no Diretório do Projeto

```bash
# Navegue até a pasta do projeto
cd C:\caminho\para\monitor-validades
```

#### Passo 1.2: Inicializar Git (se ainda não foi feito)

```bash
# Inicializar repositório Git
git init

# Verificar status
git status
```

**Saída esperada**: Lista de arquivos não rastreados

#### Passo 1.3: Adicionar Arquivos ao Git

```bash
# Adicionar todos os arquivos
git add .

# Verificar o que será commitado
git status
```

**Saída esperada**: Arquivos em verde, prontos para commit

#### Passo 1.4: Criar Commit Inicial

```bash
# Criar commit com mensagem descritiva
git commit -m "Preparar aplicação para deploy no Streamlit Cloud"
```

**Saída esperada**: Mensagem confirmando commit com número de arquivos

### Fase 2: Criar Repositório no GitHub

#### Passo 2.1: Acessar GitHub

1. Abra o navegador e acesse: https://github.com
2. Faça login com sua conta
3. Clique no botão **"+"** no canto superior direito
4. Selecione **"New repository"**

#### Passo 2.2: Configurar Repositório

Preencha os campos:

- **Repository name**: `monitor-validades` (ou nome de sua escolha)
- **Description**: "Sistema de monitoramento de validades de materiais SAP"
- **Visibility**: 
  - **Public**: Qualquer pessoa pode ver (recomendado para Streamlit Cloud gratuito)
  - **Private**: Apenas você e colaboradores (requer configuração adicional)
- **Initialize repository**: 
  - ❌ **NÃO** marque "Add a README file"
  - ❌ **NÃO** marque "Add .gitignore"
  - ❌ **NÃO** marque "Choose a license"

#### Passo 2.3: Criar Repositório

Clique em **"Create repository"**

**Resultado**: Página com instruções de setup

### Fase 3: Conectar Repositório Local ao GitHub

#### Passo 3.1: Copiar URL do Repositório

Na página do GitHub, copie a URL que aparece (formato HTTPS):

```
https://github.com/seu-usuario/monitor-validades.git
```

#### Passo 3.2: Adicionar Remote

No terminal, execute:

```bash
# Adicionar remote (substitua com sua URL)
git remote add origin https://github.com/seu-usuario/monitor-validades.git

# Verificar remote
git remote -v
```

**Saída esperada**:
```
origin  https://github.com/seu-usuario/monitor-validades.git (fetch)
origin  https://github.com/seu-usuario/monitor-validades.git (push)
```

#### Passo 3.3: Renomear Branch para Main

```bash
# Renomear branch atual para main
git branch -M main
```

#### Passo 3.4: Fazer Push para GitHub

```bash
# Enviar código para GitHub
git push -u origin main
```

**Primeira vez**: Pode solicitar autenticação GitHub
- **Username**: Seu nome de usuário GitHub
- **Password**: Token de acesso pessoal (não a senha da conta)

**Como criar token de acesso**:
1. GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Generate new token
3. Selecione escopo: `repo`
4. Copie o token (não será mostrado novamente!)

**Saída esperada**: Mensagem de sucesso com estatísticas de upload

#### Passo 3.5: Verificar Upload

1. Atualize a página do repositório no GitHub
2. Confirme que todos os arquivos estão visíveis
3. Verifique especialmente a pasta `data/` com os arquivos Excel

### Fase 4: Deploy no Streamlit Cloud

#### Passo 4.1: Acessar Streamlit Cloud

1. Abra o navegador e acesse: https://share.streamlit.io
2. Clique em **"Sign in"**
3. Selecione **"Continue with GitHub"**
4. Autorize o Streamlit Cloud a acessar sua conta GitHub

#### Passo 4.2: Criar Nova Aplicação

1. No painel do Streamlit Cloud, clique em **"New app"**
2. Você verá um formulário com três campos principais

#### Passo 4.3: Configurar Aplicação

Preencha os campos:

**Repository**:
- Selecione: `seu-usuario/monitor-validades`
- Se não aparecer, clique em "Paste GitHub URL" e cole a URL completa

**Branch**:
- Selecione: `main`

**Main file path**:
- Digite: `Monitor.py`
- **IMPORTANTE**: Case-sensitive! Use exatamente como está no repositório

**App URL** (opcional):
- Deixe o padrão ou personalize
- Formato: `seu-usuario-monitor-validades-monitor`

#### Passo 4.4: Configurações Avançadas (Opcional)

Clique em **"Advanced settings"** para:

**Python version**:
- Selecione: `3.9` ou `3.10` (recomendado)

**Secrets** (se necessário):
- Adicione variáveis de ambiente sensíveis
- Formato TOML

#### Passo 4.5: Iniciar Deploy

1. Revise todas as configurações
2. Clique em **"Deploy!"**
3. Aguarde o processo de deploy

#### Passo 4.6: Acompanhar Deploy

Você verá um log em tempo real mostrando:

```
Cloning repository...
Installing dependencies from requirements.txt...
Starting application...
```

**Tempo estimado**: 2-5 minutos

**Possíveis status**:
- 🟡 **Building**: Instalando dependências
- 🟢 **Running**: Aplicação ativa
- 🔴 **Error**: Erro no deploy (veja logs)

### Fase 5: Verificar Deploy

#### Passo 5.1: Acessar URL da Aplicação

Após deploy bem-sucedido, você receberá uma URL:

```
https://seu-usuario-monitor-validades-monitor-xxxxx.streamlit.app
```

Clique na URL ou copie e cole no navegador

#### Passo 5.2: Verificar Funcionalidades

Teste os seguintes aspectos:

✅ **Carregamento de Dados**:
- Dashboard carrega sem erros
- Métricas são exibidas corretamente

✅ **Visualizações**:
- Gráficos são renderizados
- Cores e formatação estão corretas

✅ **Filtros**:
- Filtros de depósito funcionam
- Filtros de fornecedor funcionam
- Filtros de data funcionam

✅ **Interatividade**:
- Gráficos respondem a cliques
- Tabelas são navegáveis
- Exportação funciona (se implementada)

#### Passo 5.3: Compartilhar URL

A URL é pública (no plano gratuito). Compartilhe com:
- Equipe
- Stakeholders
- Usuários finais

**Dica**: Adicione a URL ao README.md do repositório

## 🔄 Processo de Atualização de Dados

### Visão Geral

O processo de atualização envolve:
1. Executar extração SAP localmente (Windows)
2. Commitar arquivos Excel atualizados
3. Push para GitHub
4. Redeploy automático no Streamlit Cloud

### Método 1: Atualização Manual (Passo a Passo)

#### Etapa 1: Executar Extração SAP

```bash
# No ambiente Windows com acesso SAP
python Atualizar.py
```

**Aguarde**: Script pode levar alguns minutos dependendo do volume de dados

**Verificar**: Mensagens de sucesso no console

#### Etapa 2: Verificar Arquivos Atualizados

```bash
# Listar arquivos com data de modificação
dir data\*.xlsx

# Verificar tamanho dos arquivos
dir data\*.xlsx /s
```

**Confirmar**: Data de modificação é recente

#### Etapa 3: Verificar Mudanças no Git

```bash
# Ver status do repositório
git status

# Ver diferenças (se arquivos são texto)
git diff data/
```

**Saída esperada**: Arquivos Excel listados como modificados

#### Etapa 4: Adicionar Arquivos ao Git

```bash
# Adicionar apenas arquivos de dados
git add data/*.xlsx

# Ou adicionar todos os arquivos modificados
git add .

# Verificar o que será commitado
git status
```

#### Etapa 5: Criar Commit Descritivo

```bash
# Commit com data e descrição
git commit -m "Atualizar dados SAP - 09/12/2024"

# Ou com mais detalhes
git commit -m "Atualizar dados SAP - 09/12/2024

- Mb51_SAP.xlsx: Movimentações até 09/12
- Sq00_Validade.xlsx: Validades atualizadas
- Vencimentos_SAP.xlsx: Novos fornecedores"
```

#### Etapa 6: Enviar para GitHub

```bash
# Push para branch main
git push origin main
```

**Saída esperada**: Mensagem de sucesso

#### Etapa 7: Aguardar Redeploy Automático

1. Acesse o painel do Streamlit Cloud
2. Você verá status "Redeploying..."
3. Aguarde 30-60 segundos

**Ou**: Acesse a URL da aplicação e aguarde atualização

#### Etapa 8: Verificar Dados Atualizados

1. Acesse a URL da aplicação
2. Verifique datas nos dados
3. Confirme que métricas refletem novos dados
4. Teste filtros com dados recentes

### Método 2: Script Automatizado (Windows)

#### Criar Script de Atualização

Crie um arquivo `atualizar_dados.bat` na raiz do projeto:

```batch
@echo off
echo ========================================
echo  Atualizacao de Dados - Monitor Validades
echo ========================================
echo.

echo [1/5] Verificando ambiente...
where python >nul 2>nul
if errorlevel 1 (
    echo ERRO: Python nao encontrado
    pause
    exit /b 1
)

where git >nul 2>nul
if errorlevel 1 (
    echo ERRO: Git nao encontrado
    pause
    exit /b 1
)

echo [2/5] Executando extracao SAP...
python Atualizar.py
if errorlevel 1 (
    echo ERRO: Falha na extracao SAP
    pause
    exit /b 1
)

echo.
echo [3/5] Adicionando arquivos ao Git...
git add data/*.xlsx
if errorlevel 1 (
    echo ERRO: Falha ao adicionar arquivos
    pause
    exit /b 1
)

echo.
echo [4/5] Criando commit...
git commit -m "Atualizar dados SAP - %date% %time%"
if errorlevel 1 (
    echo AVISO: Nenhuma mudanca detectada ou erro no commit
)

echo.
echo [5/5] Enviando para GitHub...
git push origin main
if errorlevel 1 (
    echo ERRO: Falha ao enviar para GitHub
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Sucesso!
echo  Deploy iniciado no Streamlit Cloud
echo  Aguarde 30-60 segundos para conclusao
echo ========================================
pause
```

#### Usar Script

1. **Duplo clique** no arquivo `atualizar_dados.bat`
2. **Ou via terminal**:
   ```bash
   atualizar_dados.bat
   ```

#### Vantagens do Script

- ✅ Automatiza todo o processo
- ✅ Verifica pré-requisitos
- ✅ Trata erros automaticamente
- ✅ Fornece feedback claro
- ✅ Economiza tempo

### Método 3: Agendamento Automático (Avançado)

#### Usar Agendador de Tarefas do Windows

1. **Abrir Agendador de Tarefas**:
   - Pressione `Win + R`
   - Digite: `taskschd.msc`
   - Enter

2. **Criar Nova Tarefa**:
   - Ação > Criar Tarefa Básica
   - Nome: "Atualizar Monitor Validades"
   - Descrição: "Atualização diária de dados SAP"

3. **Configurar Gatilho**:
   - Diariamente
   - Horário: 08:00 (ou após extração SAP)
   - Recorrência: Todos os dias

4. **Configurar Ação**:
   - Iniciar um programa
   - Programa: `C:\caminho\para\atualizar_dados.bat`
   - Iniciar em: `C:\caminho\para\monitor-validades`

5. **Finalizar e Testar**:
   - Revisar configurações
   - Executar tarefa manualmente para testar

**Nota**: Requer que o computador esteja ligado no horário agendado

## ✅ Verificação e Testes

### Checklist de Verificação Pós-Deploy

#### Infraestrutura

- [ ] Repositório GitHub criado e acessível
- [ ] Código enviado para GitHub (todos os arquivos)
- [ ] Aplicação deployada no Streamlit Cloud
- [ ] URL pública funcionando
- [ ] Logs do Streamlit Cloud sem erros críticos

#### Funcionalidades

- [ ] Dashboard carrega em menos de 10 segundos
- [ ] Todas as métricas são exibidas
- [ ] Gráficos são renderizados corretamente
- [ ] Filtros funcionam sem erros
- [ ] Dados são exibidos corretamente
- [ ] Não há mensagens de erro visíveis

#### Dados

- [ ] Arquivos Excel estão no repositório
- [ ] Dados são carregados sem erros
- [ ] Datas estão corretas
- [ ] Quantidades fazem sentido
- [ ] Não há dados faltando

#### Performance

- [ ] Tempo de carregamento aceitável
- [ ] Filtros respondem rapidamente
- [ ] Gráficos são interativos
- [ ] Não há travamentos
- [ ] Memória não excede limites

#### Documentação

- [ ] README.md atualizado com URL
- [ ] Instruções de uso claras
- [ ] Troubleshooting documentado
- [ ] Processo de atualização explicado

### Testes de Funcionalidade

#### Teste 1: Carregamento de Dados

```python
# Verificar se dados são carregados
1. Acesse a URL da aplicação
2. Aguarde carregamento completo
3. Verifique se métricas aparecem
4. Confirme ausência de erros
```

**Resultado esperado**: Dashboard carrega com dados

#### Teste 2: Filtros

```python
# Testar cada filtro
1. Selecione um depósito específico
2. Verifique se dados são filtrados
3. Selecione um fornecedor
4. Verifique se filtro é aplicado
5. Ajuste intervalo de datas
6. Confirme que dados mudam
```

**Resultado esperado**: Filtros funcionam corretamente

#### Teste 3: Visualizações

```python
# Verificar gráficos
1. Verifique gráfico de barras
2. Verifique gráfico de linha
3. Verifique gráfico de pizza
4. Teste interatividade (hover, zoom)
5. Verifique legendas e rótulos
```

**Resultado esperado**: Todos os gráficos funcionam

#### Teste 4: Atualização de Dados

```python
# Testar processo de atualização
1. Modifique um arquivo Excel localmente
2. Execute processo de atualização
3. Aguarde redeploy
4. Verifique se mudanças aparecem
```

**Resultado esperado**: Dados são atualizados no dashboard

## 🔧 Troubleshooting Detalhado

### Problema 1: Erro ao Fazer Push para GitHub

#### Sintomas
```
error: failed to push some refs to 'https://github.com/...'
```

#### Causas Possíveis
1. Autenticação falhou
2. Branch desatualizada
3. Conflitos de merge

#### Soluções

**Solução 1.1: Configurar Autenticação**
```bash
# Configurar credenciais
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"

# Usar token de acesso pessoal
# GitHub > Settings > Developer settings > Personal access tokens
# Copie o token e use como senha
```

**Solução 1.2: Atualizar Branch Local**
```bash
# Baixar mudanças do GitHub
git pull origin main --rebase

# Resolver conflitos se houver
# Edite arquivos conflitantes
git add .
git rebase --continue

# Tentar push novamente
git push origin main
```

**Solução 1.3: Forçar Push (Cuidado!)**
```bash
# Apenas se tiver certeza
git push origin main --force
```

### Problema 2: Deploy Falha no Streamlit Cloud

#### Sintomas
- Status "Error" no painel
- Logs mostram erros de instalação
- Aplicação não inicia

#### Causas Possíveis
1. Dependências incompatíveis
2. Erro de sintaxe no código
3. Arquivos faltando
4. Versão Python incompatível

#### Soluções

**Solução 2.1: Verificar Logs**
```
1. Acesse painel Streamlit Cloud
2. Clique na aplicação
3. Veja "Manage app" > "Logs"
4. Identifique erro específico
```

**Solução 2.2: Corrigir requirements.txt**
```txt
# Remover dependências Windows
# REMOVER:
# pywin32
# win32com
# pythoncom

# Manter apenas:
streamlit>=1.28.0
pandas>=2.0.0
numpy>=1.24.0
plotly>=5.17.0
openpyxl>=3.1.0
```

**Solução 2.3: Verificar Sintaxe Python**
```bash
# Testar localmente primeiro
python Monitor.py

# Ou usar linter
python -m py_compile Monitor.py
```

**Solução 2.4: Redeployar**
```
1. Streamlit Cloud > Manage app
2. Clique em "Reboot app"
3. Ou delete e crie nova aplicação
```

### Problema 3: Arquivos de Dados Não Encontrados

#### Sintomas
```
FileNotFoundError: [Errno 2] No such file or directory: 'data/Mb51_SAP.xlsx'
```

#### Causas Possíveis
1. Arquivos não foram commitados
2. Nomes de arquivos incorretos
3. Caminhos incorretos no código
4. Case sensitivity (Linux vs Windows)

#### Soluções

**Solução 3.1: Verificar Arquivos no GitHub**
```
1. Acesse repositório no GitHub
2. Navegue até pasta data/
3. Confirme presença dos arquivos:
   - Mb51_SAP.xlsx
   - Sq00_Validade.xlsx
   - Vencimentos_SAP.xlsx
```

**Solução 3.2: Commitar Arquivos Faltando**
```bash
# Adicionar arquivos de dados
git add data/*.xlsx

# Verificar o que será commitado
git status

# Commitar
git commit -m "Adicionar arquivos de dados"

# Push
git push origin main
```

**Solução 3.3: Verificar Nomes (Case-Sensitive)**
```python
# Linux é case-sensitive!
# ERRADO: data/mb51_sap.xlsx
# CERTO:  data/Mb51_SAP.xlsx

# Verificar no código Monitor.py
CAM_MB51 = "data/Mb51_SAP.xlsx"  # Exatamente como no GitHub
```

**Solução 3.4: Verificar Caminhos Relativos**
```python
# ERRADO: Caminho absoluto
CAM_MB51 = "C:\\Users\\...\\data\\Mb51_SAP.xlsx"

# CERTO: Caminho relativo
CAM_MB51 = "data/Mb51_SAP.xlsx"
```

### Problema 4: Aplicação Muito Lenta

#### Sintomas
- Dashboard demora mais de 30 segundos para carregar
- Filtros travam
- Timeout errors

#### Causas Possíveis
1. Arquivos Excel muito grandes
2. Processamento ineficiente
3. Falta de cache
4. Limites do plano gratuito

#### Soluções

**Solução 4.1: Otimizar Arquivos Excel**
```python
# Reduzir tamanho dos arquivos
1. Remover dados históricos antigos
2. Remover colunas desnecessárias
3. Comprimir arquivos
4. Limitar a últimos 6-12 meses
```

**Solução 4.2: Adicionar Cache**
```python
import streamlit as st

@st.cache_data
def carregar_dados():
    df_mb51 = pd.read_excel("data/Mb51_SAP.xlsx")
    df_sq00 = pd.read_excel("data/Sq00_Validade.xlsx")
    df_forn = pd.read_excel("data/Vencimentos_SAP.xlsx")
    return df_mb51, df_sq00, df_forn
```

**Solução 4.3: Otimizar Processamento**
```python
# Usar tipos de dados eficientes
df['Material'] = df['Material'].astype('category')
df['Data'] = pd.to_datetime(df['Data'])

# Filtrar dados antes de processar
df = df[df['Data'] >= data_inicio]
```

**Solução 4.4: Considerar Upgrade**
```
Streamlit Cloud Plano Pago:
- Mais RAM (4GB vs 1GB)
- Mais CPU
- Melhor performance
- Autenticação incluída
```

### Problema 5: Erro de Dependências

#### Sintomas
```
ModuleNotFoundError: No module named 'plotly'
ImportError: cannot import name 'xxx'
```

#### Causas Possíveis
1. Biblioteca não está em requirements.txt
2. Versão incompatível
3. Dependência transitiva faltando

#### Soluções

**Solução 5.1: Adicionar Biblioteca Faltante**
```txt
# Editar requirements.txt
streamlit>=1.28.0
pandas>=2.0.0
numpy>=1.24.0
plotly>=5.17.0
openpyxl>=3.1.0
# Adicionar biblioteca faltante aqui
```

**Solução 5.2: Fixar Versões**
```txt
# Usar versões específicas
streamlit==1.28.0
pandas==2.0.3
numpy==1.24.3
plotly==5.17.0
openpyxl==3.1.2
```

**Solução 5.3: Gerar requirements.txt Localmente**
```bash
# Ativar ambiente virtual
venv\Scripts\activate

# Instalar dependências
pip install streamlit pandas numpy plotly openpyxl

# Gerar requirements.txt
pip freeze > requirements.txt

# Limpar dependências desnecessárias manualmente
```

### Problema 6: Dados Não Atualizam Após Push

#### Sintomas
- Push foi bem-sucedido
- Redeploy ocorreu
- Mas dados antigos ainda aparecem

#### Causas Possíveis
1. Cache do navegador
2. Cache do Streamlit
3. Arquivos não foram realmente atualizados

#### Soluções

**Solução 6.1: Limpar Cache do Navegador**
```
Chrome/Edge:
- Ctrl + Shift + Delete
- Selecionar "Cached images and files"
- Limpar

Ou:
- Ctrl + F5 (hard refresh)
```

**Solução 6.2: Limpar Cache do Streamlit**
```
1. Na aplicação, pressione 'C'
2. Ou clique no menu (⋮) > "Clear cache"
3. Ou adicione no código:
   st.cache_data.clear()
```

**Solução 6.3: Verificar Commit**
```bash
# Ver histórico de commits
git log --oneline

# Ver arquivos no último commit
git show --name-only

# Verificar conteúdo de arquivo específico
git show HEAD:data/Mb51_SAP.xlsx
```

**Solução 6.4: Forçar Redeploy**
```
Streamlit Cloud:
1. Manage app
2. Reboot app
3. Ou: Delete app e criar novamente
```

### Problema 7: Erro de Memória

#### Sintomas
```
MemoryError
Killed
App crashed
```

#### Causas Possíveis
1. Arquivos muito grandes
2. Processamento ineficiente
3. Limite de RAM do plano gratuito (1GB)

#### Soluções

**Solução 7.1: Reduzir Tamanho dos Dados**
```python
# Carregar apenas colunas necessárias
df = pd.read_excel(
    "data/Mb51_SAP.xlsx",
    usecols=['Material', 'Descrição', 'Quantidade', 'Data']
)

# Filtrar dados ao carregar
df = pd.read_excel("data/Mb51_SAP.xlsx")
df = df[df['Data'] >= '2024-01-01']
```

**Solução 7.2: Processar em Chunks**
```python
# Para arquivos muito grandes
chunks = []
for chunk in pd.read_excel("data/Mb51_SAP.xlsx", chunksize=1000):
    # Processar chunk
    chunks.append(chunk)
df = pd.concat(chunks)
```

**Solução 7.3: Otimizar Tipos de Dados**
```python
# Reduzir uso de memória
df['Material'] = df['Material'].astype('category')
df['Quantidade'] = df['Quantidade'].astype('int32')
```

## 🔍 Manutenção e Monitoramento

### Monitoramento Regular

#### Verificações Diárias

**Disponibilidade**:
- [ ] Aplicação está acessível
- [ ] Tempo de resposta aceitável
- [ ] Sem erros visíveis

**Dados**:
- [ ] Dados estão atualizados
- [ ] Datas fazem sentido
- [ ] Métricas são consistentes

#### Verificações Semanais

**Performance**:
- [ ] Tempo de carregamento
- [ ] Uso de recursos
- [ ] Logs de erro

**Funcionalidades**:
- [ ] Todos os filtros funcionam
- [ ] Gráficos são renderizados
- [ ] Exportações funcionam

#### Verificações Mensais

**Infraestrutura**:
- [ ] Dependências atualizadas
- [ ] Segurança do repositório
- [ ] Backup dos dados

**Documentação**:
- [ ] README atualizado
- [ ] Changelog mantido
- [ ] Troubleshooting relevante
