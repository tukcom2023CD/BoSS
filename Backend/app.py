from flask import Flask, request, jsonify
from flask_restx import Api, Resource
import connect

# flask 객체를 생섭합니다.
app= Flask(__name__)

# Api 객체를 생성합니다. 
api= Api(app)

"""
user
"""

# 신규 유저 정보 생성 (C)
@api.route('/api/user/create')
class CreateUser(Resource):
    def post(self):
        email = (request.json.get('email')) # json 데이터에서 email 값 저장
        name = (request.json.get('name')) # json 데이터에서 name 값 저장
        sql = f"insert into user(email, name) values('{email}', '{name}')" # sql문 
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
       
# 유저 정보 가져오기 (R)
@api.route('/api/user/read/<string:email>')  
class ReadUser(Resource):
    def get(self, email):
        sql = f"select * from user where email = '{email}'"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"user": data}) # josn 형식의 데이터를 반환합니다.

# 유저 정보 업데이트 (U)
@api.route('/api/user/update')
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
@api.route('/api/user/delete/<int:uid>')  
class DeleteUser(Resource):
    def get(self, uid):
        sql = f"delete from user where uid = {uid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

@api.route('/api/user/login')
class LoginUser(Resource):
    def post(self):
        email = (request.json.get('email'))
        name = (request.json.get('name'))
        sql = f"select * from user where email='{email}'"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        
        if len(data) == 0:
            insertSql = f"insert into user(email, name) values('{email}', '{name}')"
            conn = connect.ConnectDB(insertSql)
            conn.execute()
            
            conn = connect.ConnectDB(sql)
            conn.execute()
            data = conn.fetch()
    
        print(data)
        del conn
        return jsonify(data[0])

"""
schedule
"""

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
        data.sort(key=lambda x: x["start"]) # 여행 시작 날짜순으로 정렬
        return jsonify({"schedules": data}) # josn 형식의 데이터를 반환합니다.
        

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
        
"""
place
"""

# 여행지 추가 (C)
@api.route('/api/place/create')
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
@api.route('/api/place/read/<int:sid>')
class ReadPlace(Resource):
    def get(self, sid):
        sql = f"select * from place where sid = {sid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn
        data.sort(key=lambda x: x["visit_date"]) # 방문 날짜순으로 정렬

        return jsonify({"places": data})

## uid로 여행지 조회
@api.route('/api/places/read/<int:uid>')
class ReadPlaces(Resource):
    def get(self, uid):
        sql = f"select * from place where uid = {uid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn
        data.sort(key=lambda x: x["visit_date"]) # 방문 날짜순으로 정렬

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
        
"""
spending
"""

# 지출 내역 추가 (C)
## JSON 배열로 전달됨
@api.route('/api/spending/create')
class CreateSpending(Resource):
    def post(self):
        spendings = (request.json.get('spendings'))

        for spending in spendings:
            name = (spending['name'])
            quantity = (spending['quantity'])
            price = (spending['price'])
            pid = (spending['pid'])

            sql = f"insert into spending(name, quantity, price, pid) values('{name}', {quantity}, {price}, {pid})"
            conn = connect.ConnectDB(sql)
            conn.execute()

        del conn

# 지출 내역 읽기 (R)
@api.route('/api/spending/read/<int:pid>')
class ReadSpending(Resource):
    def get(self, pid):
        sql = f"select * from spending where pid={pid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn

        return jsonify({"spendings": data})

# 지출 내역 삭제 (D)
@api.route('/api/spending/delete/<int:spid>')
class DeleteSpending(Resource):
    def get(self, spid):
        sql = f"delete from spending where spid={spid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn

"""
category
"""

# 사진에 대한 카테고리 생성 (C)
        
# 사진의 카테고리 가져오기 (R)
@api.route('/api/categories/read/<int:phid>')  
class ReadCategories(Resource):
    def get(self, phid):
        sql = f"select * from category where phid = {phid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"categories": data}) # josn 형식의 데이터를 반환합니다.
    
# 사진의 카테고리 업데이트 (U)
        
# 사진의 카테고리 삭제하기 (D)
@api.route('/api/categories/delete/<int:phid>')  
class DeleteCategories(Resource):
    def get(self, phid):
        sql = f"delete from category where phid = {phid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

if __name__ == '__main__':
    app.run('0.0.0.0', port=5000, debug=True) 