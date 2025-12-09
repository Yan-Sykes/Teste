# ✅ Checklist de Deploy - Monitor de Validades

## 📋 Antes de Começar

### Pré-requisitos
- [ ] Conta GitHub criada
- [ ] Conta Streamlit Cloud criada (login com GitHub)
- [ ] Git instalado no computador
- [ ] Python 3.8+ instalado
- [ ] Acesso aos arquivos Excel do SAP

## 🔧 Preparação Local

### Verificar Arquivos
- [ ] Pasta `data/` existe
- [ ] Arquivo `Mb51_SAP.xlsx` presente (1,63 MB)
- [ ] Arquivo `Sq00_Validade.xlsx` presente (1,25 MB)
- [ ] Arquivo `Validade Fornecedores.xlsx` presente (0,30 MB)
- [ ] Arquivo `Vencimentos_SAP.xlsx` presente (1,49 MB)
- [ ] Arquivo `Monitor.py` presente
- [ ] Arquivo `requirements.txt` presente
- [ ] Arquivo `.streamlit/config.toml` presente

### Testar Localmente
- [ ] Abrir terminal na pasta do projeto
- [ ] Executar: `streamlit run Monitor.py`
- [ ] Aplicação abre no navegador (http://localhost:8501)
- [ ] Dashboard carrega sem erros
- [ ] Filtros funcionam
- [ ] Gráficos aparecem
- [ ] Sem mensagens de erro no console

## 📤 Git e GitHub

### Inicializar Git
- [ ] Executar: `git init`
- [ ] Executar: `git add .`
- [ ] Executar: `git commit -m "Preparar para deploy"`
- [ ] Verificar: `git status` (deve mostrar "nothing to commit")

### Criar Repositório GitHub
- [ ] Acessar github.com
- [ ] Clicar em "New repository"
- [ ] Nome: `monitor-validades` (ou outro)
- [ ] Visibilidade: Public (para plano gratuito Streamlit)
- [ ] **NÃO** marcar "Initialize with README"
- [ ] Clicar em "Create repository"
- [ ] Copiar URL do repositório

### Conectar e Enviar
- [ ] Executar: `git remote add origin [URL_DO_REPOSITORIO]`
- [ ] Executar: `git branch -M main`
- [ ] Executar: `git push -u origin main`
- [ ] Verificar no GitHub: arquivos aparecem no repositório
- [ ] Confirmar: pasta `data/` com arquivos Excel visível

## 🚀 Deploy no Streamlit Cloud

### Configurar Deploy
- [ ] Acessar share.streamlit.io
- [ ] Fazer login com GitHub
- [ ] Clicar em "New app"
- [ ] Selecionar repositório: `seu-usuario/monitor-validades`
- [ ] Branch: `main`
- [ ] Main file path: `Monitor.py`
- [ ] Clicar em "Deploy!"

### Aguardar Build
- [ ] Status muda para "Building"
- [ ] Aguardar 2-5 minutos
- [ ] Verificar logs (não deve ter erros)
- [ ] Status muda para "Running"
- [ ] URL da aplicação é fornecida

## ✅ Verificação Pós-Deploy

### Testar Aplicação
- [ ] Acessar URL fornecida
- [ ] Aguardar carregamento (deve ser < 10 segundos)
- [ ] Ver barra de progresso durante carregamento
- [ ] Dashboard aparece completamente
- [ ] Métricas (KPIs) são exibidas
- [ ] Gráficos são renderizados
- [ ] Cores e formatação corretas

### Testar Funcionalidades
- [ ] **Filtros Globais (Sidebar)**:
  - [ ] Buscar material funciona
  - [ ] Filtro de depósito funciona
  - [ ] Botão "Limpar Filtros" funciona
  
- [ ] **Aba Auditoria**:
  - [ ] Tabela de dados aparece
  - [ ] Filtros específicos funcionam
  - [ ] Gráficos interativos aparecem
  - [ ] Download Excel funciona
  
- [ ] **Aba Linha do Tempo**:
  - [ ] Área de itens críticos aparece
  - [ ] Contadores funcionam
  - [ ] Filtros especiais (Scrap, LogiTransfers) funcionam
  - [ ] Tabela de timeline aparece
  
- [ ] **Aba Exportar**:
  - [ ] Botão de exportação completa funciona
  - [ ] Botões de exportação individual funcionam
  - [ ] Arquivos Excel são baixados corretamente

### Verificar Performance
- [ ] Tempo de carregamento inicial < 10 segundos
- [ ] Filtros respondem em < 2 segundos
- [ ] Gráficos carregam em < 3 segundos
- [ ] Sem travamentos ou timeouts
- [ ] Sem erros visíveis

### Verificar Logs
- [ ] Streamlit Cloud > Manage app > Logs
- [ ] Sem erros críticos (vermelho)
- [ ] Warnings aceitáveis (amarelo)
- [ ] Aplicação iniciou corretamente

## 📱 Compartilhamento

### Preparar para Uso
- [ ] Copiar URL da aplicação
- [ ] Testar URL em navegador anônimo
- [ ] Confirmar que funciona sem login
- [ ] Adicionar URL ao README.md do repositório
- [ ] Commit e push da atualização

### Comunicar Equipe
- [ ] Enviar URL para equipe
- [ ] Explicar funcionalidades principais
- [ ] Compartilhar guia de uso (se houver)
- [ ] Informar sobre processo de atualização de dados

## 🔄 Configurar Atualização de Dados

### Processo Manual
- [ ] Documentar processo de atualização
- [ ] Testar script `Atualizar.py` localmente
- [ ] Testar commit e push de dados atualizados
- [ ] Verificar redeploy automático funciona
- [ ] Confirmar dados atualizados aparecem no dashboard

### Script Automatizado (Opcional)
- [ ] Testar `atualizar_e_deploy.bat`
- [ ] Verificar todas as etapas funcionam
- [ ] Documentar uso do script
- [ ] Treinar usuários responsáveis

## 📊 Monitoramento Contínuo

### Primeira Semana
- [ ] Verificar aplicação diariamente
- [ ] Monitorar tempo de resposta
- [ ] Coletar feedback dos usuários
- [ ] Verificar logs de erro
- [ ] Ajustar configurações se necessário

### Manutenção Regular
- [ ] Verificar tamanho dos arquivos semanalmente
- [ ] Limpar dados antigos mensalmente
- [ ] Atualizar dependências trimestralmente
- [ ] Revisar performance mensalmente
- [ ] Backup dos dados regularmente

## 🆘 Troubleshooting

### Se Algo Der Errado
- [ ] Verificar TROUBLESHOOTING_PERFORMANCE.md
- [ ] Verificar logs do Streamlit Cloud
- [ ] Testar localmente primeiro
- [ ] Verificar tamanho dos arquivos
- [ ] Verificar requirements.txt
- [ ] Reboot app no Streamlit Cloud
- [ ] Se persistir, criar issue no GitHub

## 📖 Documentação de Referência

### Arquivos Criados
- [ ] README.md - Documentação principal
- [ ] DEPLOY.md - Guia detalhado de deploy
- [ ] GUIA_RAPIDO_DEPLOY.md - Deploy em 5 minutos
- [ ] RESUMO_OTIMIZACOES.md - Otimizações implementadas
- [ ] TROUBLESHOOTING_PERFORMANCE.md - Resolução de problemas
- [ ] OTIMIZACAO.md - Plano de otimização
- [ ] CHECKLIST_DEPLOY.md - Este checklist

### Links Úteis
- [ ] Salvar: https://docs.streamlit.io
- [ ] Salvar: https://share.streamlit.io
- [ ] Salvar: https://discuss.streamlit.io
- [ ] Salvar: URL da aplicação deployada

## ✨ Conclusão

### Deploy Bem-Sucedido Quando:
- ✅ Aplicação acessível via URL pública
- ✅ Carregamento rápido (< 10 segundos)
- ✅ Todas as funcionalidades operacionais
- ✅ Sem erros nos logs
- ✅ Performance aceitável
- ✅ Equipe consegue acessar e usar
- ✅ Processo de atualização documentado
- ✅ Monitoramento configurado

### Próximos Passos:
1. Monitorar uso e performance
2. Coletar feedback dos usuários
3. Implementar melhorias sugeridas
4. Manter dados atualizados
5. Documentar problemas e soluções

---

**Data do Deploy:** ___/___/______
**Responsável:** _________________
**URL da Aplicação:** _________________
**Status:** [ ] Sucesso  [ ] Pendente  [ ] Com Problemas

---

**Dica:** Imprima este checklist e marque cada item conforme completa! 📋✅
