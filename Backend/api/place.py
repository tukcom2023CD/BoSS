from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
import connect

Place = Namespace('Place')


# 여행지 추가 (C)
@Place.route('/api/place/create')
class CreatePlace(Resource):
    def post(self):
        name = (request.json.get('name'))
        address = (request.json.get('address'))
        latitude = (request.json.get('latitude'))
        longitude = (request.json.get('longitude'))
        category = (request.json.get('category'))
        visit_date = (request.json.get('visit_date'))
        sid = (request.json.get('sid'))
        uid = (request.json.get('uid'))
        
        sql = f"insert into place(name, address, latitude, longitude, visit_date, category, sid, uid) values('{name}', '{address}', {latitude}, {longitude}, '{visit_date}', '{category}', {sid}, {uid})"
        conn = connect.ConnectDB(sql)
        conn.execute()
        del conn
        
# 여행지 조회 (R)
## sid로 여행지 조회
@Place.route('/api/place/read/<int:sid>')
class ReadPlace(Resource):
    def get(self, sid):
        sql = f"select * from place where sid = {sid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn
        if len(data) != 0:
            data.sort(key=lambda x: x["visit_date"]) # 방문 날짜순으로 정렬

        return jsonify({"places": data})

## uid로 여행지 조회
@Place.route('/api/places/read/<int:uid>')
class ReadPlaces(Resource):
    def get(self, uid):
        sql = ""
        if request.args.get('start') == None:
            sql = f"select * from place where uid = {uid}"
        else:
            startDate = request.args.get('start')
            endDate = request.args.get('end')
            sql = f"select * from place where (uid = {uid}) and (visit_date between '{startDate}' and '{endDate}')"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn

        return jsonify({"places": data})

# 여행지 수정 (U)
# 일지, 총 지출, 방문여부 수정
@Place.route('/api/place/update')
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
@Place.route('/api/place/delete/<int:pid>')
class DeletePlace(Resource):
    def get(self, pid):
        sql = f"delete from place where pid={pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        