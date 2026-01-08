#!/bin/bash
set -e

echo "=========================================="
echo "Starting Ollama service..."
echo "=========================================="

# Start Ollama server in background
ollama serve &
OLLAMA_PID=$!

echo "✓ Ollama server is ready!"

# Pull the base model (mistral-nemo) if not already available
echo ""
echo "=========================================="
echo "Checking for base model: mistral-nemo"
echo "=========================================="
if ! ollama list | grep -q "mistral-nemo"; then
    echo "Base model not found. Pulling mistral-nemo..."
    echo "This may take several minutes depending on your connection..."
    ollama pull mistral-nemo
    echo "✓ mistral-nemo model pulled successfully!"
else
    echo "✓ mistral-nemo model already available"
fi

# Create the question_processor model from Modelfile if specified
if [ -n "$OLLAMA_PRELOAD_MODEL" ]; then
    echo ""
    echo "=========================================="
    echo "Loading custom model: $OLLAMA_PRELOAD_MODEL"
    echo "=========================================="

    MODELFILE_PATH="/models/question_processor/Modelfile"

    if [ -f "$MODELFILE_PATH" ]; then
        echo "Found Modelfile at: $MODELFILE_PATH"
        echo "Creating custom model from Modelfile..."

        # Check if model already exists
        if ollama list | grep -q "$OLLAMA_PRELOAD_MODEL"; then
            echo "Model $OLLAMA_PRELOAD_MODEL already exists. Recreating..."
            ollama rm $OLLAMA_PRELOAD_MODEL 2>/dev/null || true
        fi

        # Create the model
        ollama create $OLLAMA_PRELOAD_MODEL -f $MODELFILE_PATH

        if [ $? -eq 0 ]; then
            echo "✓ Model $OLLAMA_PRELOAD_MODEL created successfully!"
            echo ""
            echo "Available models:"
            ollama list
        else
            echo "✗ ERROR: Failed to create model $OLLAMA_PRELOAD_MODEL"
            exit 1
        fi
    else
        echo "✗ ERROR: Modelfile not found at $MODELFILE_PATH"
        echo ""
        echo "Directory structure:"
        ls -la /models/ 2>/dev/null || echo "No /models directory found"
        if [ -d /models/question_processor ]; then
            echo ""
            echo "Contents of /models/question_processor:"
            ls -la /models/question_processor/
        fi
        exit 1
    fi
else
    echo ""
    echo "No OLLAMA_PRELOAD_MODEL specified, skipping custom model creation"
fi

# Keep the container running
echo ""
echo "=========================================="
echo "✓ Ollama setup complete!"
echo "Server is ready to accept requests"
echo "=========================================="
echo ""

# Wait for the Ollama process
wait $OLLAMA_PID
