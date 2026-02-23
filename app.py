# app.py
from flask import Flask, render_template, request, jsonify
from printer import print_tag

app = Flask(__name__)


@app.get("/")
def index():
    return render_template("index.html")


@app.post("/api/print")
def api_print():
    data = request.get_json(silent=True) or {}
    text = (data.get("text") or "").strip()

    if not text:
        return jsonify({"ok": False, "error": "Texto vazio. Digite algo para gerar a tag."}), 400

    # Limite simples para evitar “explodir” a etiqueta por acidente
    if len(text) > 500:
        return jsonify({"ok": False, "error": "Texto muito grande (máx. 500 caracteres)."}), 400

    try:
        print_tag(text)
        return jsonify({"ok": True, "message": "Tag enviada para impressão."})
    except Exception as e:
        # Em produção, você pode logar isso melhor
        return jsonify({"ok": False, "error": f"Falha ao imprimir: {str(e)}"}), 500


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=9000,
        debug=False
    )