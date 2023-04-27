from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
import connect

Schedule = Namespace('Schedule')


# 일정 생성 (C)
@Schedule.route('/api/schedule/create')
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
@Schedule.route('/api/schedules/read/<int:uid>')  
class ReadSchedule(Resource):
    def get(self, uid):
        sql = f"select * from schedule where uid = {uid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        if len(data) != 0:
            data.sort(key=lambda x: x["start"]) # 여행 시작 날짜순으로 정렬
        return jsonify({"schedules": data}) # josn 형식의 데이터를 반환합니다.
    
# 일정 가져오기 (R)
@Schedule.route('/api/schedule/read/<int:sid>')  
class ReadSchedule(Resource):
    def get(self, sid):
        sql = f"select * from schedule where sid = {sid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify(data[0]) # josn 형식의 데이터를 반환합니다.
        

# 일정 업데이트 (U)
@Schedule.route('/api/schedule/update')
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
@Schedule.route('/api/schedule/delete/<int:sid>')  
class DeleteSchedule(Resource):
    def get(self, sid):
        sql = f"delete from schedule where sid = {sid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.