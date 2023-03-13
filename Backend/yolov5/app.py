from flask import Flask, render_template
import yolov5


app = Flask(__name__)

@app.route('/')
def index():
  db = yolov5.model()
  return render_template('index.html',photos = db)

if __name__ == '__main__':
  app.run('0.0.0.0', port=5002, debug=True)
