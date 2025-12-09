# Documento de Design - Deploy do Monitor de Validades

## Overview

Este documento descreve o design da solução de deploy para a aplicação Monitor de Validades no Streamlit Cloud. A solução envolve adaptar uma aplicação Python/Streamlit que atualmente depende de integração Windows/SAP para funcionar em um ambiente cloud Linux, mantendo funcionalidade de visualização de dados enquanto separa a lógica de extração de dados SAP.

## Architecture

### Arquitetura Atual
```
┌─────────────────────────────────────────┐
│         Ambiente Windows Local          │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────┐    ┌──────────────┐  │
│  │ Atualizar.py │───▶│  SAP System  │  │
│  │ (win32com)   │    │              │  │
│  └──────────────┘    └──────────────┘  │
│         │                               │
│         ▼                               │
│  ┌──────────────────────────────────┐  │
│  │   Arquivos Excel (data/)         │  │
│  │   - Mb51_SAP.xlsx                │  │
│  │   - Sq00_Validade.xlsx           │  │
│  │   - Vencimentos_SAP.xlsx         │  │
│  └──────────────────────────────────┘  │
│         │                               │
│         ▼                               │
│  ┌──────────────┐                      │
│  │  Monitor.py  │                      │
│  │ (Streamlit)  │                      │
│  └──────────────┘                      │
└─────────────────────────────────────────┘
```

### Arquitetura Proposta (Cloud)
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
│  │ (Adaptado)   │        (Browser)     │
│  └──────────────┘                      │
└─────────────────────────────────────────┘
```

### Separação de Responsabilidades

1. **Ambiente Local (Windows)**
   - Execução do script Atualizar.py
   - Integração com SAP via win32com
   - Exportação de dados para Excel
   - Commit e push para GitHub

2. **Streamlit Cloud (Linux)**
   - Hospedagem da aplicação web
   - Leitura de dados Excel do repositório
   - Visualização e análise de dados
   - Acesso público via navegador

## Components and Interfaces

### 1. Preparação do Repositório Git

**Componente:** Git Repository Setup
**Responsabilidade:** Organizar código e configurar controle de versão

**Arquivos a criar/modificar:**
- `.gitignore` - Excluir arquivos temporários e sensíveis
- `README.md` - Documentação principal do projeto
- `.streamlit/config.toml` - Configurações do Streamlit

**Interface:**
```python
# Estrutura de diretórios
projeto/
├── .git/
├── .gitignore
├── .streamlit/
│   └── config.toml
├── data/
│   ├── Mb51_SAP.xlsx
│   ├── Sq00_Validade.xlsx
│   ├── Vencimentos_SAP.xlsx
│   └── README.md
├── Monitor.py
├── Atualizar.py  # Não será usado no cloud
├── requirements.txt
└── README.md
```

### 2. Adaptação do Código Principal

**Componente:** Monitor.py (Adaptado)
**Responsabilidade:** Dashboard Streamlit sem dependências Windows

**Modificações necessárias:**
- Remover imports de win32com/pywin32 (não usados em Monitor.py)
- Garantir caminhos relativos para arquivos
- Adicionar tratamento de erros para arquivos ausentes
- Manter toda lógica de visualização intacta

**Interface de Carregamento de Dados:**
```python
# Caminhos relativos (já implementado corretamente)
CAM_MB51 = "data/Mb51_SAP.xlsx"
CAM_SQ00 = "data/Sq00_Validade.xlsx"
CAM_FORN = "data/Validade Fornecedores.xlsx"

# Função de carregamento com tratamento de erros
def carregar_dados():
    try:
        df_mb51 = pd.read_excel(CAM_MB51)
        df_sq00 = pd.read_excel(CAM_SQ00)
        df_forn = pd.read_excel(CAM_FORN)
        return df_mb51, df_sq00, df_forn
    except FileNotFoundError as e:
        st.error(f"Arquivo não encontrado: {e}")
        st.stop()
    except Exception as e:
        st.error(f"Erro ao carregar dados: {e}")
        st.stop()
```

### 3. Gerenciamento de Dependências

**Componente:** requirements.txt
**Responsabilidade:** Especificar bibliotecas Python necessárias

**Dependências para Cloud:**
```txt
streamlit>=1.28.0
pandas>=2.0.0
numpy>=1.24.0
plotly>=5.17.0
openpyxl>=3.1.0
```

**Dependências removidas (Windows-only):**
- pywin32
- win32com
- psutil (usado apenas em Atualizar.py)

### 4. Configuração do Streamlit

**Componente:** .streamlit/config.toml
**Responsabilidade:** Configurações de aparência e comportamento

**Configuração sugerida:**
```toml
[theme]
primaryColor = "#1f77b4"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
textColor = "#262730"
font = "sans serif"

