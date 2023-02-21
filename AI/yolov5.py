import torch
import json

def model():

  model = torch.hub.load('ultralytics/yolov5', 'yolov5s', trust_repo=True)

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

  return db


