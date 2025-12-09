@echo off
REM ========================================
REM  Script de Atualizacao e Deploy
REM  Monitor de Validades - Streamlit Cloud
REM ========================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo  Atualizacao de Dados - Monitor Validades
echo ========================================
echo.

REM Verificar se Python esta instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python nao encontrado!
    echo Por favor, instale Python 3.8+ e tente novamente.
    echo.
    pause
    exit /b 1
)

REM Verificar se Git esta instalado
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Git nao encontrado!
    echo Por favor, instale Git e tente novamente.
    echo.
    pause
    exit /b 1
)

REM Verificar se estamos em um repositorio Git
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Este diretorio nao e um repositorio Git!
    echo Execute 'git init' primeiro.
    echo.
    pause
    exit /b 1
)

REM Verificar se o script Atualizar.py existe
if not exist "Atualizar.py" (
    echo [ERRO] Arquivo Atualizar.py nao encontrado!
    echo Certifique-se de estar no diretorio correto.
    echo.
    pause
    exit /b 1
)

REM Verificar se a pasta data existe
if not exist "data" (
    echo [ERRO] Pasta data/ nao encontrada!
    echo Criando pasta data/...
    mkdir data
)

echo [1/5] Executando extracao SAP...
echo.
python Atualizar.py
if errorlevel 1 (
    echo.
    echo [ERRO] Falha na extracao SAP!
    echo Verifique:
    echo   - Conexao com SAP esta ativa
    echo   - Credenciais estao corretas
    echo   - Script Atualizar.py esta funcionando
    echo.
    pause
    exit /b 1
)

echo.
echo [2/5] Verificando arquivos atualizados...
echo.

REM Verificar se os arquivos Excel existem
set "arquivos_faltando=0"

if not exist "data\Mb51_SAP.xlsx" (
    echo [AVISO] Arquivo data\Mb51_SAP.xlsx nao encontrado
    set "arquivos_faltando=1"
)

if not exist "data\Sq00_Validade.xlsx" (
    echo [AVISO] Arquivo data\Sq00_Validade.xlsx nao encontrado
    set "arquivos_faltando=1"
)

if not exist "data\Vencimentos_SAP.xlsx" (
    echo [AVISO] Arquivo data\Vencimentos_SAP.xlsx nao encontrado
    set "arquivos_faltando=1"
)

if !arquivos_faltando! equ 1 (
    echo.
    echo [AVISO] Alguns arquivos de dados estao faltando.
    echo Deseja continuar mesmo assim? (S/N)
    set /p continuar=
    if /i not "!continuar!"=="S" (
        echo.
        echo Operacao cancelada pelo usuario.
        pause
        exit /b 0
    )
)

REM Verificar se ha mudancas para commitar
git diff --quiet data/*.xlsx
if errorlevel 1 (
    echo Arquivos de dados foram modificados.
) else (
    echo.
    echo [AVISO] Nenhuma mudanca detectada nos arquivos de dados.
    echo Deseja continuar com o commit mesmo assim? (S/N)
    set /p continuar_commit=
    if /i not "!continuar_commit!"=="S" (
        echo.
        echo Operacao cancelada. Nenhum commit foi criado.
        pause
        exit /b 0
    )
)

echo.
echo [3/5] Adicionando arquivos ao Git...
git add data/*.xlsx
if errorlevel 1 (
    echo [ERRO] Falha ao adicionar arquivos ao Git!
    pause
    exit /b 1
)

echo.
echo [4/5] Criando commit...
REM Gerar timestamp para o commit
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
    set "data_commit=%%a/%%b/%%c"
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set "hora_commit=%%a:%%b"
)

git commit -m "Atualizar dados SAP - !data_commit! !hora_commit!"
if errorlevel 1 (
    echo [AVISO] Nenhuma mudanca para commitar ou erro no commit.
    echo Verifique o status do Git.
    git status
    echo.
    pause
    exit /b 1
)

echo.
echo [5/5] Enviando para GitHub...
git push origin main
if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao enviar para GitHub!
    echo Verifique:
    echo   - Conexao com internet esta ativa
    echo   - Remote 'origin' esta configurado corretamente
    echo   - Voce tem permissao para push no repositorio
    echo.
    echo Tente executar manualmente:
    echo   git push origin main
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo  ^>^> Deploy iniciado no Streamlit Cloud!
echo ========================================
echo.
echo O Streamlit Cloud detectara as mudancas e
echo iniciara o redeploy automaticamente.
echo.
echo Tempo estimado: 30-60 segundos
echo.
echo Acesse sua aplicacao para verificar as atualizacoes.
echo.
echo ========================================
echo  Processo concluido com sucesso!
echo ========================================
echo.
pause
