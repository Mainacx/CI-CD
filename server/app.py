from flask import Flask, jsonify
from flask_cors import CORS
from flask_wtf.csrf import CSRFProtect
import logging
import os
from dotenv import load_dotenv
from logging_config import setup_logging

load_dotenv()
app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('KEY')
CORS(app, resources={r"/healthz": {"origins": "http://localhost:8080"}})  
csrf = CSRFProtect(app) 
setup_logging() 

@app.route('/healthz', methods=['GET'])
def health_check():
    app.logger.info('Health check requested')
    return jsonify(status="200 OK"), 200

@app.errorhandler(404)
def not_found(error):
    app.logger.warning('404 error: %s', error)
    return jsonify(error="Not Found"), 404

if __name__ == "__main__":
    cert_file = 'certs/cert.pem'
    key_file = 'certs/key.pem'

    if os.path.exists(cert_file) and os.path.exists(key_file):
        app.logger.info('Run with SSL-certificate')
        app.run(host='0.0.0.0', port=8080, ssl_context=(cert_file, key_file))
    else:
        app.logger.error('SSL ceritficates not found. Run without SSL')
        app.run(host='0.0.0.0', port=8080)  

