#!/usr/bin/env python3
"""
╔════════════════════════════════════════════════════════════╗
║       🔰 M A T R I X   A I   C O N S O L E   8 0 S 🔰      ║
║                  OFFLINE AI MODEL MANAGER                  ║
║                [●] RETRO CYBERPUNK EDITION                 ║
╚════════════════════════════════════════════════════════════╝
"""

import os
import sys
import subprocess
import json
import time
from datetime import datetime
from typing import Dict, List

# ANSI Color Codes - Phosphor Green Monitor (Retro 80s)
class Colors:
    MATRIX_GREEN = '\033[1;32m'     # Bright green (monitor glow)
    DARK_GREEN = '\033[2;32m'       # Dim green (phosphor dark)
    BRIGHT_GREEN = '\033[1;32m'     # Bright green (same as MATRIX_GREEN)
    CYAN = '\033[1;32m'             # Green for highlights
    YELLOW = '\033[1;32m'           # Green for text
    RED = '\033[1;32m'              # Green even for "errors"
    WHITE = '\033[1;32m'            # Green for white
    MAGENTA = '\033[1;32m'          # Green for all accents
    RESET = '\033[0m'
    DIM = '\033[2;32m'              # Dim green
    BOLD = '\033[1;32m'             # Bold green

class MatrixAI:
    def __init__(self):
        self.config_path = "/home/capgalius/skynet/ia/config"
        self.models = {}
        self.descriptions = {}
        self.profiles = {}
        self.load_config()
        
    def load_config(self):
        """Load models from config file"""
        if os.path.exists(self.config_path):
            with open(self.config_path, 'r') as f:
                config_content = f.read()
                for line in config_content.split('\n'):
                    line = line.strip()
                    if line and not line.startswith('#') and '=' in line:
                        key, value = line.split('=', 1)
                        key = key.strip()
                        value = value.strip().strip('"').strip("'")
                        
                        if key in ['CODELLAMA', 'DEEPSEEK', 'LLAMA8B', 'QWEN']:
                            self.models[key] = value
                        elif key == 'MODEL_DESCRIPTIONS':
                            self.parse_descriptions(value)
                        elif key.startswith('PROFILE_'):
                            profile_name = key.replace('PROFILE_', '')
                            self.profiles[profile_name] = value.split()
    
    def parse_descriptions(self, desc_string):
        """Parse model descriptions"""
        for item in desc_string.split('\\n'):
            if '=' in item:
                model, desc = item.split('=', 1)
                self.descriptions[model.strip()] = desc.strip()
    
    def fetch_models_from_ollama(self) -> List[str]:
        """Fetch installed models from Ollama"""
        try:
            result = subprocess.run(
                ['curl', '-sS', '--max-time', '3', 'http://127.0.0.1:11434/v1/models'],
                capture_output=True,
                text=True,
                timeout=4
            )
            if result.returncode == 0:
                data = json.loads(result.stdout)
                return [item['id'] for item in data.get('data', [])]
        except:
            pass
        
        try:
            result = subprocess.run(
                ['ollama', 'list'],
                capture_output=True,
                text=True,
                timeout=4
            )
            if result.returncode == 0:
                models = []
                for line in result.stdout.split('\n'):
                    if ':' in line:
                        model = line.split()[0]
                        models.append(model)
                return models
        except:
            pass
        
        return list(self.models.values())
    
    def print_banner(self):
        """Print retro Matrix banner"""
        os.system('clear')
        banner = f"""
{Colors.MATRIX_GREEN}{Colors.BOLD}
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║          ███╗   ███╗ █████╗ ████████╗██████╗ ██╗██╗  ██╗      ║
║          ████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║╚██╗██╔╝      ║
║          ██╔████╔██║███████║   ██║   ██████╔╝██║ ╚███╔╝       ║
║          ██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║ ██╔██╗       ║
║          ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║██╔╝ ██╗      ║
║          ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝      ║
║                                                               ║
║             ✨ OFFLINE AI CONSOLE - EDITION 80s ✨            ║
║                 [>] Ready to enter the Matrix                 ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
{Colors.RESET}
"""
        print(banner)
    
    def print_menu_item(self, number: int, text: str):
        """Print a menu item"""
        print(f"{Colors.CYAN}[{number}]{Colors.RESET} {Colors.BRIGHT_GREEN}{text}{Colors.RESET}")
    
    def list_models(self):
        """List available models with descriptions"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ AVAILABLE MODELS ═══╗{Colors.RESET}\n")
        
        models = self.fetch_models_from_ollama()
        
        if not models:
            print(f"{Colors.RED}[!] No models found. Start Ollama first.{Colors.RESET}\n")
            return
        
        for i, model in enumerate(models, 1):
            desc = self.descriptions.get(model, "No description")
            print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} {Colors.CYAN}{i}{Colors.RESET}. {Colors.YELLOW}{model}{Colors.RESET}")
            print(f"   {Colors.DIM}└─ {desc}{Colors.RESET}")
        
        print()
    
    def list_profiles(self):
        """List available profiles"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ PROFILES ═══╗{Colors.RESET}\n")
        
        if not self.profiles:
            print(f"{Colors.RED}[!] No profiles configured.{Colors.RESET}\n")
            return
        
        for i, (profile_name, model_names) in enumerate(self.profiles.items(), 1):
            model_list = ', '.join(model_names)
            print(f"{Colors.CYAN}[{i}]{Colors.RESET} {Colors.BRIGHT_GREEN}{profile_name.upper()}{Colors.RESET}")
            print(f"    {Colors.DIM}└─ {model_list}{Colors.RESET}")
        
        print()
    
    def select_model(self) -> str:
        """Interactive model selection"""
        models = self.fetch_models_from_ollama()
        
        if not models:
            print(f"{Colors.RED}[!] No models available.{Colors.RESET}")
            return ""
        
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ SELECT MODEL ═══╗{Colors.RESET}\n")
        
        for i, model in enumerate(models, 1):
            desc = self.descriptions.get(model, "")
            desc_str = f" - {Colors.DIM}{desc}{Colors.RESET}" if desc else ""
            print(f"{Colors.CYAN}[{i}]{Colors.RESET} {Colors.YELLOW}{model}{Colors.RESET}{desc_str}")
        
        print()
        while True:
            try:
                choice = input(f"{Colors.BRIGHT_GREEN}[>]{Colors.RESET} Select model (number): ")
                idx = int(choice) - 1
                if 0 <= idx < len(models):
                    return models[idx]
                else:
                    print(f"{Colors.RED}[!] Invalid selection.{Colors.RESET}")
            except (ValueError, KeyboardInterrupt):
                return ""
    
    def run_model(self, model: str):
        """Run selected model"""
        # Validate model name
        if not model or not model.strip():
            print(f"{Colors.RED}[!] Error: No model selected.{Colors.RESET}")
            return
        
        model = model.strip()
        
        # Validate that model name contains a colon (required format)
        if ':' not in model:
            print(f"{Colors.RED}[!] Error: Invalid model name '{model}'. Expected format: name:tag{Colors.RESET}")
            return
        
        print(f"\n{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Starting {Colors.YELLOW}{model}{Colors.RESET}...")
        print(f"{Colors.DIM}(Ctrl+C to exit){Colors.RESET}\n")
        
        try:
            # Use subprocess instead of os.system for better control
            subprocess.run(
                f"OLLAMA_GPU=1 ollama run {model}",
                shell=True,
                check=False
            )
        except KeyboardInterrupt:
            pass
        except Exception as e:
            print(f"{Colors.RED}[!] Error running model: {e}{Colors.RESET}")
        
        print(f"\n{Colors.DARK_GREEN}[!] Model stopped.{Colors.RESET}")
    
    def show_status(self):
        """Show system status"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ SYSTEM STATUS ═══╗{Colors.RESET}\n")
        
        try:
            result = subprocess.run(
                ['curl', '-sS', '--max-time', '2', 'http://127.0.0.1:11434/v1/models'],
                capture_output=True,
                timeout=3
            )
            status = f"{Colors.BRIGHT_GREEN}[●] ONLINE{Colors.RESET}"
        except:
            status = f"{Colors.RED}[●] OFFLINE{Colors.RESET}"
        
        print(f"Ollama Service: {status}")
        
        models = self.fetch_models_from_ollama()
        print(f"Available Models: {Colors.YELLOW}{len(models)}{Colors.RESET}")
        print(f"Configured Profiles: {Colors.YELLOW}{len(self.profiles)}{Colors.RESET}")
        print(f"Timestamp: {Colors.CYAN}{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{Colors.RESET}\n")
    
    def launch_copilot(self):
        """Launch GitHub Copilot CLI"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ GITHUB COPILOT CLI ═══╗{Colors.RESET}\n")
        
        try:
            subprocess.run(['which', 'copilot'], capture_output=True, check=True)
        except:
            print(f"{Colors.RED}[!] Copilot CLI not installed{Colors.RESET}")
            print(f"{Colors.DIM}Install with: gh extension install github/gh-copilot{Colors.RESET}\n")
            return
        
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Launching GitHub Copilot CLI...")
        print(f"{Colors.DIM}Type 'exit' or press Ctrl+C to return{Colors.RESET}\n")
        
        try:
            os.system('copilot')
        except KeyboardInterrupt:
            pass
    
    def launch_senior_reviewer(self):
        """Launch Senior Code Reviewer Agent"""
        print(f"\n{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ SENIOR CODE REVIEWER AGENT ═══╗{Colors.RESET}\n")
        
        reviewer_script = "/home/capgalius/skynet/ia/senior_code_reviewer.py"
        
        if not os.path.exists(reviewer_script):
            print(f"{Colors.RED}[!] Senior Reviewer not found{Colors.RESET}\n")
            return
        
        print(f"{Colors.BRIGHT_GREEN}[●]{Colors.RESET} Launching Senior Code Reviewer...")
        print(f"{Colors.DIM}Profile: Senior Developer with 15+ Years Experience{Colors.RESET}\n")
        
        try:
            os.system(f"python3 {reviewer_script}")
        except KeyboardInterrupt:
            pass
    
    def main_menu(self):
        """Main interactive menu"""
        self.print_banner()
        
        while True:
            print(f"{Colors.MATRIX_GREEN}{Colors.BOLD}╔═══ MAIN MENU ═══╗{Colors.RESET}\n")
            
            self.print_menu_item(1, "List Models")
            self.print_menu_item(2, "List Profiles")
            self.print_menu_item(3, "Run Model (Interactive)")
            self.print_menu_item(4, "System Status")
            self.print_menu_item(5, "GitHub Copilot CLI")
            self.print_menu_item(6, "Senior Code Reviewer")
            self.print_menu_item(7, "Clear Screen")
            self.print_menu_item(0, "Exit")
            
            print()
            print(f"{Colors.DARK_GREEN}{'─' * 50}{Colors.RESET}\n")
            
            choice = input(f"{Colors.BRIGHT_GREEN}[>]{Colors.RESET} Enter option: ").strip()
            
            if choice == '1':
                self.list_models()
            elif choice == '2':
                self.list_profiles()
            elif choice == '3':
                model = self.select_model()
                if model:
                    self.run_model(model)
            elif choice == '4':
                self.show_status()
            elif choice == '5':
                self.launch_copilot()
            elif choice == '6':
                self.launch_senior_reviewer()
            elif choice == '7':
                self.print_banner()
            elif choice == '0':
                print(f"\n{Colors.DARK_GREEN}[●] Exiting Matrix... Goodbye.{Colors.RESET}\n")
                break
            else:
                print(f"{Colors.RED}[!] Invalid option.{Colors.RESET}\n")
            
            input(f"{Colors.DIM}[Press Enter to continue...]{Colors.RESET}")
            self.print_banner()

def main():
    try:
        app = MatrixAI()
        app.main_menu()
    except KeyboardInterrupt:
        print(f"\n{Colors.RED}[!] Interrupted by user.{Colors.RESET}\n")
        sys.exit(0)

if __name__ == '__main__':
    main()
