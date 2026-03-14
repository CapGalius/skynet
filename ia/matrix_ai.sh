#!/usr/bin/env bash
################################################################################
#                    🔰 M A T R I X   A I   C O N S O L E 🔰                   #
#                                                                              #
#   OFFLINE AI MODEL MANAGER - RETRO 80s CYBERPUNK EDITION                     #
#   Usage: ./matrix_ai.sh [option]                                             #
#                                                                              #
################################################################################

set -uo pipefail

# ═══════════════════════════════════════════════════════════════════════════
# COLOR DEFINITIONS - MATRIX STYLE
# ═══════════════════════════════════════════════════════════════════════════

# Matrix Green Theme
MATRIX_GREEN='\033[92m'
DARK_GREEN='\033[32m'
BRIGHT_GREEN='\033[1;92m'

# Status Colors
CYAN='\033[96m'
YELLOW='\033[93m'
RED='\033[91m'
WHITE='\033[97m'
MAGENTA='\033[95m'

# Text Styles
RESET='\033[0m'
DIM='\033[2m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

BASE_DIR="/home/capgalius/skynet"
IA_DIR="$BASE_DIR/ia"
CONFIG_FILE="$IA_DIR/config"
PYTHON_SCRIPT="$IA_DIR/matrix_ai.py"
LOG_FILE="$IA_DIR/sessions.log"

# Load config file for model descriptions
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# ═══════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

print_banner() {
    clear
    cat << 'EOF'

    ███████╗ █████╗ ██╗   ██╗███╗   ███╗
    ██╔════╝██╔══██╗██║   ██║████╗ ████║
    ███████╗███████║██║   ██║██╔████╔██║
    ╚════██║██╔══██║██║   ██║██║╚██╔╝██║
    ███████║██║  ██║╚██████╔╝██║ ╚═╝ ██║
    ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝

EOF
    
    printf "${MATRIX_GREEN}${BOLD}"
    printf "╔════════════════════════════════════════════════════════════╗\n"
    printf "║                                                            ║\n"
    printf "║          🔰 MATRIX AI CONSOLE - OFFLINE EDITION 🔰       ║\n"
    printf "║                                                            ║\n"
    printf "║              [>] Ready to enter the Matrix                ║\n"
    printf "║                                                            ║\n"
    printf "╚════════════════════════════════════════════════════════════╝\n"
    printf "${RESET}\n"
}

print_line() {
    local char="${1:-─}"
    local color="${2:-$DARK_GREEN}"
    printf "${color}"
    printf "%0.s${char}" $(seq 1 $(tput cols 2>/dev/null || echo 60))
    printf "${RESET}\n"
}

print_status() {
    local icon="${1:-[●]}"
    local message="$2"
    local color="${3:-$BRIGHT_GREEN}"
    printf "${color}${icon}${RESET} ${message}\n"
}

print_error() {
    printf "${RED}[!]${RESET} ${1}\n"
}

print_header() {
    printf "\n${MATRIX_GREEN}${BOLD}╔════ ${1} ════╗${RESET}\n\n"
}

print_menu_item() {
    local num="$1"
    local text="$2"
    printf "${CYAN}[${num}]${RESET} ${BRIGHT_GREEN}${text}${RESET}\n"
}

log_session() {
    local action="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    printf "[%s] %s\n" "$timestamp" "$action" >> "$LOG_FILE"
}

# ═══════════════════════════════════════════════════════════════════════════
# CORE FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

