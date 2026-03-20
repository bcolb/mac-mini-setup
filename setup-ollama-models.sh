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

read -p "Download BitAgent (8B) for tool use / agentic tasks? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    BITAGENT_GGUF="BitAgent-8B.Q4_K_M.gguf"
    BITAGENT_URL="https://huggingface.co/mradermacher/BitAgent-8B-GGUF/resolve/main/${BITAGENT_GGUF}"
    BITAGENT_DIR="$HOME/.ollama/bitagent"

    mkdir -p "$BITAGENT_DIR"
    echo "Downloading BitAgent GGUF (~5GB)..."
    curl -L -o "$BITAGENT_DIR/$BITAGENT_GGUF" "$BITAGENT_URL"

    cat > "$BITAGENT_DIR/Modelfile" <<'EOF'
FROM ./BitAgent-8B.Q4_K_M.gguf

SYSTEM """You are an expert in composing functions. You are given a question and a set of possible functions. Based on the question, you will need to make one or more function/tool calls to achieve the purpose. If none of the functions can be used, point it out. You MUST put it in the format of [func_name(param=value, param2=value2)]."""
EOF

    echo "Importing BitAgent into Ollama..."
    ollama create bitagent -f "$BITAGENT_DIR/Modelfile"
fi

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
