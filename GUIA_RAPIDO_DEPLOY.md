# 🚀 Guia Rápido de Deploy - Monitor de Validades

## ⚡ Deploy em 5 Minutos

### Passo 1: Preparar Arquivos
```bash
# Verificar que todos os arquivos estão presentes
dir data\*.xlsx
# Deve mostrar: Mb51_SAP.xlsx, Sq00_Validade.xlsx, Validade Fornecedores.xlsx, Vencimentos_SAP.xlsx
```

### Passo 2: Commit e Push
```bash
# Adicionar todas as alterações
git add .

# Criar commit
git commit -m "Otimizar performance e preparar para deploy"

# Enviar para GitHub
git push origin main
```

### Passo 3: Deploy no Streamlit Cloud
1. Acesse: https://share.streamlit.io
2. Clique em "New app"
3. Selecione seu repositório
4. Branch: `main`
5. Main file: `Monitor.py`
6. Clique em "Deploy!"

### Passo 4: Aguardar
- ⏱️ Tempo estimado: 2-5 minutos
- 🟡 Status "Building": Instalando dependências
- 🟢 Status "Running": Aplicação ativa!

### Passo 5: Testar
1. Acesse a URL fornecida
2. Aguarde carregamento (deve ser < 10 segundos)
3. Teste os filtros
4. Verifique as visualizações

## ✅ Checklist Rápido

### Antes do Deploy:
- [ ] Arquivos Excel na pasta `data/`
- [ ] requirements.txt atualizado
- [ ] Testado localmente (`streamlit run Monitor.py`)
- [ ] Sem erros no console
- [ ] Git commit e push feitos

### Após Deploy:
- [ ] URL acessível
- [ ] Carregamento < 10 segundos
- [ ] Filtros funcionando
- [ ] Gráficos aparecendo
- [ ] Sem erros visíveis

## 🔧 Problemas Comuns

### "Aplicação não carrega"
```
Solução:
1. Streamlit Cloud > Manage app > Logs
2. Verificar erros
3. Reboot app
```

### "Muito lento"
```
Solução:
1. Verificar tamanho dos arquivos (devem ser < 10 MB)
2. Limpar cache: Pressione 'C' na aplicação
3. Reboot app no Streamlit Cloud
```

### "Erro de dependências"
```
Solução:
1. Verificar requirements.txt
2. Usar versões específicas:
   streamlit==1.28.0
   pandas==2.0.3
   numpy==1.24.3
   plotly==5.17.0
   openpyxl==3.1.2
```

## 📱 Compartilhar

Após deploy bem-sucedido:
1. Copie a URL (ex: `https://seu-app.streamlit.app`)
2. Compartilhe com a equipe
3. Adicione ao README.md

## 🔄 Atualizar Dados

### Método Rápido:
```bash
# 1. Executar script de atualização (Windows local)
python Atualizar.py

# 2. Commit e push
git add data/*.xlsx
git commit -m "Atualizar dados SAP - 09/12/2024"
git push origin main

# 3. Aguardar redeploy automático (30-60 segundos)
```

### Método Automatizado:
```bash
# Usar o script batch
atualizar_e_deploy.bat
```

## 📊 Monitoramento

### Verificar Performance:
1. Streamlit Cloud > Manage app
2. Ver "Logs" para erros
3. Ver "Analytics" para uso
4. Monitorar tempo de resposta

### Métricas Ideais:
- ⚡ Carregamento: < 10 segundos
- 🎯 Filtros: < 2 segundos
- 💾 Memória: < 600 MB
- ✅ Uptime: > 99%

## 🆘 Ajuda

**Documentação Completa:**
- DEPLOY.md - Guia detalhado
- TROUBLESHOOTING_PERFORMANCE.md - Resolução de problemas
- RESUMO_OTIMIZACOES.md - Otimizações implementadas

**Links Úteis:**
- [Streamlit Docs](https://docs.streamlit.io)
- [Streamlit Cloud](https://share.streamlit.io)
- [Streamlit Community](https://discuss.streamlit.io)

---

**Dica:** Salve este guia para referência rápida! 📌
