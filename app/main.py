from flask import (
    Flask, jsonify, make_response, request
)

APP_NAME = 'flask-app'


def create_app():
    """
    Create the application
    """
    app = Flask(
        APP_NAME,
    )

    @app.route('/', methods=['GET'])
    def index():
        return "Hello! I'm up and running!"

    @app.route('/health', methods=['GET'])
    def health():
        if request.method == 'GET':
            # TODO: Add checks that determine the application's health.
            return make_response(jsonify({'status': "healthy"}), 200)
        else:
            return make_response(405)

    return app
