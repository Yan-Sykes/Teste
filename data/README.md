# 📂 Pasta de Dados

Esta pasta contém os arquivos Excel exportados do SAP necessários para o Monitor de Validades.

## 📋 Arquivos Presentes

Os seguintes arquivos estão incluídos neste repositório:

1. **Mb51_SAP.xlsx** (1.63 MB)
   - Origem: Exportação SAP via transação MB51
   - Contém: Movimentações de material (entradas, saídas, transferências)
   - Atualização: Executar `Atualizar.py` localmente (requer acesso SAP)

2. **Sq00_Validade.xlsx** (1.25 MB)
   - Origem: Exportação SAP via transação SQ00
   - Contém: Dados de validade dos lotes de materiais
   - Atualização: Executar `Atualizar.py` localmente (requer acesso SAP)

3. **Validade Fornecedores.xlsx** (0.30 MB)
   - Origem: Planilha de tempos de validade por fornecedor
   - Contém: Tempos de validade padrão por material/fornecedor
   - Atualização: Manual ou via processo interno

4. **Vencimentos_SAP.xlsx** (1.49 MB)
   - Origem: Exportação SAP de dados de vencimento
   - Contém: Linha do tempo de vencimentos de materiais
   - Atualização: Executar `Atualizar.py` localmente (requer acesso SAP)

## ℹ️ Sobre os Dados

- **Tamanho total**: ~4.67 MB (bem abaixo do limite de 100MB do GitHub)
- **Formato**: Excel (.xlsx) compatível com pandas/openpyxl
- **Origem**: Sistema SAP da empresa e planilhas internas
- **Sensibilidade**: Dados operacionais internos (não contém informações pessoais)

## 🔄 Como Atualizar os Dados

### Método 1: Script Automatizado (Recomendado)

No ambiente Windows com acesso SAP:

```batch
# Execute o script de atualização e deploy
atualizar_e_deploy.bat
```

Este script irá:
1. Executar `Atualizar.py` para extrair dados do SAP
2. Atualizar os arquivos Excel na pasta `data/`
3. Fazer commit e push automático para o GitHub
4. Iniciar redeploy automático no Streamlit Cloud

### Método 2: Manual

1. Execute o script de atualização SAP:
   ```bash
   python Atualizar.py
   ```

2. Verifique que os arquivos foram atualizados:
   ```bash
   dir data\*.xlsx
   ```

3. Faça commit e push para o GitHub:
   ```bash
   git add data/*.xlsx
   git commit -m "Atualizar dados SAP - [DATA]"
   git push origin main
   ```

4. Aguarde 30-60 segundos para o Streamlit Cloud fazer redeploy automático

## ⚠️ Importante

- **NÃO** delete esta pasta ou os arquivos Excel
- Os arquivos devem ter **exatamente** estes nomes (case-sensitive no Linux)
- Tamanho máximo por arquivo: 100MB (GitHub limit)
- Atualização requer ambiente Windows com acesso SAP
- O Streamlit Cloud opera em modo **somente leitura** destes dados

## 🔒 Segurança

- Não commitar credenciais ou senhas
- Dados são operacionais, não contêm informações pessoais identificáveis
- Considere tornar o repositório privado se necessário
