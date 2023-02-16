import torch
import json

model = torch.hub.load('ultralytics/yolov5', 'yolov5s')



with open('tags_ko.json', encoding= "UTF8") as f:
  tags_ko = json.load(f)

  print(tags_ko) 

  from glob import glob

img_list = glob('static/photos/*.jpg')
db = {}

for img_path in img_list:
    results = model(img_path);

    tags = set()

    for pred in results.pred[0]:
        tag = tags_ko[int(pred[-1])]

    for img_path in img_list:
        results = model(img_path)

        tags = set()

        for pred in results.pred[0]:

          tag = tags_ko[int(pred[-1])]
          tag = tag.replace(' ', '')
          tags.add(tag)

        db[img_path] = list(tags)

print(db)

from flask import Flask, render_template


app = Flask(__name__)

@app.route('/')
def index():
  return render_template('index.html',photos = db)

if __name__ == '__main__':
  app.run()

