#!/bin/bash
# AI Environment Setup for Mac Mini M4 24GB
# Creates Python virtual environment with AI/ML packages

set -e

echo "Setting up AI Environment..."

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "Creating ai-env virtualenv..."
pyenv virtualenv 3.13.1 ai-env
pyenv activate ai-env

pip install --upgrade pip

echo "Installing AI/ML packages (this will take 10-15 minutes)..."

pip install \
    torch torchvision torchaudio \
    transformers \
    accelerate \
    sentence-transformers \
    langchain langchain-community langchain-openai \
    llama-cpp-python \
    openai anthropic \
    jupyter jupyterlab ipywidgets \
    numpy pandas matplotlib seaborn plotly \
    scikit-learn scipy \
    huggingface-hub

pip install \
    ollama \
    chromadb \
    faiss-cpu

pip install boto3 psutil

echo ""
echo "AI environment created successfully"
echo ""
echo "To activate:"
echo "  pyenv activate ai-env"
echo ""
echo "To start Jupyter Lab:"
echo "  jupyter lab"
