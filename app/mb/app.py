from flask import Flask, jsonify
import requests
import logging
import os

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

ENVIRONMENT = os.getenv("ENVIRONMENT", "prod")

@app.route('/<pair>', methods=['GET'])
def ticker(pair):
    pair = pair.upper()
    url = f"https://www.mercadobitcoin.net/api/{pair}/ticker/"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            return jsonify({"environment": ENVIRONMENT, "ticker": [data["ticker"]]})
        else:
            return jsonify({"error": f"Could not fetch ticker for {pair}", "status_code": response.status_code}), 500
    except Exception as e:
        logger.error("Error fetching ticker for %s: %s", pair, e)
        return jsonify({"error": "Internal error"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5555)
