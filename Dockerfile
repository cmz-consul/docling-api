FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Instalar huggingface_hub para baixar o modelo
RUN pip install huggingface_hub

# Baixar o modelo explicitamente
RUN python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='ds4sd/docling-models', filename='model_artifacts/layout/beehive_v0.0.5/model.pt', local_dir='/root/.cache/huggingface/hub')"

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
