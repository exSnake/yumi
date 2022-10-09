import datetime as dt

from flask import Flask
from flask_restful import Api, Resource

from webargs import fields, validate
from webargs.flaskparser import use_args, use_kwargs, parser, abort

app = Flask(__name__)
api = Api(app)

def getConcreteConversation(comment):
    return comment
def getRandomConversation():
    return {
        "comment":"Test",
        "code":"Test"
    }

class ConcreteConversation(Resource):
    @use_kwargs({'comment': fields.Str(required=True)},location="query")
    def get(self, comment):
        return {
            "comment": "{}!".format(comment),
            "code": "{}".format(getConcreteConversation(comment))
        }

class RandomConversation(Resource):
    def get(self):
        return getRandomConversation()

# This error handler is necessary for usage with Flask-RESTful
@parser.error_handler
def handle_request_parsing_error(err, req, schema, *, error_status_code, error_headers):
    """webargs error handler that uses Flask-RESTful's abort function to return
    a JSON error response to the client.
    """
    abort(error_status_code, errors=err.messages)


if __name__ == "__main__":
    api.add_resource(ConcreteConversation, "/query")
    api.add_resource(RandomConversation, "/random")
    app.run(port=5001, debug=True)
