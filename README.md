# Mac Mini M4 Setup Scripts

Automated setup scripts for configuring a Mac Mini M4 (24GB) as an AI development and home development server environment.

## Overview

This repository contains scripts to set up a Mac Mini M4 with:

- Development tools (Git, pyenv, VS Code, iTerm2)
- AI/ML environment (PyTorch, Transformers, Ollama)
- Server configuration (always-on, SSH access, Syncthing)
- System optimizations for 24GB RAM AI workloads

## Prerequisites

- Mac Mini M4 with macOS 14+ (Sonoma or later)
- Fresh macOS installation (recommended)
- Internet connection
- Admin access

## Quick Start
```bash
# Clone this repository
git clone https://github.com/yourusername/mac-mini-setup.git
cd mac-mini-setup

# Run the main setup script
bash setup-mac-mini.sh

# Restart your shell
source ~/.zshrc

# Set up AI environment
bash setup-ai-env.sh

# Download Ollama models (optional)
bash setup-ollama-models.sh

# Apply Mac Mini optimizations
bash configure-mac-mini.sh
```

## Scripts

### setup-mac-mini.sh

Main setup script that installs:

- Xcode Command Line Tools
- Homebrew package manager
- Essential CLI tools (git, ripgrep, fd, bat, htop, btop)
- GUI applications (iTerm2, VS Code, Docker, Rectangle, Stats, Claude)
- Oh My Zsh with agnoster theme
- Python version management (pyenv)
- Python 3.13.1 and 3.12.8
- Ollama for local LLM inference
- Database tools (TablePlus, NoSQL Workbench)
- Syncthing for file synchronization

System configuration:

- Disables system sleep
- Enables SSH server
- Configures Git with user information
- Generates SSH keys for GitHub
- Sets up directory structure

**Time:** 30-45 minutes

### setup-ai-env.sh

Creates a Python virtual environment with AI/ML packages:

- PyTorch with MPS (Metal Performance Shaders) support
- Transformers library
- LangChain for LLM applications
- Jupyter Lab for notebooks
- Scientific computing stack (NumPy, Pandas, Matplotlib)
- Vector databases (ChromaDB, FAISS)

**Time:** 15-20 minutes (PyTorch download)

### setup-ollama-models.sh

Downloads recommended Ollama models optimized for 24GB RAM:

- Llama 3.2 (8B) - General purpose
- Qwen 2.5 Coder (7B) - Code generation
- Qwen 2.5 (14B) - High quality responses
- Optional: Mistral (7B) and CodeLlama (13B)

**Time:** 30-60 minutes (downloads ~20GB)

### configure-mac-mini.sh

Applies Mac Mini specific optimizations:

- PyTorch memory configuration
- Ollama network and parallel model settings
- Shell aliases for common tasks
- Status monitoring script

Creates `~/services/status.sh` to check system status.

## Post-Setup Configuration

### Connect from MacBook Air

Add to `~/.ssh/config` on your MacBook Air:
```bash
Host macmini
    HostName 192.168.1.XXX  # Replace with Mac Mini IP
    User yourusername
    IdentityFile ~/.ssh/id_ed25519
```

Connect:
```bash
ssh macmini
```

### Use Ollama Remotely

On MacBook Air, set environment variable:
```bash
export OLLAMA_HOST="http://YOUR-MACMINI-IP:11434"
ollama list
ollama run llama3.2
```

### Configure Syncthing

1. Open Syncthing UI: http://localhost:8384
2. Add MacBook Air as a device
3. Share folders: `~/projects`, `~/Documents`
4. Repeat on MacBook Air to complete connection

## Environment Activation
```bash
# Activate AI environment
pyenv activate ai-env

# Or use alias
ai

# Start Jupyter Lab
jupyter lab

# Check Mac Mini status
~/services/status.sh
```

## Installed Tools

### CLI Tools

- git - Version control
- pyenv - Python version management
- ripgrep - Fast text search
- fd - Fast file finder
- bat - Cat with syntax highlighting
- htop, btop - System monitoring
- tree - Directory visualization
- tldr - Simplified man pages

### GUI Applications

- iTerm2 - Terminal emulator
- Visual Studio Code - Code editor
- Docker Desktop - Container platform
- Rectangle - Window management
- Stats - System monitor in menu bar
- Claude - AI assistant
- TablePlus - Database GUI
- NoSQL Workbench - DynamoDB GUI
- LM Studio (optional) - LLM GUI

### AI Tools

- Ollama - Local LLM runtime
- PyTorch - Deep learning framework
- Transformers - Hugging Face models
- LangChain - LLM application framework
- Jupyter Lab - Interactive notebooks

## System Configuration

### Always-On Server

The Mac Mini is configured to never sleep:
```bash
# Check sleep settings
sudo systemsetup -getsleep

# Re-enable sleep if needed
sudo pmset -a disablesleep 0
```

### SSH Access

SSH is enabled by default. To disable:
```bash
sudo systemsetup -setremotelogin off
```

### Memory Optimization

The scripts configure PyTorch and Ollama for 24GB RAM:

- PyTorch uses all available GPU memory
- Ollama can run 2 models simultaneously
- Environment variables in `~/.zshrc`

## Model Recommendations

For 24GB RAM, you can run:

| Model Size | Simultaneous | Quality | Speed |
|------------|--------------|---------|-------|
| 7-8B | 2-3 models | Good | Fast |
| 13-14B | 1-2 models | Better | Medium |
| 20-34B | 1 model | Best | Slower |

Recommended setup:

- **Daily use:** Qwen 2.5 (14B)
- **Coding:** Qwen 2.5 Coder (7B)
- **Fast responses:** Llama 3.2 (8B)

## Troubleshooting

### If Homebrew installation fails

Ensure you have admin privileges and internet connection. Try:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### pyenv not found after installation

Restart your shell or run:
```bash
source ~/.zprofile
```

### Ollama models download slowly

Models are large (4-15GB each). Download in background:
```bash
ollama pull llama3.2 &
```

### Permission errors during setup

Some operations require sudo. The script will prompt for password.

### Python packages fail to install

Ensure you're in the ai-env:
```bash
pyenv activate ai-env
pip install package-name
```

## Customization

### Change Python version

Edit `setup-mac-mini.sh` lines 98-100:
```bash
pyenv install 3.X.X
pyenv global 3.X.X
```

### Add additional Homebrew packages

Edit `setup-mac-mini.sh` lines 39-46 or 51-57.

### Modify AI packages

Edit `setup-ai-env.sh` lines 25-40.

## Directory Structure
```
~/projects/        # Your development projects
~/services/        # Background services and scripts
~/.config/         # Application configurations
~/.pyenv/          # Python versions and environments
~/Library/         # Application data
```

## Maintenance

### Update Homebrew packages
```bash
brew update
brew upgrade
```

### Update Python packages
```bash
pyenv activate ai-env
pip list --outdated
pip install --upgrade package-name
```

### Update Ollama models
```bash
ollama pull model-name
```

### Check system status
```bash
~/services/status.sh
```

## Related Projects

- [heartbeat-client](https://github.com/bcolb/heartbeat-client) - Device monitoring agent
- [heartbeat-monitor-infra](https://github.com/bcolb/heartbeat-monitor-infra) - AWS infrastructure

## License

MIT

## Author

Brice Colbert
