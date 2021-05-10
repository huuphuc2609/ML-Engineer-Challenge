from flask import Flask, request, jsonify
from transformers import pipeline

app = Flask(__name__)

@app.route('/post', methods=['POST'])
def post_route():
    if request.method == 'POST':
        # Get data from json and do some stuff
        response = request.get_json(force=True)
        text = response['input_text']

        model = pipeline('sentiment-analysis')

        prediction = model(text)[0]
        conf = int(prediction['score'] * 100)  # Round to nearest integer
        response = {"label": prediction['label'],
                    "score": conf}

        # Return data back
        return jsonify(response)

app.run()