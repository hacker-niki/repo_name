# Ollama Dockerfile with automatic model loading
FROM ollama/ollama:latest

# Copy entrypoint script
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Expose Ollama API port
EXPOSE 11434

# Use custom entrypoint
ENTRYPOINT ["/root/entrypoint.sh"]
