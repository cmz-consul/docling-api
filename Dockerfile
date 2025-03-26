FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Instalar dependências adicionais, se necessário (ex.: para OCR)
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Script para pré-baixar o modelo
COPY download_model.py .
RUN python download_model.py

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
