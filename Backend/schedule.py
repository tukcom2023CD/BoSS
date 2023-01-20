import json
from flask import Flask, request
from flask_restx import Api, Resource, Api  # Api 구현을 위한 Api 객체 import
import pymysql
import pandas as pd

# @app.route("/")

# flask 객체 인스턴스 생성
app = Flask(__name__)

# Api 객체 생성
api = Api(app)

# 신규 일정 생성 (C)
@api.route('/api/create/schedule')
class CreateScheduleRecord(Resource):
    def post(self):
        title = (request.json.get('title')) # json 데이터에서 title 값 저장
        region = (request.json.get('region')) # json 데이터에서 region 값 저장
        start = (request.json.get('start')) # json 데이터에서 start 값 저장
        stop = (request.json.get('stop')) # json 데이터에서 stop 값 저장
        uid = (request.json.get('uid')) # json 데이터에서 uid 값 저장
        conn = pymysql.connect(host='localhost', user='root', password='password', db='Boss', charset='utf8', autocommit=True) # 연결 설정
        curs = conn.cursor() # cursor 객체설정
        sql = f"insert into schedule(title, region, start, stop, uid) values('{title}', '{region}', '{start}', '{stop}', {uid})" # sql문 
        curs.execute(sql) # sql문 수행
        curs.close # cursor 닫기
        conn.close # DB연결 닫기

# 일정 데이터 가져오기 (R)
@api.route('/api/read/schedules/<int:uid>')  
class ReadScheduleRecords(Resource):
    def get(self, uid):
      conn = pymysql.connect(host='localhost', user='root', password='password', db='Boss', charset='utf8', autocommit=True) # 연결 설정
      curs = conn.cursor(pymysql.cursors.DictCursor) # cursor 객체설정 (결과값 딕셔너리 형태로 반환)
      sql = f"select * from schedule where uid = {uid}"
      curs.execute(sql) # 쿼리 실행
      data = curs.fetchall() # 1개 결과값만 반환
      data = json.dumps(data, ensure_ascii=False) # 딕셔너리 데이터 json 형식으로 변환
      curs.close # cursor 닫기
      conn.close # DB연결 닫기
      return data # json 형식의 데이터 반환

if __name__ == '__main__':
    app.run('0.0.0.0', port=5000, debug=True) 
