from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
import connect
import celery_test

User = Namespace('User')

@User.route('/api/user/login')
class LoginUser(Resource):
    def post(self):
        email = (request.json.get('email'))
        name = (request.json.get('name'))

        for i in range(1,5):
            celery_test.working.delay(name, email+str(i))
        
        print("종료")
        return "종료"

# @User.route('/api/user/login')
# class LoginUser(Resource):
#     def post(self):
#         email = (request.json.get('email'))
#         name = (request.json.get('name'))
#         sql = f"select * from user where email='{email}'"
#         conn = connect.ConnectDB(sql)
#         conn.execute()
#         data = conn.fetch()
        
#         if len(data) == 0:
#             insertSql = f"insert into user(email, name) values('{email}', '{name}')"
#             conn = connect.ConnectDB(insertSql)
#             conn.execute()
            
#             conn = connect.ConnectDB(sql)
#             conn.execute()
#             data = conn.fetch()
    
#         print(data)
#         del conn
#         return jsonify(data[0])


        
    


# 유저 정보 업데이트 (U)
@User.route('/api/user/update')
class UpdateUser(Resource):
    def post(self):
        uid = int(request.json.get('uid')) # json 데이터에서 uid 값 저장
        email = (request.json.get('email')) # json 데이터에서 email 값 저장
        name = (request.json.get('name')) # json 데이터에서 name 값 저장
        sql = f"update user set email ='{email}', name ='{name}' where uid = {uid}" # sql문 
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

# 유저 정보 삭제 (D)
@User.route('/api/user/delete/<int:uid>')  
class DeleteUser(Resource):
    def get(self, uid):
        sql = f"delete from user where uid = {uid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.