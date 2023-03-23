import torch
import json
from glob import glob

def model(path, count):

  # 캐시 경로 설정
  torch.hub.set_dir(f'/app/yolo/{count}/cache')
    
  # 모델 다운로드
  yolo_model = torch.hub.load('ultralytics/yolov5', 'custom', path='./AI/best.pt', trust_repo=True)
  
  with open('./AI/tags_ko.json', encoding= "UTF8") as f:
    tags_ko = json.load(f)

  img_list = glob(path)
  
  categoryArray = [] # 카테고리 저장 배열
  
  for img_path in img_list:
      results = yolo_model(img_path);
    
      for pred in results.pred[0]:
          tag = tags_ko[int(pred[-1])]
          if tag not in categoryArray :
            categoryArray.append(tag)
    
  return categoryArray
