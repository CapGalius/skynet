#!/usr/bin/env python3
"""
🔰 SENIOR CODE REVIEWER AGENT 🔰

Generate Code with Offline Models + Review with GitHub Copilot
Senior Developer Profile: 15+ Years of Experience
"""

import os
import sys
import subprocess
import json
from datetime import datetime
from typing import Optional

class Colors:
    MATRIX_GREEN = '\033[92m'
    DARK_GREEN = '\033[32m'
    BRIGHT_GREEN = '\033[1;92m'
    CYAN = '\033[96m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    WHITE = '\033[97m'
    RESET = '\033[0m'
    DIM = '\033[2m'
    BOLD = '\033[1m'

class SeniorCodeReviewer:
    def __init__(self):
        self.config_path = "/home/capgalius/skynet/ia/config"
        self.review_log = "/home/capgalius/skynet/ia/code_reviews.log"
        self.models = {}
        self.load_config()
    
    def load_config(self):
        """Load configuration"""
        if os.path.exists(self.config_path):
            with open(self.config_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#') and '=' in line:
                        key, value = line.split('=', 1)
                        if key in ['CODELLAMA', 'DEEPSEEK', 'LLAMA8B', 'QWEN']:
                            self.models[key] = value.strip('"').strip("'")
    
    def print_banner(self):
        """Print retro banner"""
        os.system('clear')
        banner = f"""
{Colors.MATRIX_GREEN}{Colors.BOLD}
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║         🔰 SENIOR CODE REVIEWER AGENT 🔰                    ║
║                                                               ║
║   Generate Code (Offline) → Review (Online)                 ║
║   Senior Developer with 15+ Years of Experience             ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
{Colors.RESET}
"""
        print(banner)
    
    def log_review(self, task: str):
        """Log review action"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        with open(self.review_log, 'a') as f:
            f.write(f"[{timestamp}] {task}\n")
    
    def get_generation_prompt(self, task: str, language: str) -> str:
        """Get code generation prompt"""
        return f"""You are an expert senior programmer with 15+ years of experience.
Generate clean, production-ready code for the following task:

Task: {task}
Language: {language}

Requirements:
- Write clear, maintainable code
- Include error handling
- Add meaningful comments
- Follow best practices for {language}
- Consider edge cases
- Use appropriate design patterns

Code:"""
    
    def get_review_prompt(self, code: str) -> str:
        """Get code review prompt"""
        return f"""You are a senior code reviewer with 15+ years of experience.
Review this code thoroughly and provide constructive feedback.

Code to review:
```
{code}
```

Analyze:
1. Code Quality - structure, clarity, maintainability
2. Best Practices - following language conventions
3. Performance - optimization opportunities
4. Security - potential vulnerabilities
5. Testing - testability and edge cases
6. Suggestions - improvements and refactoring

Provide a detailed review."""
    
    def check_models(self):
        """Check available models"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ MODEL STATUS ════╗{Colors.RESET}\n")
        
        # Check Ollama
        try:
            subprocess.run(
                ['curl', '-sS', '--max-time', '2', 'http://127.0.0.1:11434/v1/models'],
                capture_output=True,
                timeout=3,
                check=True
            )
            print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Ollama Service: {Colors.BRIGHT_GREEN}ONLINE{Colors.RESET}")
        except:
            print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Ollama Service: {Colors.RED}OFFLINE{Colors.RESET}")
            print(f"{Colors.DIM}Start with: ollama serve{Colors.RESET}")
        
        # Check Copilot
        try:
            subprocess.run(['which', 'copilot'], capture_output=True, check=True)
            print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} GitHub Copilot: {Colors.BRIGHT_GREEN}INSTALLED{Colors.RESET}")
        except:
            print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} GitHub Copilot: {Colors.YELLOW}NOT INSTALLED{Colors.RESET}")
            print(f"{Colors.DIM}Install: gh extension install github/gh-copilot{Colors.RESET}")
        
        print()
    
    def generate_code(self, task: str, language: str = "python", model: str = "codellama:7b"):
        """Generate code with offline model"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ CODE GENERATION ════╗{Colors.RESET}\n")
        
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Task: {Colors.YELLOW}{task}{Colors.RESET}")
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Language: {Colors.YELLOW}{language}{Colors.RESET}")
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Model: {Colors.YELLOW}{model}{Colors.RESET}\n")
        
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} {Colors.DIM}Generating with offline model...{Colors.RESET}\n")
        
        prompt = self.get_generation_prompt(task, language)
        
        try:
            result = subprocess.run(
                ['bash', '-c', f'echo "{prompt}" | OLLAMA_GPU=1 ollama run {model}'],
                capture_output=True,
                text=True,
                timeout=300
            )
            
            print(f"{Colors.DIM}--- Generated Code ---{Colors.RESET}\n")
            print(result.stdout)
            print(f"{Colors.DIM}--- End Generated Code ---{Colors.RESET}\n")
            
            self.log_review(f"Code generated: {task} (Model: {model})")
            
        except Exception as e:
            print(f"{Colors.RED}[!] Error: {str(e)}{Colors.RESET}\n")
    
    def review_code(self, code_file: str):
        """Review code with Copilot"""
        if not os.path.exists(code_file):
            print(f"{Colors.RED}[!] File not found: {code_file}{Colors.RESET}\n")
            return
        
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ CODE REVIEW ════╗{Colors.RESET}\n")
        
        with open(code_file, 'r') as f:
            code = f.read()
        
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} File: {Colors.YELLOW}{code_file}{Colors.RESET}")
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} {Colors.DIM}Analyzing with Copilot...{Colors.RESET}\n")
        
        try:
            subprocess.run(['which', 'copilot'], capture_output=True, check=True)
        except:
            print(f"{Colors.RED}[!] Copilot not available{Colors.RESET}\n")
            return
        
        prompt = self.get_review_prompt(code)
        
        try:
            result = subprocess.run(
                ['bash', '-c', f'echo "{prompt}" | copilot explain'],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            print(f"{Colors.DIM}--- Code Review ---{Colors.RESET}\n")
            print(result.stdout if result.stdout else result.stderr)
            print(f"{Colors.DIM}--- End Review ---{Colors.RESET}\n")
            
            self.log_review(f"Code reviewed: {code_file}")
            
        except Exception as e:
            print(f"{Colors.RED}[!] Error: {str(e)}{Colors.RESET}\n")
    
    def generate_and_review(self, task: str, language: str = "python", model: str = "codellama:7b"):
        """Full cycle: generate and review"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ FULL CYCLE: GENERATE & REVIEW ════╗{Colors.RESET}\n")
        
        # Step 1: Generate
        print(f"{Colors.MATRIX_GREEN}{Colors.BOLD}[STEP 1] GENERATING CODE{Colors.RESET}\n")
        
        prompt = self.get_generation_prompt(task, language)
        
        try:
            result = subprocess.run(
                ['bash', '-c', f'echo "{prompt}" | OLLAMA_GPU=1 ollama run {model}'],
                capture_output=True,
                text=True,
                timeout=300
            )
            
            generated_code = result.stdout
            
            print(f"{Colors.DIM}--- Generated Code ---{Colors.RESET}\n")
            print(generated_code)
            print(f"{Colors.DIM}--- End Generated Code ---{Colors.RESET}\n")
            
        except Exception as e:
            print(f"{Colors.RED}[!] Generation failed: {str(e)}{Colors.RESET}\n")
            return
        
        # Step 2: Review
        print(f"{Colors.MATRIX_GREEN}{Colors.BOLD}[STEP 2] REVIEWING WITH SENIOR DEVELOPER{Colors.RESET}\n")
        
        try:
            subprocess.run(['which', 'copilot'], capture_output=True, check=True)
        except:
            print(f"{Colors.YELLOW}[!] Copilot not available - skipping review{Colors.RESET}\n")
            self.log_review(f"Full cycle (generation only): {task}")
            return
        
        review_prompt = self.get_review_prompt(generated_code)
        
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} {Colors.DIM}Analyzing with Copilot (Senior Reviewer)...{Colors.RESET}\n")
        
        try:
            result = subprocess.run(
                ['bash', '-c', f'echo "{review_prompt}" | copilot explain'],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            print(f"{Colors.DIM}--- Senior Code Review ---{Colors.RESET}\n")
            print(result.stdout if result.stdout else result.stderr)
            print(f"{Colors.DIM}--- End Review ---{Colors.RESET}\n")
            
        except Exception as e:
            print(f"{Colors.YELLOW}[!] Review failed: {str(e)}{Colors.RESET}\n")
        
        # Summary
        print(f"{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ SUMMARY ════╗{Colors.RESET}\n")
        print(f"Task: {Colors.CYAN}{task}{Colors.RESET}")
        print(f"Language: {Colors.CYAN}{language}{Colors.RESET}")
        print(f"Offline Model: {Colors.CYAN}{model}{Colors.RESET}")
        print(f"Online Review: {Colors.CYAN}GitHub Copilot{Colors.RESET}\n")
        
        self.log_review(f"Full cycle completed: {task}")
    
    def show_history(self):
        """Show review history"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ REVIEW HISTORY ════╗{Colors.RESET}\n")
        
        if os.path.exists(self.review_log):
            with open(self.review_log, 'r') as f:
                lines = f.readlines()[-20:]
                for line in lines:
                    print(f"{Colors.CYAN}{line.strip()}{Colors.RESET}")
        else:
            print(f"{Colors.DIM}No reviews yet{Colors.RESET}")
        
        print()
    
    def main_menu(self):
        """Interactive menu"""
        self.print_banner()
        
        while True:
            print(f"{Colors.MATRIX_GREEN}{Colors.BOLD}╔════ SENIOR REVIEWER MENU ════╗{Colors.RESET}\n")
            
            print(f"{Colors.CYAN}[1]{Colors.RESET} {Colors.BRIGHT_GREEN}Generate Code (Offline){Colors.RESET}")
            print(f"{Colors.CYAN}[2]{Colors.RESET} {Colors.BRIGHT_GREEN}Review Code File (Copilot){Colors.RESET}")
            print(f"{Colors.CYAN}[3]{Colors.RESET} {Colors.BRIGHT_GREEN}Generate & Review (Full Cycle){Colors.RESET}")
            print(f"{Colors.CYAN}[4]{Colors.RESET} {Colors.BRIGHT_GREEN}Check Model Status{Colors.RESET}")
            print(f"{Colors.CYAN}[5]{Colors.RESET} {Colors.BRIGHT_GREEN}View Review History{Colors.RESET}")
            print(f"{Colors.CYAN}[0]{Colors.RESET} {Colors.BRIGHT_GREEN}Exit{Colors.RESET}\n")
            
            choice = input(f"{Colors.BRIGHT_GREEN}[>]{Colors.RESET} Select option: ").strip()
            
            if choice == '1':
                task = input(f"{Colors.YELLOW}Enter task description: {Colors.RESET}")
                language = input(f"{Colors.YELLOW}Language [python]: {Colors.RESET}") or "python"
                self.generate_code(task, language)
            
            elif choice == '2':
                code_file = input(f"{Colors.YELLOW}Enter code file path: {Colors.RESET}")
                self.review_code(code_file)
            
            elif choice == '3':
                task = input(f"{Colors.YELLOW}Enter task description: {Colors.RESET}")
                language = input(f"{Colors.YELLOW}Language [python]: {Colors.RESET}") or "python"
                self.generate_and_review(task, language)
            
            elif choice == '4':
                self.check_models()
            
            elif choice == '5':
                self.show_history()
            
            elif choice == '0':
                print(f"\n{Colors.DARK_GREEN}[●] Exiting Senior Reviewer... Goodbye.{Colors.RESET}\n")
                break
            
            else:
                print(f"{Colors.RED}[!] Invalid option{Colors.RESET}\n")
            
            input(f"{Colors.DIM}[Press Enter to continue...]{Colors.RESET}")
            os.system('clear')
            self.print_banner()

def main():
    try:
        reviewer = SeniorCodeReviewer()
        reviewer.main_menu()
    except KeyboardInterrupt:
        print(f"\n{Colors.RED}[!] Interrupted by user.{Colors.RESET}\n")
        sys.exit(0)

if __name__ == '__main__':
    main()
