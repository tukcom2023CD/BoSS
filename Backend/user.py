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

# 신규 유저 정보 생성 (C)
@api.route('/api/user/create')
class CreateUserRecord(Resource):
    def post(self):
        email = (request.json.get('email')) # json 데이터에서 email 값 저장
        name = (request.json.get('name')) # json 데이터에서 name 값 저장
        sql = f"insert into user(email, name) values('{email}', '{name}')" # sql문 
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
       
# 유저 정보 가져오기 (R)
@api.route('/api/user/read/<string:email>')  
class ReadUserRecord(Resource):
    def get(self, email):
        sql = f"select * from user where email = '{email}'"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"user": data}) # josn 형식의 데이터를 반환합니다.

# 유저 정보 업데이트 (U)
@api.route('/api/user/update')
class UpdateUserRecord(Resource):
    def post(self):
        uid = int(request.json.get('uid')) # json 데이터에서 uid 값 저장
        email = (request.json.get('email')) # json 데이터에서 email 값 저장
        name = (request.json.get('name')) # json 데이터에서 name 값 저장
        sql = f"update user set email ='{email}', name ='{name}' where uid = {uid}" # sql문 
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

# 유저 정보 삭제 (D)
@api.route('/api/user/delete/<int:uid>')  
class DeleteUserRecord(Resource):
    def get(self, uid):
        sql = f"delete from user where uid = {uid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

if __name__ == '__main__':
    app.run('0.0.0.0', port=5000, debug=True) 
