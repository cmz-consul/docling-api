from flask import Flask, request, jsonify
from docling.document_converter import DocumentConverter
import os

app = Flask(__name__)

# Inicializar o converter globalmente apenas na primeira requisição
converter = None

@app.route('/process', methods=['POST'])
def process_document():
    global converter
    if 'file' not in request.files:
        return jsonify({"error": "Nenhum arquivo enviado"}), 400
    
    file = request.files['file']
    file_path = f"/tmp/{file.filename}"
    file.save(file_path)

    try:
        # Inicializar o converter na primeira execução
        if converter is None:
            converter = DocumentConverter()
        result = converter.convert(file_path)
        extracted_text = result.text if hasattr(result, 'text') else str(result)
        return jsonify({"result": extracted_text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if os.path.exists(file_path):
            os.remove(file_path)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
