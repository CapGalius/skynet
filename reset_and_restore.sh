#!/usr/bin/env bash
###############################################################################
# SCRIPT DE BACKUP, RESET E RESTAURAÇÃO COMPLETA DO SISTEMA
# 
# Este script:
# 1. Lê e salva os modelos LLM instalados
# 2. Faz backup de arquivos importantes
# 3. Reseta o Ubuntu (remove dependências e caches)
# 4. Reinstala todas as dependências
# 5. Baixa novamente a pasta skynet do GitHub
# 6. Reinstala os modelos LLM
# 7. Reinstala o Copilot CLI
###############################################################################

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
SKYNET_DIR="${HOME}/skynet"
SKYNET_REPO="https://github.com/CapGalius/skynet.git"
BACKUP_DIR="${HOME}/.skynet_backup_$(date +%Y%m%d_%H%M%S)"
MODELS_FILE="${BACKUP_DIR}/models_list.txt"
GH_USERNAME="capgalius"

# Funções auxiliares
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

confirm() {
    local prompt="$1"
    local response
    read -p "$(echo -e ${YELLOW}$prompt${NC}) (s/n): " -r response
    [[ "$response" =~ ^[Ss]$ ]]
}

# 1. DETECTAR E SALVAR MODELOS LLM
detect_and_backup_models() {
    log_info "Detectando modelos LLM instalados..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Tentar API local primeiro
    local models=()
    if command -v curl >/dev/null 2>&1; then
        local json=$(curl -sS --max-time 3 http://127.0.0.1:11434/v1/models 2>/dev/null || true)
        if [ -n "$json" ]; then
            mapfile -t models < <(echo "$json" | jq -r '.data[].id' 2>/dev/null || true)
        fi
    fi
    
    # Fallback para 'ollama list'
    if [ ${#models[@]} -eq 0 ] && command -v ollama >/dev/null 2>&1; then
        mapfile -t models < <(ollama list 2>/dev/null | awk '/:/{print $1}' | sed 's/:latest//')
    fi
    
    if [ ${#models[@]} -eq 0 ]; then
        log_warn "Nenhum modelo LLM encontrado"
        echo "" > "$MODELS_FILE"
        return
    fi
    
    log_success "Modelos encontrados:"
    {
        for model in "${models[@]}"; do
            echo "$model"
            log_info "  - $model"
        done
    } | tee "$MODELS_FILE"
    
    log_success "Modelos salvos em: $MODELS_FILE"
}

# 2. FAZER BACKUP DE ARQUIVOS IMPORTANTES
backup_important_files() {
    log_info "Fazendo backup de arquivos importantes..."
    
    if [ -d "$SKYNET_DIR" ]; then
        cp -r "$SKYNET_DIR/.git" "$BACKUP_DIR/git_config" 2>/dev/null || true
        log_success "Backup do .git criado"
    fi
    
    # Backup de configurações SSH
    if [ -d "${HOME}/.ssh" ]; then
        cp -r "${HOME}/.ssh" "$BACKUP_DIR/ssh_backup" 2>/dev/null || true
        chmod 700 "$BACKUP_DIR/ssh_backup"
        log_success "Backup SSH criado"
    fi
    
    # Backup de git config
    if [ -f "${HOME}/.gitconfig" ]; then
        cp "${HOME}/.gitconfig" "$BACKUP_DIR/gitconfig_backup" 2>/dev/null || true
        log_success "Backup .gitconfig criado"
    fi
}

# 3. REMOVER DEPENDÊNCIAS ANTIGAS
cleanup_old_dependencies() {
    log_warn "Limpando dependências antigas..."
    
    # Python
    if command -v pip >/dev/null 2>&1; then
        log_info "Removendo pacotes Python..."
        pip freeze | grep -v "^-e" | xargs pip uninstall -y 2>/dev/null || true
    fi
    
    # Ollama
    if command -v ollama >/dev/null 2>&1; then
        log_info "Parando Ollama..."
        systemctl stop ollama 2>/dev/null || true
        sudo systemctl stop ollama 2>/dev/null || true
    fi
    
    # Node/NPM
    if command -v npm >/dev/null 2>&1; then
        log_info "Limpando cache NPM..."
        npm cache clean --force 2>/dev/null || true
    fi
    
    # Limpeza geral do sistema
    log_info "Executando limpeza do apt..."
    sudo apt-get autoremove -y 2>/dev/null || true
    sudo apt-get autoclean -y 2>/dev/null || true
    
    log_success "Limpeza concluída"
}

# 4. REINSTALAR DEPENDÊNCIAS DO SISTEMA
reinstall_system_dependencies() {
    log_info "Atualizando e reinstalando dependências do sistema..."
    
    sudo apt-get update
    
    # Dependências essenciais
    local deps=(
        "build-essential"
        "curl"
        "wget"
        "git"
        "jq"
        "python3"
        "python3-pip"
        "python3-dev"
        "nodejs"
        "npm"
        "bash"
        "zsh"
    )
    
    log_info "Instalando pacotes: ${deps[*]}"
    for dep in "${deps[@]}"; do
        log_info "  Instalando $dep..."
        sudo apt-get install -y "$dep" 2>&1 | grep -E "(Installing|already|done)" || true
    done
    
    log_success "Dependências do sistema instaladas"
}

# 5. REINSTALAR OLLAMA
reinstall_ollama() {
    log_info "Reinstalando Ollama..."
    
    # Download e instalação do Ollama
    if ! command -v ollama >/dev/null 2>&1; then
        log_info "Baixando Ollama..."
        curl -fsSL https://ollama.ai/install.sh | sh
    else
        log_warn "Ollama já está instalado"
    fi
    
    # Iniciar serviço
    log_info "Iniciando serviço Ollama..."
    sudo systemctl start ollama 2>/dev/null || true
    sleep 3
    
    log_success "Ollama instalado/atualizado"
}

# 6. REINSTALAR MODELOS LLM
reinstall_models() {
    log_info "Reinstalando modelos LLM..."
    
    if [ ! -s "$MODELS_FILE" ]; then
        log_warn "Nenhum modelo salvo para restaurar"
        return
    fi
    
    # Iniciar Ollama em background se não estiver rodando
    if ! curl -sS --max-time 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
        log_info "Iniciando Ollama..."
        ollama serve &
        sleep 5
    fi
    
    log_info "Puxando modelos..."
    while IFS= read -r model; do
        if [ -n "$model" ]; then
            log_info "  Puxando $model..."
            ollama pull "$model" &
            sleep 1
        fi
    done < "$MODELS_FILE"
    
    # Aguardar conclusão
    wait
    
    log_success "Modelos reinstalados"
}

# 7. BAIXAR SKYNET DO GITHUB
download_skynet() {
    log_warn "Deletando diretório antigo de skynet..."
    
    if [ -d "$SKYNET_DIR" ]; then
        rm -rf "$SKYNET_DIR"
        log_success "Diretório antigo removido"
    fi
    
    log_info "Clonando skynet do GitHub..."
    git clone "$SKYNET_REPO" "$SKYNET_DIR"
    
    log_success "Skynet baixado em: $SKYNET_DIR"
}

# 8. REINSTALAR COPILOT CLI
reinstall_copilot_cli() {
    log_info "Reinstalando GitHub Copilot CLI..."
    
    # Copilot CLI geralmente é instalado via npm
    if command -v npm >/dev/null 2>&1; then
        log_info "Instalando via NPM..."
        npm install -g @github/copilot-cli 2>/dev/null || log_warn "Copilot CLI NPM não disponível"
    fi
    
    # Alternativa: download direto
    if ! command -v copilot >/dev/null 2>&1; then
        log_info "Tentando instalação alternativa..."
        # Você pode adicionar o método de instalação específico aqui
        log_warn "Copilot CLI pode precisar de instalação manual"
    else
        log_success "Copilot CLI já está instalado"
    fi
}

# 9. VERIFICAÇÃO FINAL
final_check() {
    log_info "Executando verificação final..."
    
    echo -e "\n${BLUE}=== STATUS DO SISTEMA ===${NC}"
    
    echo -n "Git: "
    command -v git >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    
    echo -n "Python3: "
    command -v python3 >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    
    echo -n "Node/NPM: "
    command -v node >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    
    echo -n "Ollama: "
    command -v ollama >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    
    echo -n "Curl: "
    command -v curl >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    
    echo -n "JQ: "
    command -v jq >/dev/null 2>&1 && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}"
    
    if [ -d "$SKYNET_DIR" ]; then
        echo -e "Skynet: ${GREEN}✓${NC}"
    else
        echo -e "Skynet: ${RED}✗${NC}"
    fi
    
    # Verificar modelos Ollama
    if command -v ollama >/dev/null 2>&1; then
        echo -e "\n${BLUE}Modelos Ollama instalados:${NC}"
        ollama list 2>/dev/null || echo "Nenhum modelo ainda"
    fi
    
    echo -e "\n${GREEN}Backup salvo em: $BACKUP_DIR${NC}"
}

# FLUXO PRINCIPAL
main() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║     RESET E RESTAURAÇÃO DO SISTEMA SKYNET                     ║
║     Este script vai:                                           ║
║     1. Salvar modelos LLM instalados                           ║
║     2. Limpar dependências antigas                             ║
║     3. Reinstalar dependências do sistema                      ║
║     4. Reinstalar Ollama                                       ║
║     5. Baixar skynet do GitHub                                 ║
║     6. Reinstalar modelos LLM                                  ║
║     7. Reinstalar Copilot CLI                                  ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    if ! confirm "Deseja continuar com o reset completo do sistema?"; then
        log_warn "Operação cancelada pelo usuário"
        exit 0
    fi
    
    # Executar etapas
    detect_and_backup_models
    backup_important_files
    
    if confirm "Deseja limpar dependências antigas?"; then
        cleanup_old_dependencies
    fi
    
    if confirm "Deseja reinstalar dependências do sistema?"; then
        reinstall_system_dependencies
    fi
    
    if confirm "Deseja reinstalar Ollama?"; then
        reinstall_ollama
    fi
    
    if confirm "Deseja baixar skynet do GitHub novamente?"; then
        download_skynet
    fi
    
    if confirm "Deseja reinstalar modelos LLM?"; then
        reinstall_models
    fi
    
    if confirm "Deseja reinstalar Copilot CLI?"; then
        reinstall_copilot_cli
    fi
    
    # Verificação final
    final_check
    
    echo -e "\n${GREEN}╔════════════════════════════════════════╗"
    echo "║  RESET E RESTAURAÇÃO CONCLUÍDO COM SUCESSO  ║"
    echo "╚════════════════════════════════════════╝${NC}\n"
}

# Executar main
main "$@"
