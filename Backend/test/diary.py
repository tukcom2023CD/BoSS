from flask import Flask, request, jsonify
from flask_restx import Api, Resource
import connect

# @app.route("/")

# flask 객체를 생섭합니다.
app= Flask(__name__)

# Api 객체를 생성합니다. 
api= Api(app)

# 일지 생성 (C)
@api.route('/api/diary/create')
class CreateDiary(Resource):
    def post(self):
        title= (request.json.get('title')) # json 데이터에서 title 값을 저장합니다.
        content= (request.json.get('content')) # json 데이터에서 content 값을 저장합니다
        pid= (request.json.get('pid')) # json 데이터에서 pid 값을 저장합니다.
        
        sql= f"insert into diary(title, content, pid) values('{title}', '{content}', {pid})" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        
# 일지 가져오기 (R)
@api.route('/api/diary/read/<int:pid>')  
class ReadDiary(Resource):
    def get(self, pid):
        sql = f"select * from diary where pid = {pid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"diary": data}) # josn 형식의 데이터를 반환합니다.
        
# 일지 업데이트 (U)
@api.route('/api/diary/update')
class UpdateDiary(Resource):
    def post(self):
        title= (request.json.get('title')) # json 데이터에서 title 값을 저장합니다.
        content= (request.json.get('content')) # json 데이터에서 content 값을 저장합니다
        pid= (request.json.get('pid')) # json 데이터에서 pid 값을 저장합니다.
        
        sql = f"update diary set title ='{title}', content ='{content}' where pid = {pid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

# 일지 삭제 (D)
@api.route('/api/diary/delete/<int:pid>')  
class DeleteDiary(Resource):
    def get(self, pid):
        sql = f"delete from diary where pid = {pid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

if __name__ == '__main__':
    app.run('0.0.0.0', port=5000, debug=True) 
