from flask import Flask, send_from_directory
import jsonify
import os

app = Flask(__name__)
BASE_DIR = os.path.abspath(os.path.dirname(__file__))

@app.route("/")
def serve_index():
    return send_from_directory(BASE_DIR, "index.html"), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
