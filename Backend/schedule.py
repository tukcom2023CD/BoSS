import json
from flask import Flask, request, jsonify
from flask_restx import Api, Resource
import pymysql
import connect

# @app.route("/")

# flask 객체를 생섭합니다.
app= Flask(__name__)

# Api 객체를 생성합니다. 
api= Api(app)

# 일정 생성 (C)
@api.route('/api/schedule/create')
class CreateSchedule(Resource):
    def post(self):
        title= (request.json.get('title')) # json 데이터에서 title 값을 저장합니다.
        region= (request.json.get('region')) # json 데이터에서 region 값을 저장합니다.
        start= (request.json.get('start')) # json 데이터에서 start 값을 저장합니다.
        stop= (request.json.get('stop')) # json 데이터에서 stop 값을 저장합니다.
        uid= (request.json.get('uid')) # json 데이터에서 uid 값을 저장합니다.
        
        sql= f"insert into schedule(title, region, start, stop, uid) values('{title}', '{region}', '{start}', '{stop}', {uid})" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        
# 일정 가져오기 (R)
@api.route('/api/schedules/read/<int:uid>')  
class ReadSchedule(Resource):
    def get(self, uid):
        sql = f"select * from schedule where uid = {uid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify(data) # josn 형식의 데이터를 반환합니다.
        

# 일정 업데이트 (U)
@api.route('/api/schedule/update')
class UpdateSchedule(Resource):
    def post(self):
        sid = (request.json.get('sid')) # json 데이터에서 sid 값을 저장합니다.
        title = (request.json.get('title')) # json 데이터에서 title 값을 저장합니다.
        region = (request.json.get('region')) # json 데이터에서 region 값을 저장합니다.
        start = (request.json.get('start')) # json 데이터에서 start 값을 저장합니다.
        stop = (request.json.get('stop')) # json 데이터에서 stop 값을 저장합니다.
        
        sql = f"update schedule set title ='{title}', region ='{region}', start ='{start}', stop ='{stop}' where sid = {sid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

# 일정 삭제 (D)
@api.route('/api/schedule/delete/<int:sid>')  
class DeleteSchedule(Resource):
    def get(self, sid):
        sql = f"delete from schedule where sid = {sid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

if __name__ == '__main__':
    app.run('0.0.0.0', port=5000, debug=True) 
