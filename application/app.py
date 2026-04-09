from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        "message": "Hello from Kubernetes Mastery!",
        "version": "1.0.0",
        "hostname": os.getenv('HOSTNAME', 'unknown')
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    # Using port 5000 as specified in the Dockerfile
    app.run(host='0.0.0.0', port=5000)
