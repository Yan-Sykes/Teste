# 📂 Pasta de Dados

Esta pasta contém os arquivos Excel necessários para o Monitor de Validades.

## 📋 Arquivos Necessários

Copie os seguintes arquivos da rede para esta pasta:

1. **Mb51_SAP.xlsx**
   - Origem: `\\br03file\pcoudir\Operacoes\10. Planning Raw Material\Gerenciamento de materiais\Monitor de validades\Mb51_SAP.xlsx`
   - Contém: Movimentações de material (entradas, saídas, transferências)

2. **Sq00_Validade.xlsx**
   - Origem: `\\br03file\pcoudir\Operacoes\10. Planning Raw Material\Gerenciamento de materiais\Monitor de validades\Sq00_Validade.xlsx`
   - Contém: Dados de validade dos materiais

3. **Validade Fornecedores.xlsx**
   - Origem: `\\br03file\pcoudir\Operacoes\10. Planning Raw Material\Gerenciamento de materiais\Atividades diarias\Validade Fornecedores.xlsx`
   - Contém: Tempos de validade por material/fornecedor

## 🔄 Atualização dos Dados

Para manter os dados atualizados no Streamlit Cloud:

1. Copie os arquivos atualizados da rede para esta pasta
2. Faça commit e push para o GitHub:
   ```bash
   git add data/
   git commit -m "Atualizar dados"
   git push
   ```

O Streamlit Cloud irá automaticamente fazer redeploy com os novos dados.

## ⚠️ Importante

- **NÃO** delete esta pasta
- Os arquivos Excel devem ter exatamente estes nomes
- Mantenha os dados atualizados regularmente
