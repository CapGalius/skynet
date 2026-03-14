#!/usr/bin/env bash
################################################################################
#                 🔰 SENIOR CODE REVIEWER AGENT 🔰                            #
#                                                                              #
#   Gera código com modelos offline (Ollama) e revisa com Copilot (GitHub)   #
#   Comportamento: Programador Sênior com 15+ anos de experiência            #
#                                                                              #
################################################################################

set -uo pipefail

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

BASE_DIR="/home/capgalius/skynet"
IA_DIR="$BASE_DIR/ia"
CONFIG_FILE="$IA_DIR/config"
LOG_FILE="$IA_DIR/sessions.log"
REVIEW_LOG="$IA_DIR/code_reviews.log"

# Color Definitions
MATRIX_GREEN='\033[92m'
DARK_GREEN='\033[32m'
BRIGHT_GREEN='\033[1;92m'
CYAN='\033[96m'
YELLOW='\033[93m'
RED='\033[91m'
WHITE='\033[97m'
RESET='\033[0m'
DIM='\033[2m'
BOLD='\033[1m'

# ═══════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

print_banner() {
    clear
    printf "${MATRIX_GREEN}${BOLD}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║         🔰 SENIOR CODE REVIEWER AGENT 🔰                    ║
║                                                               ║
║   Generate Code (Offline) → Review (Online)                 ║
║   Senior Developer with 15+ Years of Experience             ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    printf "${RESET}\n"
}

print_status() {
    local icon="${1:-[●]}"
    local message="$2"
    local color="${3:-$BRIGHT_GREEN}"
    printf "${color}${icon}${RESET} ${message}\n"
}

print_header() {
    printf "\n${MATRIX_GREEN}${BOLD}╔════ ${1} ════╗${RESET}\n\n"
}

print_error() {
    printf "${RED}[!]${RESET} ${1}\n"
}

log_review() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local task="$1"
    printf "[%s] %s\n" "$timestamp" "$task" >> "$REVIEW_LOG"
}

# ═══════════════════════════════════════════════════════════════════════════
# SENIOR REVIEWER PROMPTS
# ═══════════════════════════════════════════════════════════════════════════

get_generation_prompt() {
    local task="$1"
    local language="${2:-python}"
    
    cat << EOF
You are an expert senior programmer with 15+ years of experience.
Generate clean, production-ready code for the following task:

Task: $task
Language: $language

Requirements:
- Write clear, maintainable code
- Include error handling
- Add meaningful comments
- Follow best practices for $language
- Consider edge cases
- Use appropriate design patterns

Code:
EOF
}

