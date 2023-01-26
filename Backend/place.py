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


# 여행지 추가 (C)
@api.route('/api/place/create')
class CreatePlace(Resource):
    def post(self):
        name = (request.json.get('name'))
        address = (request.json.get('address'))
        latitude = (request.json.get('latitude'))
        longitude = (request.json.get('longitude'))
        category = (request.json.get('category'))
        sid = (request.json.get('sid'))
        uid = (request.json.get('uid'))
        
        sql = f"insert into place(name, address, latitude, longitude, category, sid, uid) values('{name}', '{address}', {latitude}, {longitude}, '{category}', {sid}, {uid})"
        conn = connect.ConnectDB(sql)
        conn.execute()
        del conn
        
# 여행지 조회 (R)
## 여행 날짜 순으로 정렬 후 리턴 필요
@api.route('/api/place/read/<int:sid>')
class ReadPlace(Resource):
    def get(self, sid):
        sql = f"select * from place where sid = {sid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn
        return jsonify({"places": data})


# 여행지 수정 (U)
# 일지, 총 지출, 방문여부 수정
@api.route('/api/place/update')
class UpdatePlace(Resource):
    def post(self):
        pid = (request.json.get('pid'))
        diary = (request.json.get('diary'))
        total_spending = (request.json.get('total_spending'))
        status = (request.json.get('status'))

        sql = f"update place set diary='{diary}', total_spending={total_spending}, status={status} where pid={pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.


# 여행지 삭제 (D)
@api.route('/api/place/delete/<int:pid>')
class DeletePlace(Resource):
    def get(self, pid):
        sql = f"delete from place where pid={pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.


if __name__ == '__main__':
    app.run('0.0.0.0', port=5001, debug=True) 