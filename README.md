# 📦 Monitor de Validades

Sistema de monitoramento e análise de validades de materiais em estoque, integrando dados do SAP através de um dashboard interativo desenvolvido em Python com Streamlit.

## 📋 Descrição do Projeto

O Monitor de Validades é uma aplicação web que permite visualizar e analisar dados de validade de materiais em estoque, identificando:
- Materiais com desvio percentual crítico
- Materiais com prazo de validade crítico
- Tendências e padrões de vencimento
- Análises por depósito, fornecedor e categoria

### Funcionalidades Principais

- 📊 **Dashboard Interativo**: Visualizações em tempo real com gráficos e métricas
- 🔍 **Filtros Dinâmicos**: Filtragem por depósito, fornecedor, material e período
- 📈 **Análises Avançadas**: Desvios percentuais, linha do tempo, distribuições
- 📥 **Exportação de Dados**: Download de relatórios em Excel
- 🎨 **Interface Intuitiva**: Design responsivo e fácil de usar

## 🚀 Deploy no Streamlit Cloud

### Pré-requisitos

- Conta no [GitHub](https://github.com)
- Conta no [Streamlit Cloud](https://share.streamlit.io) (gratuita)
- Git instalado localmente
- Python 3.8 ou superior

### Passo a Passo do Deploy

#### 1. Preparar o Repositório Local

```bash
# Inicializar Git (se ainda não foi feito)
git init

# Adicionar todos os arquivos
git add .

# Criar commit inicial
git commit -m "Preparar aplicação para deploy no Streamlit Cloud"
```

#### 2. Criar Repositório no GitHub

1. Acesse [github.com](https://github.com) e faça login
2. Clique em "New repository"
3. Escolha um nome para o repositório (ex: `monitor-validades`)
4. Escolha visibilidade (público ou privado)
5. **NÃO** inicialize com README (já existe localmente)
6. Clique em "Create repository"

#### 3. Conectar e Enviar Código

```bash
# Adicionar remote do GitHub (substitua com sua URL)
git remote add origin https://github.com/seu-usuario/monitor-validades.git

# Renomear branch para main (se necessário)
git branch -M main

# Enviar código para GitHub
git push -u origin main
```

#### 4. Deploy no Streamlit Cloud

1. Acesse [share.streamlit.io](https://share.streamlit.io)
2. Faça login com sua conta GitHub
3. Clique em "New app"
4. Preencha as informações:
   - **Repository**: `seu-usuario/monitor-validades`
   - **Branch**: `main`
   - **Main file path**: `Monitor.py`
5. Clique em "Deploy!"

#### 5. Aguardar Conclusão do Deploy

O Streamlit Cloud irá:
- Clonar o repositório
- Instalar dependências do `requirements.txt`
- Iniciar a aplicação
- Fornecer uma URL pública

**Tempo estimado**: 2-5 minutos

#### 6. Acessar a Aplicação

Após o deploy, você receberá uma URL no formato:
```
https://seu-usuario-monitor-validades-monitor-xxxxx.streamlit.app
```

Acesse esta URL para visualizar o dashboard!

## 🔄 Atualização de Dados

### Processo Manual (Recomendado)

1. **Executar extração SAP localmente** (Windows):
   ```bash
   python Atualizar.py
   ```

2. **Verificar arquivos atualizados**:
   ```bash
   dir data\*.xlsx
   ```

3. **Adicionar ao Git**:
   ```bash
   git add data/*.xlsx
   ```

4. **Criar commit**:
   ```bash
   git commit -m "Atualizar dados SAP - DD/MM/AAAA"
   ```

5. **Enviar para GitHub**:
   ```bash
   git push origin main
   ```

6. **Aguardar redeploy automático** (30-60 segundos)

### Script Automatizado (Windows)

Um script `atualizar_e_deploy.bat` está incluído no projeto para automatizar todo o processo de atualização.

#### Funcionalidades do Script

O script realiza automaticamente:
- ✅ Validação de pré-requisitos (Python, Git)
- ✅ Verificação de repositório Git
- ✅ Execução do script de extração SAP
- ✅ Validação de arquivos de dados
- ✅ Detecção de mudanças nos arquivos
- ✅ Commit automático com timestamp
- ✅ Push para GitHub
- ✅ Tratamento de erros em cada etapa

#### Como Usar

**Opção 1: Duplo clique**
1. Localize o arquivo `atualizar_e_deploy.bat` no explorador de arquivos
2. Dê um duplo clique para executar

**Opção 2: Linha de comando**
```bash
atualizar_e_deploy.bat
```

#### O que o Script Faz

```
[1/5] Executando extração SAP...
      └─ Executa Atualizar.py para extrair dados do SAP

[2/5] Verificando arquivos atualizados...
      └─ Valida existência dos arquivos Excel necessários
      └─ Detecta se houve mudanças nos dados

[3/5] Adicionando arquivos ao Git...
      └─ Adiciona arquivos Excel modificados ao staging

[4/5] Criando commit...
      └─ Cria commit com timestamp automático

[5/5] Enviando para GitHub...
      └─ Faz push para o repositório remoto
      └─ Inicia redeploy automático no Streamlit Cloud
```

#### Validações Incluídas

O script verifica automaticamente:
- ✅ Python está instalado
- ✅ Git está instalado
- ✅ Diretório é um repositório Git válido
- ✅ Arquivo `Atualizar.py` existe
- ✅ Pasta `data/` existe
- ✅ Arquivos Excel foram gerados corretamente
- ✅ Há mudanças para commitar
- ✅ Push para GitHub foi bem-sucedido

#### Tratamento de Erros

Se algo der errado, o script:
- 🛑 Para a execução imediatamente
- 📝 Exibe mensagem de erro clara
- 💡 Sugere soluções para o problema
- ⏸️ Aguarda confirmação antes de fechar

#### Exemplo de Uso

```bash
C:\projetos\monitor-validades> atualizar_e_deploy.bat

========================================
 Atualizacao de Dados - Monitor Validades
========================================

[1/5] Executando extracao SAP...
Conectando ao SAP...
Extraindo dados...
Dados salvos com sucesso!

[2/5] Verificando arquivos atualizados...
Arquivos de dados foram modificados.

[3/5] Adicionando arquivos ao Git...

[4/5] Criando commit...
[main abc1234] Atualizar dados SAP - 09/12/2024 14:30

[5/5] Enviando para GitHub...
Enumerating objects: 5, done.
Writing objects: 100% (5/5), done.

========================================
 >> Deploy iniciado no Streamlit Cloud!
========================================

O Streamlit Cloud detectara as mudancas e
iniciara o redeploy automaticamente.

Tempo estimado: 30-60 segundos

========================================
 Processo concluido com sucesso!
========================================
```

## 💻 Instalação Local

### Requisitos

- Python 3.8+
- pip (gerenciador de pacotes Python)

### Instalação

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/monitor-validades.git
   cd monitor-validades
   ```

2. **Crie um ambiente virtual** (recomendado):
   ```bash
   python -m venv venv
   
   # Windows
   venv\Scripts\activate
   
   # Linux/Mac
   source venv/bin/activate
   ```

3. **Instale as dependências**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Execute a aplicação**:
   ```bash
   streamlit run Monitor.py
   ```

5. **Acesse no navegador**:
   ```
   http://localhost:8501
   ```

## 📁 Estrutura do Projeto

```
monitor-validades/
├── .streamlit/
│   └── config.toml          # Configurações do Streamlit
├── data/
│   ├── Mb51_SAP.xlsx        # Movimentações de material (SAP)
│   ├── Sq00_Validade.xlsx   # Dados de validade
│   ├── Vencimentos_SAP.xlsx # Tempos de validade por fornecedor
│   └── README.md            # Documentação dos dados
├── Monitor.py               # Aplicação principal (dashboard)
├── Atualizar.py             # Script de extração SAP (Windows only)
├── requirements.txt         # Dependências Python
├── .gitignore              # Arquivos ignorados pelo Git
└── README.md               # Este arquivo
```

## 🔧 Troubleshooting

### Problema: Aplicação não inicia no Streamlit Cloud

**Sintomas**: Erro ao carregar aplicação

**Soluções**:
1. Verifique os logs no painel do Streamlit Cloud
2. Confirme que `requirements.txt` está correto
3. Verifique se `Monitor.py` não tem erros de sintaxe
4. Confirme que arquivos `data/*.xlsx` existem no repositório

### Problema: Arquivos de dados não encontrados

**Sintomas**: `FileNotFoundError` ao carregar Excel

**Soluções**:
1. Verifique que arquivos estão na pasta `data/`
2. Confirme que arquivos foram commitados no Git:
   ```bash
   git status
   git add data/*.xlsx
   git commit -m "Adicionar arquivos de dados"
   git push
   ```
3. Verifique nomes dos arquivos (case-sensitive no Linux)

### Problema: Dependências não instaladas

**Sintomas**: `ModuleNotFoundError`

**Soluções**:
1. Adicione a biblioteca faltante ao `requirements.txt`
2. Commit e push do arquivo atualizado:
   ```bash
   git add requirements.txt
   git commit -m "Atualizar dependências"
   git push
   ```
3. Aguarde redeploy automático

### Problema: Aplicação lenta

**Sintomas**: Dashboard demora para carregar

**Soluções**:
1. Otimize tamanho dos arquivos Excel (remova dados antigos)
2. Verifique se cache está habilitado nas funções
3. Considere upgrade de plano no Streamlit Cloud para mais recursos

## ⚠️ Limitações do Deploy Cloud

### 1. Atualização SAP Automática
- **Não funciona**: `Atualizar.py` requer Windows e acesso direto ao SAP
- **Solução**: Executar localmente e fazer push manual dos arquivos Excel

### 2. Tamanho de Arquivos
- **Limite**: ~100MB por arquivo no GitHub
- **Solução**: Otimizar arquivos Excel, remover dados históricos desnecessários

### 3. Performance
- **Plano gratuito**: Recursos limitados (1 GB RAM, 1 CPU)
- **Solução**: Otimizar código, usar cache, considerar upgrade se necessário

### 4. Acesso Privado
- **Plano gratuito**: Aplicação é pública (qualquer um com URL pode acessar)
- **Solução**: Upgrade para plano pago com autenticação integrada

## 🔒 Segurança

### Dados Sensíveis

**NÃO commitar**:
- Credenciais SAP
- Senhas
- Tokens de API
- Dados pessoais identificáveis

O arquivo `.gitignore` já está configurado para excluir:
- Arquivos `.env`
- `secrets.toml`
- Arquivos com padrão `*_credentials.json`
- Arquivos com padrão `*password*`

### Streamlit Secrets

Para configurações sensíveis necessárias no cloud:
1. Acesse Streamlit Cloud > App settings > Secrets
2. Adicione secrets no formato TOML:
   ```toml
   [database]
   username = "seu_usuario"
   password = "sua_senha"
   ```
3. Acesse no código:
   ```python
   import streamlit as st
   username = st.secrets["database"]["username"]
   ```

## 📊 Dados

### Arquivos de Entrada

1. **Mb51_SAP.xlsx**: Movimentações de material
   - Material, Descrição, Data de entrada, Quantidade, Depósito

2. **Sq00_Validade.xlsx**: Dados de validade
   - Material, Lote, Data de fabricação, Data de validade, Quantidade

3. **Vencimentos_SAP.xlsx**: Tempos de validade
   - Material, Fornecedor, Tempo de Validade

### Formato dos Dados

Os arquivos Excel devem seguir a estrutura padrão do SAP. Consulte `data/README.md` para detalhes sobre as colunas esperadas.

## 🛠️ Tecnologias Utilizadas

- **Python 3.8+**: Linguagem de programação
- **Streamlit**: Framework para aplicações web
- **Pandas**: Manipulação e análise de dados
- **Plotly**: Visualizações interativas
- **NumPy**: Computação numérica
- **OpenPyXL**: Leitura de arquivos Excel

## 📝 Licença

Este projeto é de uso interno da organização.

## 👥 Suporte

Para dúvidas ou problemas:
1. Verifique a seção de Troubleshooting acima
2. Consulte os logs no Streamlit Cloud
3. Entre em contato com a equipe de TI

## ⚡ Otimizações de Performance

### Versão 3.1 (09/12/2024)

#### Melhorias Implementadas:

1. **Cache Otimizado** 🚀
   - Reduzido TTL de 15-30min para 5min
   - Libera memória 60% mais rápido
   - Melhor para plano gratuito (1 GB RAM)
   - Spinners informativos durante carregamento

2. **Indicadores de Progresso** 📊
   - Barra de progresso visual
   - Feedback de cada etapa de carregamento
   - Melhor experiência do usuário
   - Reduz percepção de lentidão

3. **Tratamento de Erros** 🛡️
   - Mensagens mais claras
   - Dicas de solução incluídas
   - Melhor troubleshooting

#### Resultados Esperados:

- ⚡ **Carregamento**: ~50-66% mais rápido (5-10s vs 15-30s)
- 💾 **Memória**: ~40-50% menos uso (400-600 MB vs 800 MB-1 GB)
- 🎯 **Filtros**: ~60% mais responsivos (1-2s vs 3-5s)
- ✅ **Estabilidade**: Menos travamentos e timeouts

#### Documentação:

- 📖 **RESUMO_OTIMIZACOES.md** - Detalhes técnicos completos
- 🔧 **TROUBLESHOOTING_PERFORMANCE.md** - Guia de resolução de problemas
- 🚀 **GUIA_RAPIDO_DEPLOY.md** - Deploy em 5 minutos
- 📋 **OTIMIZACAO.md** - Plano de otimização completo

### Tamanho dos Arquivos

**Status Atual (09/12/2024):**
- Mb51_SAP.xlsx: 1,63 MB ✅
- Sq00_Validade.xlsx: 1,25 MB ✅
- Validade Fornecedores.xlsx: 0,30 MB ✅
- Vencimentos_SAP.xlsx: 1,49 MB ✅
- **Total: ~4,67 MB** ✅ (Ideal para deploy)

## 🔄 Changelog

### Versão 3.1 (09/12/2024)
- ⚡ Otimizações de performance (cache, memória, UX)
- 📊 Indicadores de progresso visual
- 🛡️ Melhor tratamento de erros
- 📖 Documentação expandida

### Versão 3.0
- Deploy no Streamlit Cloud
- Remoção de dependências Windows
- Otimizações de performance
- Documentação completa de deploy

### Versão 2.0
- Interface aprimorada com gradientes
- Novos KPIs e métricas
- Filtros dinâmicos avançados

### Versão 1.0
- Versão inicial do dashboard
- Integração com SAP
- Visualizações básicas