check_ollama() {
    if curl -sS --max-time 2 http://127.0.0.1:11434/v1/models >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

list_models() {
    print_header "AVAILABLE MODELS"
    
    if ! check_ollama; then
        print_error "Ollama service is OFFLINE. Start it first with: ${YELLOW}ollama serve${RESET}"
        return 1
    fi
    
    # Try to get models from API with jq
    local models=$(curl -sS --max-time 3 http://127.0.0.1:11434/v1/models 2>/dev/null | jq -r '.data[].id' 2>/dev/null || echo "")
    
    # Fallback: parse JSON without jq
    if [ -z "$models" ]; then
        local json=$(curl -sS --max-time 3 http://127.0.0.1:11434/v1/models 2>/dev/null || echo "")
        if [ -n "$json" ]; then
            models=$(echo "$json" | grep -oP '"id":"?\K[^"]+' | sed 's/"$//' || echo "")
        fi
    fi
    
    # Final fallback: ollama list command
    if [ -z "$models" ] && command -v ollama >/dev/null 2>&1; then
        models=$(ollama list 2>/dev/null | awk 'NR>1 && /:/{print $1}' | sed 's/,$//' || echo "")
    fi
    
    if [ -z "$models" ]; then
        print_error "No models found"
        return 0
    fi
    
    local count=0
    while IFS= read -r model; do
        if [ -n "$model" ]; then
            ((count++))
            printf "${BRIGHT_GREEN}[●]${RESET} ${CYAN}${count}${RESET}. ${YELLOW}${model}${RESET}\n"
        fi
    done <<< "$models"
    
    printf "\n${DIM}Total: ${count} models available${RESET}\n\n"
}

list_profiles() {
    print_header "CONFIGURED PROFILES"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Config file not found: $CONFIG_FILE"
        return 1
    fi
    
    local profile_count=0
    while IFS= read -r line; do
        if [[ $line =~ ^PROFILE_ ]]; then
            profile_count=$((profile_count + 1))
            local profile_name="${line%%=*}"
            profile_name="${profile_name#PROFILE_}"
            local profile_models="${line#*=}"
            
            printf "${CYAN}[${profile_count}]${RESET} ${BRIGHT_GREEN}${profile_name^^}${RESET}\n"
            printf "    ${DIM}└─ ${profile_models}${RESET}\n"
        fi
    done < "$CONFIG_FILE"
    
    if [ $profile_count -eq 0 ]; then
        print_error "No profiles configured in $CONFIG_FILE"
        return 1
    fi
    
    printf "\n"
}

show_status() {
    print_header "SYSTEM STATUS"
    
    # Ollama Status
    if check_ollama; then
        printf "Ollama Service: ${BRIGHT_GREEN}[●] ONLINE${RESET}\n"
    else
        printf "Ollama Service: ${RED}[●] OFFLINE${RESET}\n"
    fi
    
    # Model Count
    local model_count=$(curl -sS --max-time 2 http://127.0.0.1:11434/v1/models 2>/dev/null | jq '.data | length' 2>/dev/null || echo "0")
    printf "Available Models: ${YELLOW}${model_count}${RESET}\n"
    
    # System Info
    printf "Hostname: ${CYAN}$(hostname)${RESET}\n"
    printf "Timestamp: ${CYAN}$(date '+%Y-%m-%d %H:%M:%S')${RESET}\n"
    printf "Config: ${DIM}${CONFIG_FILE}${RESET}\n"
    
    printf "\n"
}

get_model_description() {
    local model="$1"
    local descriptions="$MODEL_DESCRIPTIONS"
    
    while IFS='=' read -r key value; do
        if [ "$key" = "$model" ]; then
            echo "$value"
            return 0
        fi
    done <<< "$descriptions"
    
    echo "Modelo de IA"
}

select_model() {
    print_header "SELECT MODEL" >&2
    
    if ! check_ollama; then
        print_error "Ollama service is offline" >&2
        return 1
    fi
    
    local models_array=()
    local model_list=$(curl -sS --max-time 3 http://127.0.0.1:11434/v1/models 2>/dev/null | jq -r '.data[].id' 2>/dev/null || echo "")
    
    if [ -z "$model_list" ] && command -v ollama >/dev/null 2>&1; then
        model_list=$(ollama list 2>/dev/null | awk 'NR>1 && /:/{print $1}' | sed 's/,$//')
    fi
    
    if [ -z "$model_list" ]; then
        print_error "No models available" >&2
        return 1
    fi
    
    local count=0
    while IFS= read -r model; do
        if [ -n "$model" ]; then
            ((count++))
            models_array+=("$model")
            local desc=$(get_model_description "$model")
            printf "${CYAN}[${count}]${RESET} ${YELLOW}${model}${RESET}\n" >&2
            printf "    ${DIM}└─ ${desc}${RESET}\n" >&2
        fi
    done <<< "$model_list"
    
    printf "\n" >&2
    printf "${BRIGHT_GREEN}[>]${RESET} Select model (number): " >&2
    read choice 2>&1
    
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#models_array[@]}" ]; then
        print_error "Invalid selection" >&2
        return 1
    fi
    
    local selected_model="${models_array[$((choice-1))]}"
    echo "$selected_model"
}

run_model() {
    local model="$1"
    
    if [ -z "$model" ]; then
        print_error "No model specified"
        return 1
    fi
    
    print_status "[●]" "Starting ${YELLOW}${model}${RESET}..." "$BRIGHT_GREEN"
    printf "${DIM}(Ctrl+C to exit)${RESET}\n\n"
    
    log_session "Model started: $model"
    
    # Run ollama in interactive mode - connect stdin directly
    # This prevents Ollama from trying to re-pull or re-validate the model
    OLLAMA_NUM_THREAD=4 ollama run "$model" 2>&1
    
    log_session "Model stopped: $model"
    print_status "[●]" "Model stopped."
}

run_python_ui() {
    if [ ! -f "$PYTHON_SCRIPT" ]; then
        print_error "Python UI not found: $PYTHON_SCRIPT"
        return 1
    fi
    
    if command -v python3 >/dev/null 2>&1; then
        python3 "$PYTHON_SCRIPT"
    elif command -v python >/dev/null 2>&1; then
        python "$PYTHON_SCRIPT"
    else
        print_error "Python not found. Install Python 3 first."
        return 1
    fi
}

launch_copilot() {
    print_header "GITHUB COPILOT CLI"
    
    if ! command -v copilot >/dev/null 2>&1; then
        print_error "GitHub Copilot CLI not installed"
        printf "${DIM}Install it with: gh extension install github/gh-copilot${RESET}\n"
        return 1
    fi
    
    printf "${BRIGHT_GREEN}[●]${RESET} Launching GitHub Copilot CLI...\n"
    printf "${DIM}Type 'exit' or press Ctrl+C to return${RESET}\n\n"
    
    log_session "Copilot CLI launched"
    
    copilot || true
    
    log_session "Copilot CLI closed"
}

main_menu() {
    print_banner
    log_session "Application started"
    
    while true; do
        print_header "MAIN MENU"
        
        print_menu_item "1" "List Models"
        print_menu_item "2" "List Profiles"
        print_menu_item "3" "Select & Run Model"
        print_menu_item "4" "System Status"
        print_menu_item "5" "Python UI (Advanced)"
        print_menu_item "6" "GitHub Copilot CLI"
        print_menu_item "7" "Clear Screen"
        print_menu_item "0" "Exit"
        
        printf "\n"
        print_line
        printf "\n"
        
        printf "${BRIGHT_GREEN}[>]${RESET} Enter option: "
        read option
        
        case "$option" in
            1)
                list_models
                ;;
            2)
                list_profiles
                ;;
            3)
                local selected=$(select_model)
                if [ $? -eq 0 ] && [ -n "$selected" ]; then
                    run_model "$selected"
                fi
                ;;
            4)
                show_status
                ;;
            5)
                run_python_ui
                ;;
            6)
                launch_copilot
                ;;
            7)
                clear
                print_banner
                continue
                ;;
            0)
                printf "\n${DARK_GREEN}[●] Exiting Matrix... Goodbye.${RESET}\n\n"
                log_session "Application closed"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                ;;
        esac
        
        printf "${DIM}[Press Enter to continue...]${RESET}"
        read dummy
        clear
        print_banner
    done
}

quick_run() {
    local option="$1"
    
    case "$option" in
        models)
            print_banner
            list_models
            ;;
        profiles)
            print_banner
            list_profiles
            ;;
        status)
            print_banner
            show_status
            ;;
        ui)
            run_python_ui
            ;;
        *)
            print_error "Unknown option: $option"
            echo "Usage: $0 {models|profiles|status|ui}"
            exit 1
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════

if [ $# -eq 0 ]; then
    run_python_ui
else
    quick_run "$1"
fi
