from flask import Flask, request
import httplib2
httplib2.debuglevel = 4
import httplib
httplib.HTTPConnection.debuglevel = 1
import requests
import json

app = Flask(__name__)

REFRESH_DATA = {
  'client_id': '1000384659684-0oiu6g9qe0ibbv6cc2q48lbs21gc2fnl.apps.googleusercontent.com',
  'client_secret': 'bFEOEoJrpKvyniKljImuwdnj',
  'refresh_token': '1/jHDB9tLI-scfKwtnFLOzfm62nIdQNIWmL28HaEo_fXU',
  'grant_type': 'refresh_token'
}

YT_TOKEN_URL = 'https://accounts.google.com/o/oauth2/token'
YT_VIDEOS_URL = 'https://www.googleapis.com/upload/youtube/v3/videos'

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        print request
        f = request.files['file']
        f.save('/tmp/uploaded_file.mp4')
        r = requests.post(YT_TOKEN_URL, data=REFRESH_DATA)
        print r.text
        access_token = r.json()['access_token']
        f.stream.seek(0)
        content_length = len(f.stream.read())
        f.stream.seek(0)
        headers = {
            'Authorization': 'Bearer %s' % access_token,
            'content-type': 'application/json; charset=utf-8',
            'X-upload-content-length': content_length,
            'X-Upload-content-type': f.content_type,  # trust client ContentType?
            #'X-upload-content-type': 'application/octet-stream',
        }
        data = {"status": {"privacyStatus": "public"}}
        params = {
            "part": "status",
            "uploadType": "resumable",
            "alt": "json",
        }
        r = requests.post(YT_VIDEOS_URL, headers=headers, data=json.dumps(data), params=params)
        headers = {
            'Authorization': 'Bearer %s' % access_token,
            'content-type': f.content_type,
            'content-length': content_length,
            'content-range': 'bytes 0-%s/%s' % (content_length-1, content_length)
        }
        r = requests.put(r.headers['Location'], headers=headers, data=f.stream)
        print r.text
        return '<p>Thanks for the video! View it <a href="http://youtube.com/watch?v=%s">here</a></p>' % r.json()['id']
    else:
        return "Hello"
        
if __name__ == "__main__":
    app.run(debug=True)