get_review_prompt() {
    local code="$1"
    
    cat << EOF
You are a senior code reviewer with 15+ years of experience.
Review this code thoroughly and provide constructive feedback.

Code to review:
\`\`\`
$code
\`\`\`

Analyze:
1. Code Quality - structure, clarity, maintainability
2. Best Practices - following language conventions
3. Performance - optimization opportunities
4. Security - potential vulnerabilities
5. Testing - testability and edge cases
6. Suggestions - improvements and refactoring

Provide a detailed review with scores (1-10) for each aspect.
EOF
}

get_refactor_prompt() {
    local code="$1"
    local issues="$2"
    
    cat << EOF
You are a senior refactoring expert. Based on these review issues:

$issues

Provide an improved version of this code:
\`\`\`
$code
\`\`\`

Requirements:
- Address all identified issues
- Maintain functionality
- Improve readability
- Add better error handling
- Include type hints/annotations if applicable
EOF
}

# ═══════════════════════════════════════════════════════════════════════════
# CORE FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

check_models() {
    print_header "CHECKING AVAILABLE MODELS"
    
    # Check Ollama
    if curl -sS --max-time 2 http://127.0.0.1:11434/v1/models >/dev/null 2>&1; then
        print_status "[●]" "Ollama Service: ONLINE" "$BRIGHT_GREEN"
    else
        print_status "[●]" "Ollama Service: OFFLINE" "$RED"
        print_error "Start Ollama with: ollama serve"
        return 1
    fi
    
    # Check Copilot
    if command -v copilot >/dev/null 2>&1; then
        print_status "[●]" "GitHub Copilot CLI: INSTALLED" "$BRIGHT_GREEN"
    else
        print_status "[●]" "GitHub Copilot CLI: NOT INSTALLED" "$YELLOW"
        printf "${DIM}Install with: gh extension install github/gh-copilot${RESET}\n"
    fi
    
    printf "\n"
}

generate_code() {
    local task="$1"
    local language="${2:-python}"
    local model="${3:-codellama:7b}"
    
    print_header "GENERATING CODE"
    
    printf "${BRIGHT_GREEN}[●]${RESET} Task: ${YELLOW}${task}${RESET}\n"
    printf "${BRIGHT_GREEN}[●]${RESET} Language: ${YELLOW}${language}${RESET}\n"
    printf "${BRIGHT_GREEN}[●]${RESET} Model: ${YELLOW}${model}${RESET}\n\n"
    
    printf "${BRIGHT_GREEN}[●]${RESET} ${DIM}Generating with offline model...${RESET}\n\n"
    
    local prompt=$(get_generation_prompt "$task" "$language")
    
    # Generate code with Ollama
    printf "${DIM}--- Generated Code ---${RESET}\n\n"
    echo "$prompt" | OLLAMA_GPU=1 ollama run "$model" 2>/dev/null || {
        print_error "Failed to generate code"
        return 1
    }
    
    printf "\n${DIM}--- End Generated Code ---${RESET}\n"
    
    log_review "Code generated: $task (Model: $model)"
}

review_code() {
    local code_file="$1"
    
    if [ ! -f "$code_file" ]; then
        print_error "File not found: $code_file"
        return 1
    fi
    
    local code=$(cat "$code_file")
    
    print_header "REVIEWING CODE"
    
    printf "${BRIGHT_GREEN}[●]${RESET} File: ${YELLOW}${code_file}${RESET}\n"
    printf "${BRIGHT_GREEN}[●]${RESET} ${DIM}Analyzing with Copilot...${RESET}\n\n"
    
    if ! command -v copilot >/dev/null 2>&1; then
        print_error "Copilot not available"
        return 1
    fi
    
    # Review with Copilot
    local prompt=$(get_review_prompt "$code")
    
    printf "${DIM}--- Code Review (Copilot) ---${RESET}\n\n"
    echo "$prompt" | copilot explain 2>/dev/null || {
        print_error "Failed to review code with Copilot"
        return 1
    }
    
    printf "\n${DIM}--- End Code Review ---${RESET}\n"
    
    log_review "Code reviewed: $code_file"
}

generate_and_review() {
    local task="$1"
    local language="${2:-python}"
    local offline_model="${3:-codellama:7b}"
    local output_file="/tmp/generated_code_$RANDOM.$language"
    
    print_header "FULL CYCLE: GENERATE & REVIEW"
    
    # Step 1: Generate
    printf "${MATRIX_GREEN}${BOLD}[STEP 1] GENERATING CODE${RESET}\n\n"
    
    local prompt=$(get_generation_prompt "$task" "$language")
    
    printf "${BRIGHT_GREEN}[●]${RESET} ${DIM}Generating with ${offline_model}...${RESET}\n\n"
    
    # Generate and save
    {
        echo "$prompt" | OLLAMA_GPU=1 ollama run "$offline_model" 2>/dev/null
    } > "$output_file" || {
        print_error "Failed to generate code"
        return 1
    }
    
    printf "${DIM}Generated code saved to: ${output_file}${RESET}\n\n"
    
    # Display generated code
    printf "${DIM}--- Generated Code ---${RESET}\n\n"
    cat "$output_file"
    printf "\n${DIM}--- End Generated Code ---${RESET}\n\n"
    
    # Step 2: Review
    printf "${MATRIX_GREEN}${BOLD}[STEP 2] REVIEWING WITH SENIOR DEVELOPER${RESET}\n\n"
    
    if ! command -v copilot >/dev/null 2>&1; then
        print_error "Copilot not available for review phase"
        printf "${DIM}Keeping generated code at: ${output_file}${RESET}\n\n"
        return 0
    fi
    
    local code=$(cat "$output_file")
    local review_prompt=$(get_review_prompt "$code")
    
    printf "${BRIGHT_GREEN}[●]${RESET} ${DIM}Analyzing with Copilot (Senior Reviewer)...${RESET}\n\n"
    
    printf "${DIM}--- Senior Code Review ---${RESET}\n\n"
    echo "$review_prompt" | copilot explain 2>/dev/null || {
        print_error "Failed to review code"
    }
    printf "\n${DIM}--- End Code Review ---${RESET}\n"
    
    # Summary
    printf "\n${MATRIX_GREEN}${BOLD}╔════ SUMMARY ════╗${RESET}\n\n"
    printf "Generated Code File: ${YELLOW}${output_file}${RESET}\n"
    printf "Task: ${CYAN}${task}${RESET}\n"
    printf "Language: ${CYAN}${language}${RESET}\n"
    printf "Offline Model: ${CYAN}${offline_model}${RESET}\n"
    printf "Online Review: ${CYAN}GitHub Copilot${RESET}\n\n"
    
    log_review "Full cycle completed: $task"
}

suggest_refactor() {
    local code_file="$1"
    
    if [ ! -f "$code_file" ]; then
        print_error "File not found: $code_file"
        return 1
    fi
    
    local code=$(cat "$code_file")
    
    print_header "SUGGESTING IMPROVEMENTS"
    
    if ! command -v copilot >/dev/null 2>&1; then
        print_error "Copilot not available"
        return 1
    fi
    
    printf "${BRIGHT_GREEN}[●]${RESET} ${DIM}Analyzing code structure...${RESET}\n\n"
    
    local refactor_prompt=$(get_refactor_prompt "$code" "improving code quality and following best practices")
    
    printf "${DIM}--- Refactored Code Suggestion ---${RESET}\n\n"
    echo "$refactor_prompt" | copilot suggest 2>/dev/null || {
        print_error "Failed to suggest improvements"
        return 1
    }
    printf "\n${DIM}--- End Suggestion ---${RESET}\n"
    
    log_review "Refactoring suggestions: $code_file"
}

interactive_mode() {
    print_banner
    
    while true; do
        printf "${MATRIX_GREEN}${BOLD}╔════ SENIOR REVIEWER MENU ════╗${RESET}\n\n"
        
        printf "${CYAN}[1]${RESET} ${BRIGHT_GREEN}Generate Code (Offline)${RESET}\n"
        printf "${CYAN}[2]${RESET} ${BRIGHT_GREEN}Review Code File (Copilot)${RESET}\n"
        printf "${CYAN}[3]${RESET} ${BRIGHT_GREEN}Generate & Review (Full Cycle)${RESET}\n"
        printf "${CYAN}[4]${RESET} ${BRIGHT_GREEN}Suggest Improvements${RESET}\n"
        printf "${CYAN}[5]${RESET} ${BRIGHT_GREEN}Check Model Status${RESET}\n"
        printf "${CYAN}[6]${RESET} ${BRIGHT_GREEN}View Review History${RESET}\n"
        printf "${CYAN}[0]${RESET} ${BRIGHT_GREEN}Exit${RESET}\n"
        
        printf "\n"
        read -p "$(printf '${BRIGHT_GREEN}[>]${RESET} Select option: ')" option
        
        case "$option" in
            1)
                read -p "Describe the task: " task
                read -p "Language (python/javascript/go/rust) [python]: " language
                language="${language:-python}"
                generate_code "$task" "$language"
                ;;
            2)
                read -p "Enter code file path: " code_file
                review_code "$code_file"
                ;;
            3)
                read -p "Describe the task: " task
                read -p "Language (python/javascript/go/rust) [python]: " language
                language="${language:-python}"
                generate_and_review "$task" "$language"
                ;;
            4)
                read -p "Enter code file path: " code_file
                suggest_refactor "$code_file"
                ;;
            5)
                check_models
                ;;
            6)
                print_header "REVIEW HISTORY"
                if [ -f "$REVIEW_LOG" ]; then
                    tail -20 "$REVIEW_LOG"
                else
                    printf "${DIM}No reviews yet${RESET}\n"
                fi
                ;;
            0)
                printf "\n${DARK_GREEN}[●] Exiting Senior Reviewer... Goodbye.${RESET}\n\n"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                ;;
        esac
        
        read -p "$(printf '${DIM}[Press Enter to continue...]${RESET}')" dummy
        clear
        print_banner
    done
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════

if [ $# -eq 0 ]; then
    interactive_mode
else
    case "$1" in
        generate)
            shift
            task="$@"
            language="${REVIEW_LANGUAGE:-python}"
            model="${REVIEW_MODEL:-codellama:7b}"
            generate_code "$task" "$language" "$model"
            ;;
        review)
            shift
            review_code "$1"
            ;;
        full)
            shift
            task="$@"
            language="${REVIEW_LANGUAGE:-python}"
            model="${REVIEW_MODEL:-codellama:7b}"
            generate_and_review "$task" "$language" "$model"
            ;;
        suggest)
            shift
            suggest_refactor "$1"
            ;;
        status)
            check_models
            ;;
        *)
            printf "Usage: $0 {generate|review|full|suggest|status} [args]\n"
            printf "   Or: $0 (for interactive menu)\n"
            exit 1
            ;;
    esac
fi
