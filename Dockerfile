FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de cache com permissões adequadas
RUN mkdir -p /root/.cache/huggingface/hub && chmod -R 777 /root/.cache

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
