import time
import random
import connect
from celery import Celery
from ai import yolov5
import urllib.request

celery = Celery('tasks', broker='amqp://user:password@rabbitmq:5672//', backend='rpc://')

@celery.task
def working(path, phid, url, count):
    
    # 이미지 다운로드
    urllib.request.urlretrieve(url, path)
    
    # 사진에대한 객체탐지후 DB 저장
    categoryArray = [] # 탐지된 카테고리 저장 배열
    categoryArray = yolov5.model(path, count) # yolov5 모델로 해당 사진의 객체 탐지후 저장
            
    # 탐지된 객체가 없는 경우
    if categoryArray == [] :
        categoryArray.append("기타")
            
    # 각 카테고리 DB 저장
    for category_name in categoryArray :
        sql = f"insert into category (phid, category_name) values ({phid}, '{category_name}')"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.