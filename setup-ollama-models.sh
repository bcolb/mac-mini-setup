#!/bin/bash
# Download recommended Ollama models for 24GB RAM
# This will download approximately 20GB of models

echo "Downloading Ollama models..."
echo "This will download approximately 20GB of models"
echo ""

sleep 5

echo "Downloading Llama 3.2 (8B) - General purpose..."
ollama pull llama3.2:latest

echo "Downloading Qwen 2.5 Coder (7B) - Best for coding..."
ollama pull qwen2.5-coder:7b

echo "Downloading Qwen 2.5 (14B) - High quality..."
ollama pull qwen2.5:14b

read -p "Download Mistral (7B) for fast inference? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ollama pull mistral:latest
fi

read -p "Download CodeLlama (13B) for advanced coding? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ollama pull codellama:13b
fi

echo ""
echo "Models downloaded successfully"
echo ""
echo "Test with:"
echo "  ollama run llama3.2"
echo ""
echo "List models:"
echo "  ollama list"