[server]
headless = true
port = 8501
enableCORS = false
enableXsrfProtection = true

[browser]
gatherUsageStats = false
```

### 5. Processo de Atualização de Dados

**Componente:** Data Update Workflow
**Responsabilidade:** Manter dados atualizados no cloud

**Fluxo de trabalho:**
```
1. Executar Atualizar.py localmente (Windows)
   ↓
2. Verificar arquivos atualizados em data/
   ↓
3. Git add data/*.xlsx
   ↓
4. Git commit -m "Atualizar dados SAP"
   ↓
5. Git push origin main
   ↓
6. Streamlit Cloud detecta push
   ↓
7. Redeploy automático (30-60 segundos)
   ↓
8. Dashboard atualizado com novos dados
```

**Script auxiliar (opcional):**
```bash
# atualizar_dados.bat (Windows)
@echo off
echo Atualizando dados no Git...
git add data/*.xlsx
git commit -m "Atualizar dados SAP - %date% %time%"
git push origin main
echo Deploy iniciado no Streamlit Cloud!
pause
```

## Data Models

### Modelo de Dados Excel

**Mb51_SAP.xlsx** - Movimentações de Material
```
Colunas principais:
- Material: Código do material
- Descrição: Nome do material
- Data de entrada: Data de entrada no estoque
- Quantidade: Quantidade movimentada
- Depósito: Local de armazenamento
- Tipo de movimento: Tipo de transação
```

**Sq00_Validade.xlsx** - Dados de Validade
```
Colunas principais:
- Material: Código do material
- Lote: Número do lote
- Data de fabricação: Data de produção
- Data de validade: Data de vencimento
- Quantidade: Quantidade em estoque
- Depósito: Local de armazenamento
```

**Validade Fornecedores.xlsx** - Tempos de Validade
```
Colunas principais:
- Material: Código do material
- Fornecedor: Nome do fornecedor
- Tempo de Validade: Prazo de validade (ex: "12 meses")
```

### Modelo de Dados Processados

O Monitor.py processa esses dados e cria colunas calculadas:
- `Dias_Validade`: Tempo de validade em dias
- `Venc_Esperado`: Data esperada de vencimento
- `Dias_Restantes`: Dias até o vencimento
- `Pct_Restante`: Percentual de vida útil restante
- `Status`: Classificação (Dentro do esperado, Atenção, Fora do esperado)
- `Status_Tempo`: Classificação temporal (Crítico, Atenção, Bom)

## 
Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property Reflection

Analisando as propriedades identificadas no prework, observamos que:

1. Muitas propriedades são sobre verificação de existência de arquivos (gitignore, README, requirements.txt, config.toml) - estas podem ser combinadas em uma única propriedade de "estrutura de projeto válida"
2. Propriedades sobre ausência de dependências Windows (requirements.txt e imports) são relacionadas e podem ser mantidas separadas pois testam aspectos diferentes
3. Propriedades sobre caminhos relativos e carregamento de dados são complementares e devem ser mantidas separadas

Após reflexão, mantemos as seguintes propriedades únicas:

**Property 1**: Estrutura de projeto válida (combina 1.1, 1.3, 1.4, 2.1, 7.1)
**Property 2**: Ausência de dependências Windows no requirements.txt (2.2)
**Property 3**: Caminhos relativos compatíveis com Linux (3.2)
**Property 4**: Ausência de imports Windows no código principal (3.4)
**Property 5**: Carregamento de dados sem erros de caminho (2.4)
**Property 6**: Tratamento de erros para dados inválidos (6.4)

### Correctness Properties

Property 1: Estrutura de projeto válida
*Para qualquer* repositório preparado para deploy, o sistema deve conter todos os arquivos de configuração necessários: .gitignore, README.md, requirements.txt, .streamlit/config.toml, e a pasta data/
**Validates: Requirements 1.1, 1.3, 1.4, 2.1, 7.1**

Property 2: Ausência de dependências Windows
*Para qualquer* arquivo requirements.txt gerado, o sistema não deve incluir bibliotecas específicas do Windows (pywin32, win32com, pythoncom)
**Validates: Requirements 2.2**

Property 3: Caminhos compatíveis com Linux
*Para qualquer* caminho de arquivo no código, o sistema deve usar caminhos relativos sem barras invertidas (\\) ou letras de drive (C:)
**Validates: Requirements 3.2**

Property 4: Código principal sem imports Windows
*Para qualquer* versão do Monitor.py, o código não deve importar bibliotecas específicas do Windows (win32com, pywin32, pythoncom)
**Validates: Requirements 3.4**

Property 5: Carregamento de dados robusto
*Para qualquer* execução da aplicação com arquivos de dados válidos na pasta data/, o sistema deve carregar os dados sem erros de caminho
**Validates: Requirements 2.4**

Property 6: Tratamento de erros de dados
*Para qualquer* tentativa de carregar dados inválidos ou ausentes, o sistema deve capturar exceções e exibir mensagens de erro claras ao usuário
**Validates: Requirements 6.4**

## Error Handling

### Estratégias de Tratamento de Erros

1. **Arquivos de Dados Ausentes**
   - Detectar FileNotFoundError ao carregar Excel
   - Exibir mensagem clara indicando qual arquivo está faltando
   - Usar st.error() para feedback visual
   - Interromper execução com st.stop()

2. **Dados Corrompidos ou Inválidos**
   - Capturar exceções de pandas ao ler Excel
   - Validar estrutura de colunas esperadas
   - Exibir mensagem descritiva do problema
   - Sugerir ações corretivas

3. **Erros de Configuração**
   - Validar existência de arquivos de configuração
   - Usar valores padrão quando possível
   - Documentar configurações obrigatórias

4. **Erros de Processamento**
   - Envolver cálculos complexos em try-except
   - Registrar erros para debugging
   - Continuar execução quando possível

### Implementação de Error Handling

```python
import streamlit as st
import pandas as pd
import os

def carregar_dados_com_validacao():
    """
    Carrega dados Excel com validação e tratamento de erros robusto.
    """
    arquivos_necessarios = {
        'MB51': 'data/Mb51_SAP.xlsx',
        'SQ00': 'data/Sq00_Validade.xlsx',
        'Fornecedores': 'data/Validade Fornecedores.xlsx'
    }
    
    dados = {}
    arquivos_faltando = []
    
    # Verifica existência de todos os arquivos
    for nome, caminho in arquivos_necessarios.items():
        if not os.path.exists(caminho):
            arquivos_faltando.append(f"- {nome}: {caminho}")
    
    if arquivos_faltando:
        st.error("❌ Arquivos de dados não encontrados:")
        for arquivo in arquivos_faltando:
            st.error(arquivo)
        st.info("""
        **Como resolver:**
        1. Certifique-se de que os arquivos Excel estão na pasta `data/`
        2. Verifique os nomes dos arquivos
        3. Se estiver no Streamlit Cloud, faça commit dos arquivos no Git
        """)
        st.stop()
    
    # Carrega cada arquivo com tratamento de erros
    for nome, caminho in arquivos_necessarios.items():
        try:
            df = pd.read_excel(caminho)
            
            # Validação básica
            if df.empty:
                st.warning(f"⚠️ Arquivo {nome} está vazio")
            
            dados[nome] = df
            
        except pd.errors.EmptyDataError:
            st.error(f"❌ Arquivo {nome} está vazio ou corrompido")
            st.stop()
        except pd.errors.ParserError as e:
            st.error(f"❌ Erro ao processar {nome}: {e}")
            st.stop()
        except Exception as e:
            st.error(f"❌ Erro inesperado ao carregar {nome}: {e}")
            st.stop()
    
    return dados['MB51'], dados['SQ00'], dados['Fornecedores']

# Uso na aplicação
try:
    df_mb51, df_sq00, df_forn = carregar_dados_com_validacao()
    st.success("✅ Dados carregados com sucesso!")
except Exception as e:
    st.error(f"❌ Erro crítico: {e}")
    st.stop()
```

## Testing Strategy

### Abordagem Dual de Testes

Este projeto utilizará tanto testes unitários quanto testes baseados em propriedades para garantir a corretude do deploy e da aplicação.

### Unit Testing

Os testes unitários focarão em:

1. **Validação de Estrutura de Arquivos**
   - Verificar existência de .gitignore, README.md, requirements.txt
   - Validar estrutura de diretórios (data/, .streamlit/)
   - Confirmar presença de arquivos de configuração

2. **Validação de Conteúdo**
   - Verificar que requirements.txt não contém dependências Windows
   - Confirmar que .gitignore contém padrões Python/Streamlit
   - Validar formato de config.toml

3. **Análise de Código**
   - Verificar ausência de imports Windows em Monitor.py
   - Confirmar uso de caminhos relativos
   - Validar que não há caminhos absolutos Windows

### Property-Based Testing

Os testes baseados em propriedades utilizarão **Hypothesis** (biblioteca Python para PBT) e focarão em:

1. **Propriedades de Caminhos**
   - Gerar diversos formatos de caminhos
   - Verificar que todos são compatíveis com Linux
   - Confirmar que não há barras invertidas ou drives

2. **Propriedades de Carregamento de Dados**
   - Gerar DataFrames válidos e inválidos
   - Verificar que erros são tratados adequadamente
   - Confirmar que mensagens de erro são claras

3. **Propriedades de Configuração**
   - Gerar diferentes configurações
   - Verificar que valores padrão funcionam
   - Confirmar que configurações inválidas são rejeitadas

### Configuração de Testes

Cada teste baseado em propriedades será configurado para executar no mínimo 100 iterações para garantir cobertura adequada de casos de teste aleatórios.

Cada teste será marcado com comentário explícito referenciando a propriedade do design:
```python
# **Feature: deploy-streamlit, Property 1: Estrutura de projeto válida**
@given(...)
def test_estrutura_projeto():
    ...
```

### Framework de Testes

- **pytest**: Framework principal de testes
- **Hypothesis**: Biblioteca de property-based testing
- **pytest-cov**: Cobertura de código

### Estrutura de Testes

```
tests/
├── __init__.py
├── test_estrutura_projeto.py      # Testes de estrutura de arquivos
├── test_dependencias.py            # Testes de requirements.txt
├── test_codigo.py                  # Testes de análise de código
├── test_carregamento_dados.py      # Testes de carregamento
└── conftest.py                     # Fixtures compartilhadas
```

## Deployment Process

### Pré-requisitos

1. Conta no GitHub
2. Conta no Streamlit Cloud (gratuita)
3. Git instalado localmente
4. Python 3.8+ instalado

### Passo a Passo do Deploy

#### 1. Preparar Repositório Local

```bash
# Inicializar Git (se ainda não foi feito)
git init

# Adicionar arquivos
git add .

# Commit inicial
git commit -m "Preparar aplicação para deploy no Streamlit Cloud"
```

#### 2. Criar Repositório no GitHub

1. Acessar github.com
2. Criar novo repositório (público ou privado)
3. Não inicializar com README (já existe localmente)

#### 3. Conectar e Enviar Código

```bash
# Adicionar remote
git remote add origin https://github.com/seu-usuario/monitor-validades.git

# Enviar código
git branch -M main
git push -u origin main
```

#### 4. Deploy no Streamlit Cloud

1. Acessar share.streamlit.io
2. Fazer login com GitHub
3. Clicar em "New app"
4. Selecionar:
   - Repository: seu-usuario/monitor-validades
   - Branch: main
   - Main file path: Monitor.py
5. Clicar em "Deploy"

#### 5. Aguardar Deploy

- O Streamlit Cloud irá:
  - Clonar o repositório
  - Instalar dependências do requirements.txt
  - Iniciar a aplicação
  - Fornecer URL pública

- Tempo estimado: 2-5 minutos

#### 6. Verificar Aplicação

1. Acessar URL fornecida
2. Verificar se dashboard carrega corretamente
3. Testar filtros e visualizações
4. Confirmar que dados são exibidos

### Processo de Atualização de Dados

#### Método Manual (Recomendado)

```bash
# 1. Executar Atualizar.py localmente (Windows)
python Atualizar.py

# 2. Verificar arquivos atualizados
dir data\*.xlsx

# 3. Adicionar ao Git
git add data/*.xlsx

# 4. Commit com mensagem descritiva
git commit -m "Atualizar dados SAP - 09/12/2024"

# 5. Enviar para GitHub
git push origin main

# 6. Aguardar redeploy automático (30-60 segundos)
```

#### Script Automatizado (Windows)

Criar arquivo `atualizar_e_deploy.bat`:

```batch
@echo off
echo ========================================
echo  Atualizacao de Dados - Monitor Validades
echo ========================================
echo.

echo [1/4] Executando extracao SAP...
python Atualizar.py
if errorlevel 1 (
    echo ERRO: Falha na extracao SAP
    pause
    exit /b 1
)

echo.
echo [2/4] Adicionando arquivos ao Git...
git add data/*.xlsx

echo.
echo [3/4] Criando commit...
git commit -m "Atualizar dados SAP - %date% %time%"

echo.
echo [4/4] Enviando para GitHub...
git push origin main

echo.
echo ========================================
echo  Deploy iniciado no Streamlit Cloud!
echo  Aguarde 30-60 segundos para conclusao
echo ========================================
pause
```

### Troubleshooting

#### Problema: Aplicação não inicia

**Sintomas:** Erro ao carregar aplicação no Streamlit Cloud

**Soluções:**
1. Verificar logs no Streamlit Cloud
2. Confirmar que requirements.txt está correto
3. Verificar se Monitor.py não tem erros de sintaxe
4. Confirmar que arquivos data/*.xlsx existem no repositório

#### Problema: Arquivos de dados não encontrados

**Sintomas:** FileNotFoundError ao carregar Excel

**Soluções:**
1. Verificar que arquivos estão na pasta data/
2. Confirmar que arquivos foram commitados no Git
3. Verificar nomes dos arquivos (case-sensitive no Linux)
4. Fazer push novamente se necessário

#### Problema: Dependências não instaladas

**Sintomas:** ModuleNotFoundError

**Soluções:**
1. Adicionar biblioteca faltante ao requirements.txt
2. Commit e push do requirements.txt atualizado
3. Aguardar redeploy automático

#### Problema: Aplicação lenta

**Sintomas:** Dashboard demora para carregar

**Soluções:**
1. Otimizar tamanho dos arquivos Excel
2. Adicionar @st.cache_data em funções de carregamento
3. Reduzir número de visualizações simultâneas
4. Considerar upgrade de plano no Streamlit Cloud

### Limitações do Deploy Cloud

1. **Atualização SAP Automática**
   - Não funciona: Atualizar.py requer Windows e acesso SAP
   - Solução: Executar localmente e fazer push manual

2. **Tamanho de Arquivos**
   - Limite: ~100MB por arquivo no GitHub
   - Solução: Otimizar arquivos Excel, remover dados antigos

3. **Performance**
   - Plano gratuito tem recursos limitados
   - Solução: Otimizar código, usar cache, considerar upgrade

4. **Acesso Privado**
   - Plano gratuito: aplicação é pública
   - Solução: Upgrade para plano pago com autenticação

## Security Considerations

### Dados Sensíveis

1. **Não commitar:**
   - Credenciais SAP
   - Senhas
   - Tokens de API
   - Dados pessoais identificáveis

2. **Usar .gitignore:**
   ```
   # Credenciais
   *.env
   .env.local
   secrets.toml
   
   # Dados sensíveis
   *_credentials.json
   *_secrets.yaml
   ```

3. **Usar Streamlit Secrets:**
   - Para configurações sensíveis necessárias no cloud
   - Configurar em: Streamlit Cloud > App settings > Secrets

### Controle de Acesso

1. **Repositório Privado:**
   - Considerar tornar repositório GitHub privado
   - Limitar acesso a colaboradores autorizados

2. **Autenticação na Aplicação:**
   - Plano gratuito: sem autenticação
   - Plano pago: autenticação integrada disponível

### Auditoria

1. **Logs de Acesso:**
   - Streamlit Cloud fornece logs básicos
   - Considerar integração com ferramentas de analytics

2. **Histórico de Mudanças:**
   - Git mantém histórico completo
   - Usar mensagens de commit descritivas

## Maintenance and Monitoring

### Monitoramento

1. **Health Checks:**
   - Streamlit Cloud monitora automaticamente
   - Reinicia aplicação se necessário

2. **Logs:**
   - Acessar via Streamlit Cloud dashboard
   - Verificar erros e warnings regularmente

3. **Performance:**
   - Monitorar tempo de carregamento
   - Observar uso de recursos

### Manutenção Regular

1. **Atualização de Dados:**
   - Frequência recomendada: diária ou semanal
   - Automatizar com script batch

2. **Atualização de Dependências:**
   - Revisar requirements.txt mensalmente
   - Testar atualizações localmente primeiro

3. **Backup:**
   - Git serve como backup automático
   - Considerar backup adicional dos arquivos Excel

### Documentação

1. **README.md:**
   - Manter atualizado com mudanças
   - Incluir troubleshooting comum

2. **Changelog:**
   - Documentar mudanças significativas
   - Usar tags Git para versões

3. **Comentários no Código:**
   - Manter comentários atualizados
   - Documentar decisões de design
