#!/bin/bash

echo "=========================================="
echo "Docker Compose Setup Verification"
echo "=========================================="
echo ""

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "✗ docker-compose is not installed"
    exit 1
fi
echo "✓ docker-compose is available"

# Check if .env.dev exists
if [ ! -f .env.dev ]; then
    echo "✗ .env.dev file not found"
    exit 1
fi
echo "✓ .env.dev file exists"

# Validate docker-compose configuration
echo ""
echo "Validating docker-compose configuration..."
if docker-compose --env-file .env.dev config > /dev/null 2>&1; then
    echo "✓ docker-compose configuration is valid"
else
    echo "✗ docker-compose configuration has errors"
    exit 1
fi

# Check if Modelfile exists
if [ -f ./web/models/question_processor/Modelfile ]; then
    echo "✓ Modelfile found at ./web/models/question_processor/Modelfile"
else
    echo "✗ Modelfile not found at ./web/models/question_processor/Modelfile"
    exit 1
fi

# Check if entrypoint.sh exists and is executable
if [ -f ./docker/ollama/entrypoint.sh ]; then
    echo "✓ Ollama entrypoint.sh exists"
    if [ -x ./docker/ollama/entrypoint.sh ]; then
        echo "✓ entrypoint.sh is executable"
    else
        echo "! entrypoint.sh is not executable (will be fixed in Docker build)"
    fi
else
    echo "✗ Ollama entrypoint.sh not found"
    exit 1
fi

echo ""
echo "=========================================="
echo "✓ All checks passed!"
echo "=========================================="
echo ""
echo "You can now start the services with:"
echo "  docker-compose --env-file .env.dev up -d --build"
echo ""
echo "To monitor the Ollama model loading process:"
echo "  docker-compose logs -f ollama"
echo ""
