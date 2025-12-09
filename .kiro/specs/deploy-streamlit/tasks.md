# Plano de Implementação - Deploy do Monitor de Validades

- [x] 1. Preparar estrutura do repositório Git





  - Criar arquivo .gitignore com padrões Python/Streamlit
  - Criar arquivo README.md com documentação completa de deploy
  - Criar pasta .streamlit/ com arquivo config.toml
  - Verificar que pasta data/ existe e contém arquivos necessários
  - _Requirements: 1.1, 1.3, 1.4, 7.1_

- [ ]* 1.1 Escrever teste de propriedade para estrutura de projeto
  - **Property 1: Estrutura de projeto válida**
  - **Validates: Requirements 1.1, 1.3, 1.4, 2.1, 7.1**

- [x] 2. Configurar dependências para ambiente cloud





  - Revisar requirements.txt atual
  - Remover dependências Windows-only (pywin32, win32com, pythoncom, psutil)
  - Manter apenas dependências necessárias para Monitor.py
  - Adicionar versões específicas para estabilidade
  - _Requirements: 2.1, 2.2_

- [ ]* 2.1 Escrever teste de propriedade para dependências
  - **Property 2: Ausência de dependências Windows**
  - **Validates: Requirements 2.2**

- [x] 3. Adaptar código Monitor.py para ambiente cloud





  - Verificar que não há imports de bibliotecas Windows
  - Confirmar uso de caminhos relativos (já implementado)
  - Adicionar função de carregamento de dados com tratamento de erros robusto
  - Adicionar validação de existência de arquivos
  - Adicionar mensagens de erro claras para usuários
  - _Requirements: 2.4, 3.2, 3.4, 6.4_

- [ ]* 3.1 Escrever teste de propriedade para caminhos
  - **Property 3: Caminhos compatíveis com Linux**
  - **Validates: Requirements 3.2**

- [ ]* 3.2 Escrever teste de propriedade para imports
  - **Property 4: Código principal sem imports Windows**
  - **Validates: Requirements 3.4**

- [ ]* 3.3 Escrever teste de propriedade para carregamento de dados
  - **Property 5: Carregamento de dados robusto**
  - **Validates: Requirements 2.4**

- [ ]* 3.4 Escrever teste de propriedade para tratamento de erros
  - **Property 6: Tratamento de erros de dados**
  - **Validates: Requirements 6.4**

- [ ] 4. Criar documentação de deploy




  - Escrever README.md com seções:
    - Descrição do projeto
    - Pré-requisitos
    - Instalação local
    - Deploy no Streamlit Cloud (passo-a-passo)
    - Atualização de dados
    - Troubleshooting
    - Limitações conhecidas
  - Criar arquivo DEPLOY.md com instruções detalhadas
  - Documentar processo de atualização de dados
  - _Requirements: 4.1, 4.2, 4.3_

- [x] 5. Criar scripts auxiliares de atualização





  - Criar script atualizar_e_deploy.bat para Windows
  - Adicionar validações no script
  - Documentar uso do script no README
  - _Requirements: 6.1_

- [x] 6. Configurar arquivo .streamlit/config.toml





  - Definir tema visual (cores, fonte)
  - Configurar opções de servidor
  - Configurar opções de browser
  - Adicionar comentários explicativos
  - _Requirements: 7.1_

- [x] 7. Preparar arquivos de dados para commit





  - Verificar que arquivos Excel estão na pasta data/
  - Confirmar nomes dos arquivos (Mb51_SAP.xlsx, Sq00_Validade.xlsx, Vencimentos_SAP.xlsx)
  - Verificar tamanho dos arquivos (limite GitHub: 100MB)
  - Adicionar data/README.md explicando origem dos dados
  - _Requirements: 1.4_

- [ ] 8. Criar repositório no GitHub




  - Criar novo repositório no GitHub
  - Configurar como público ou privado conforme necessidade
  - Adicionar descrição do projeto
  - Não inicializar com README (já existe localmente)
  - _Requirements: 1.1, 1.2_

- [ ] 9. Fazer commit inicial e push
  - Adicionar todos os arquivos ao Git
  - Criar commit inicial com mensagem descritiva
  - Adicionar remote do GitHub
  - Fazer push para branch main
  - Verificar que todos os arquivos foram enviados
  - _Requirements: 1.1, 1.4_

- [ ] 10. Configurar deploy no Streamlit Cloud
  - Acessar share.streamlit.io
  - Fazer login com GitHub
  - Criar nova aplicação
  - Selecionar repositório, branch e arquivo principal (Monitor.py)
  - Iniciar deploy
  - _Requirements: 5.1_

- [ ] 11. Verificar deploy e funcionalidade
  - Aguardar conclusão do deploy
  - Acessar URL fornecida
  - Testar carregamento do dashboard
  - Verificar visualizações e métricas
  - Testar filtros interativos
  - Confirmar que dados são exibidos corretamente
  - _Requirements: 5.1, 5.3, 5.4_

- [ ] 12. Documentar URL e processo de acesso
  - Adicionar URL da aplicação ao README.md
  - Documentar como compartilhar acesso
  - Criar guia rápido de uso para usuários finais
  - _Requirements: 5.1_

- [ ] 13. Testar processo de atualização de dados
  - Modificar um arquivo Excel localmente
  - Executar script de atualização
  - Verificar commit e push
  - Aguardar redeploy automático
  - Confirmar que dados foram atualizados no dashboard
  - _Requirements: 6.1, 6.2, 6.3_

- [ ] 14. Checkpoint - Verificar deploy completo
  - Ensure all tests pass, ask the user if questions arise.
  - Confirmar que aplicação está acessível via URL pública
  - Verificar que todas as funcionalidades estão operacionais
  - Validar que documentação está completa e clara
