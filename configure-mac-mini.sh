#!/bin/bash
# Mac Mini specific optimizations for AI/dev server use

echo "Configuring Mac Mini for AI workloads..."

cat >> ~/.zshrc << 'ZSHRC'

# Mac Mini AI Optimizations
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0
export PYTORCH_ENABLE_MPS_FALLBACK=1

# Ollama optimizations for 24GB RAM
export OLLAMA_NUM_PARALLEL=2
export OLLAMA_MAX_LOADED_MODELS=2
export OLLAMA_HOST=0.0.0.0:11434

# Python optimizations
export PYTHONUNBUFFERED=1

# Quick aliases
alias ai='pyenv activate ai-env'
alias macmini-ip='ifconfig en0 | grep "inet " | awk "{print \$2}"'
alias gpu-monitor='sudo powermetrics --samplers gpu_power -i 1000'

ZSHRC

mkdir -p ~/services

cat > ~/services/status.sh << 'STATUS'
#!/bin/bash
# Mac Mini Status Check

echo "Mac Mini Status"
echo "==============="
echo ""

echo "System:"
echo "  CPU: $(sysctl -n machdep.cpu.brand_string)"
echo "  RAM: 24GB"
echo "  GPU: Apple M4 (integrated)"
echo ""

echo "Network:"
echo "  IP: $(ifconfig en0 | grep "inet " | awk '{print $2}')"
echo "  SSH: $(sudo systemsetup -getremotelogin)"
echo ""

echo "Ollama:"
if brew services list | grep ollama | grep started > /dev/null; then
    echo "  Status: Running"
    echo "  Models: $(ollama list | tail -n +2 | wc -l) loaded"
else
    echo "  Status: Stopped"
fi
echo ""

echo "Syncthing:"
if brew services list | grep syncthing | grep started > /dev/null; then
    echo "  Status: Running"
    echo "  URL: http://localhost:8384"
else
    echo "  Status: Stopped"
fi
echo ""

echo "Docker:"
if docker info > /dev/null 2>&1; then
    echo "  Status: Running"
else
    echo "  Status: Stopped"
fi
STATUS

chmod +x ~/services/status.sh

echo "Mac Mini configured successfully"
echo ""
echo "Check status anytime: ~/services/status.sh"
