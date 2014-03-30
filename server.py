from flask import Flask
from flask import abort, redirect, url_for, session, request, render_template, Response
import os
import datetime
import pytz

import httplib2
httplib2.debuglevel = 4
import httplib
httplib.HTTPConnection.debuglevel = 1
import requests
import json

app = Flask(__name__, static_folder="src/static", template_folder="src/html")

YT_CLIENT_ID = os.environ['YT_CLIENT_ID']
YT_CLIENT_SECRET = os.environ['YT_CLIENT_SECRET']
YT_REFRESH_TOKEN = os.environ['YT_REFRESH_TOKEN']
YT_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token'
YT_VIDEOS_URL = 'https://www.googleapis.com/upload/youtube/v3/videos'

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        print request
        f = request.files['file']
        #f.save('/tmp/uploaded_file.mp4')
        r = requests.post(YT_TOKEN_URL, data={
            'client_id' : YT_CLIENT_ID,
            'client_secret' : YT_CLIENT_SECRET,
            'refresh_token' : YT_REFRESH_TOKEN,
            'grant_type' : 'refresh_token'
        })

        print r.text
        access_token = r.json()['access_token']

        stream = f.stream
        stream.seek(0)
        content_length = len(f.stream.read())

        headers = {
            'Authorization': 'Bearer %s' % access_token,
            'content-type': 'application/json; charset=utf-8',
            'X-upload-content-length': content_length,
            'X-Upload-content-type': f.content_type,  # trust client ContentType?
            #'X-upload-content-type': 'application/octet-stream',
        }

        data = {
            "status": {
                "privacyStatus": "private",
                "license": "creativeCommon",
                "embeddable": "true"
            },
            "categoryId": "29", # Activism
            #"title": "",
            #"description": "",
            "recordingDate": datetime.datetime.now(pytz.UTC).isoformat()#,
            #"locationDescription"
        }

        #if request.location:
        #    data["location"]: {
        #        "latitude":
        #        "longitude":
        #    }

        params = {
            "part": "status",
            "uploadType": "resumable",
            "alt": "json",
        }

        r = requests.post(YT_VIDEOS_URL, headers=headers, data=json.dumps(data), params=params)
        print r.text

        headers = {
            'Authorization': 'Bearer %s' % access_token,
            'content-type': f.content_type,
            'content-length': content_length,
        }

        stream = f.stream
        stream.seek(0)
        r = requests.put(r.headers['Location'], headers=headers, data=stream)
        print r.text
        return '<p>Thanks for the video! View it <a href="http://youtube.com/watch?v=%s">here</a></p>' % r.json()['id']
    else:
        return "Hello"


@app.route('/')
def index():
    return render_template('index.html')



if __name__ == "__main__":
    app.run(debug=True)

