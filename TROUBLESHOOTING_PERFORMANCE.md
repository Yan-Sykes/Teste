# 🔧 Troubleshooting de Performance - Monitor de Validades

## Problemas Comuns e Soluções

### 1. Aplicação Demora Muito para Carregar (> 30 segundos)

#### Causas Possíveis:
- Arquivos Excel muito grandes
- Muitos dados sendo processados
- Cache não está funcionando
- Recursos insuficientes no Streamlit Cloud

#### Soluções:

**A. Reduzir Tamanho dos Dados**
```python
# No script Atualizar.py, limitar dados:
# Apenas últimos 6 meses
data_limite = datetime.now() - timedelta(days=180)
df = df[df['Data de entrada'] >= data_limite]
```

**B. Verificar Tamanho dos Arquivos**
```bash
# No terminal local:
dir data\*.xlsx

# Tamanho ideal: < 10 MB cada
# Se maior, considere:
# 1. Remover colunas desnecessárias
# 2. Limitar período de dados
# 3. Comprimir arquivos
```

**C. Limpar Cache do Streamlit**
```python
# Na aplicação, pressione 'C' no teclado
# Ou adicione botão:
if st.button("🔄 Limpar Cache"):
    st.cache_data.clear()
    st.rerun()
```

**D. Verificar Logs do Streamlit Cloud**
```
1. Acesse Streamlit Cloud
2. Clique em "Manage app"
3. Veja "Logs"
4. Procure por erros ou warnings
```

### 2. Aplicação Trava ou Fica Lenta Após Uso

#### Causas Possíveis:
- Memória insuficiente
- Cache acumulado
- Muitos filtros aplicados

#### Soluções:

**A. Reiniciar Aplicação**
```
Streamlit Cloud > Manage app > Reboot app
```

**B. Limpar Filtros**
```python
# Use o botão "Limpar Todos os Filtros"
# Ou pressione 'R' para rerun
```

**C. Upgrade do Plano (se necessário)**
```
Plano Gratuito: 1 GB RAM
Plano Starter: 4 GB RAM (recomendado para dados grandes)
```

### 3. Gráficos Não Aparecem ou Demoram

#### Causas Possíveis:
- Muitos dados sendo plotados
- Conexão lenta
- Problemas com Plotly

#### Soluções:

**A. Limitar Dados nos Gráficos**
```python
# Já implementado: optimize_chart_data()
# Limita a 500 pontos por gráfico
```

**B. Desabilitar Interatividade**
```python
# Usar config estático:
st.plotly_chart(fig, config={'staticPlot': True})
```

**C. Verificar Conexão**
```
# Teste velocidade da internet
# Streamlit Cloud requer boa conexão
```

### 4. Erro "Out of Memory" ou "Killed"

#### Causas Possíveis:
- Dados muito grandes para RAM disponível
- Cache acumulado demais
- Plano gratuito insuficiente

#### Soluções:

**A. URGENTE: Reduzir Dados**
```python
# Carregar apenas colunas necessárias:
df = pd.read_excel(
    arquivo,
    usecols=['col1', 'col2', 'col3']  # Apenas essenciais
)

# Limitar linhas:
df = df.head(10000)  # Primeiras 10k linhas
```

**B. Otimizar Tipos de Dados**
```python
# Converter para tipos menores:
df['Material'] = df['Material'].astype('category')
df['Quantidade'] = df['Quantidade'].astype('int32')
```

**C. Upgrade para Plano Pago**
```
Plano Starter: $20/mês
- 4 GB RAM (vs 1 GB gratuito)
- Melhor performance
- Suporte prioritário
```

### 5. Filtros Demoram para Responder

#### Causas Possíveis:
- Muitos dados sendo filtrados
- Operações não otimizadas
- Cache não está ajudando

#### Soluções:

**A. Usar Filtros Progressivos**
```python
# Aplicar filtros mais restritivos primeiro
# Exemplo: Filtrar por depósito antes de material
```

**B. Limitar Opções de Filtro**
```python
# Limitar multiselect:
st.multiselect(
    "Material:",
    options=materiais,
    max_selections=20  # Limita seleções
)
```

**C. Adicionar Debounce**
```python
# Para text_input, usar session_state
# Evita filtrar a cada tecla digitada
```

### 6. Deploy Falha no Streamlit Cloud

#### Causas Possíveis:
- Dependências incompatíveis
- Arquivos muito grandes
- Erro no código

#### Soluções:

**A. Verificar requirements.txt**
```txt
# Versões específicas e compatíveis:
streamlit==1.28.0
pandas==2.0.3
numpy==1.24.3
plotly==5.17.0
openpyxl==3.1.2
```

**B. Verificar Tamanho Total**
```bash
# Tamanho total do repositório deve ser < 1 GB
# Verificar:
git count-objects -vH
```

**C. Testar Localmente Primeiro**
```bash
# Sempre testar antes de fazer deploy:
streamlit run Monitor.py

# Verificar erros no console
```

## Checklist de Performance

### Antes do Deploy:
- [ ] Arquivos Excel < 10 MB cada
- [ ] Total do repositório < 100 MB
- [ ] Testado localmente sem erros
- [ ] Cache configurado corretamente (TTL = 300s)
- [ ] requirements.txt atualizado

### Após Deploy:
- [ ] Tempo de carregamento < 10 segundos
- [ ] Filtros respondem em < 2 segundos
- [ ] Gráficos carregam em < 3 segundos
- [ ] Sem erros nos logs
- [ ] Uso de memória < 80%

### Manutenção Regular:
- [ ] Limpar dados antigos mensalmente
- [ ] Verificar tamanho dos arquivos
- [ ] Monitorar logs de erro
- [ ] Testar performance após atualizações
- [ ] Limpar cache periodicamente

## Comandos Úteis

### Local (Windows):
```bash
# Ver tamanho dos arquivos
dir data\*.xlsx

# Limpar cache Python
del /s /q __pycache__

# Reinstalar dependências
pip install -r requirements.txt --force-reinstall
```

### Streamlit Cloud:
```
# Reboot app
Manage app > Reboot app

# Ver logs
Manage app > Logs

# Limpar cache
Manage app > Clear cache > Reboot
```

### Git:
```bash
# Ver tamanho do repositório
git count-objects -vH

# Limpar histórico (cuidado!)
git gc --aggressive --prune=now

# Ver arquivos grandes
git ls-files -z | xargs -0 du -h | sort -h
```

## Contato e Suporte

Se os problemas persistirem:

1. **Verificar Documentação**: README.md e DEPLOY.md
2. **Logs**: Sempre verificar logs primeiro
3. **Comunidade Streamlit**: https://discuss.streamlit.io
4. **GitHub Issues**: Reportar bugs específicos

## Recursos Adicionais

- [Streamlit Performance Guide](https://docs.streamlit.io/library/advanced-features/caching)
- [Pandas Performance Tips](https://pandas.pydata.org/docs/user_guide/enhancingperf.html)
- [Plotly Performance](https://plotly.com/python/performance/)
