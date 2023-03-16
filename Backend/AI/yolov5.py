import torch
import json
from glob import glob

def model(path):

  # model = torch.hub.load('ultralytics/yolov5', 'yolov5s', trust_repo=True)
  #model = torch.hub.load('ultralytics/yolov5', 'yolov5s', trust_repo=True, force_reload=True)
  model = torch.hub.load('ultralytics/yolov5', 'custom', path='./AI/best.pt', force_reload=False)

  with open('./AI/tags_ko.json', encoding= "UTF8") as f:
    tags_ko = json.load(f)

  img_list = glob(path)
  
  categoryArray = [] # 카테고리 저장 배열
  
  for img_path in img_list:
      results = model(img_path);
    
      for pred in results.pred[0]:
          tag = tags_ko[int(pred[-1])]
          if tag not in categoryArray :
            categoryArray.append(tag)
    
  return categoryArray
