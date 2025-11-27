# Use Python slim base image
FROM python:3.11-slim

# Install required packages: setcap and net-tools for checking ports
RUN apt-get update && \
    apt-get install -y --no-install-recommends libcap2-bin net-tools && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -u 1000 appuser

# Set working directory
WORKDIR /opt/app

# Copy app code and requirements
COPY app/ ./app/
COPY app/requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Give python ability to bind low ports (use the real binary path)
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/python3.11

# Change ownership to non-root user
RUN chown -R appuser:appuser /opt/app

# Switch to non-root user
USER appuser

# Expose port 80
EXPOSE 80

# Start FastAPI with uvicorn
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

