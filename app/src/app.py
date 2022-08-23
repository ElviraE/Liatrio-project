from flask import (Flask, request, jsonify)
import time
app = Flask(__name__)

@app.route('/', methods = ['GET'])
def index():
    if(request.method == 'GET'):
        message = "Automate all the things!"
        timestamp = int(time.time())
        return jsonify({'message': message, 'timestamp': timestamp})

if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0', port=5000)