from flask import Flask
from flask import abort, redirect, url_for, session, request, render_template, Response

#from rauth.service import OAuth1Service, OAuth1Session

app = Flask(__name__)


@app.route('/upload')
def generate_large_csv():
    return "HI!"
    #request.files['file']
    #def generate():
    #    for row in iter_all_rows():
    #        yield ','.join(row) + '\n'
    #return Response(generate(), mimetype='text/csv')
