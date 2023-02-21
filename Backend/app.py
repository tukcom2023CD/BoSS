from flask import Flask, request, jsonify
from flask_restx import Api, Resource
from s3 import s3_access_key as ak
from s3 import s3_connect as sc
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
        if len(data) != 0:
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
        if len(data) != 0:
            data.sort(key=lambda x: x["visit_date"]) # 방문 날짜순으로 정렬

        return jsonify({"places": data})

## uid로 여행지 조회
@api.route('/api/places/read/<int:uid>')
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

'''
photo
'''
@api.route('/api/photo/create/<int:uid>/<int:sid>/<int:pid>')
class CreatePhoto(Resource):
    def post(self, uid, sid, pid):
        # 바디에 포함된 파일을 가져옴
        file_object = request.files['file']
        
        # 원본 파일이름 가져옴
        file_name = file_object.filename
        
        # 이미지 임시 저장 경로 -> 서버 컴퓨터에 따라 적절한 경로 지정
        save_image_dir = f"/Users/jun/Desktop/무제 폴더/{file_name}"
        
        # 파일 저장
        file_object.save(save_image_dir)
        
        # 빈 url 을 가진 photo 레코드 생성
        sql = f"insert into photo (uid, pid) values ({uid}, {pid})"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        
        # 해당 uid, pid 를 가지는 photo 레코드들중 가장 큰 phid 값을 리턴
        sql = f"select MAX(phid) from photo where uid = {uid} and pid = {pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # 쿼리문 결과 데이터를 가져옵니다.
        phid = (data[0]['MAX(phid)']) # 리스트안의 딕셔너리의 키 MAX(phid)로 값을 가져옴
        del conn # DB와 연결을 해제합니다.
        
        # s3에 저장할 파일 이름 설정
        s3_file_name = f"{uid}/{sid}/{pid}/{phid}.jpeg"
    
        # 해당 uid, pid, phid 값을 이름으로 갖는 이미지를 s3에 저장 
        s3 = sc.s3_connection() # s3 객체 생성
        # 파일 업로드 함수 호출
        put = sc.s3_put_object(s3, ak.bucket_name(), save_image_dir, s3_file_name)
        # 파일 url 얻는 함수 호출
        get = sc.s3_get_image_url(s3, s3_file_name)

        # url 저장
        sql = f"update photo set url = '{get}' where phid = {phid}" # sql문 
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        
        # 이미지 url 바로 열기
        # url = get
        # webbrowser.open(url)
        
# 사진 url 가져오기 (R) -> 특정 유저의 전체 사진
@api.route('/api/photo/read/<int:uid>')  
class ReadPhotosWithUid(Resource):
    def get(self, uid):
        sql = f"select * from photo where uid = {uid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"url": data}) # josn 형식의 데이터를 반환합니다.

# 사진 url 가져오기 (R) -> 특정 유저의, 특정 장소의 사진
@api.route('/api/photo/read/<int:uid>/<int:pid>')  
class ReadPhotoswithUidAndPid(Resource):
    def get(self, uid, pid):
        sql = f"select * from photo where uid = {uid} and pid = {pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"url": data}) # josn 형식의 데이터를 반환합니다.
    
# 사진 url 가져오기 (R) -> 특정 유저의, 특정 카테고리 사진
@api.route('/api/photo/read/<int:uid>/<string:category>')  
class ReadPhotosWithUidAndCategory(Resource):
    def get(self, uid, category):
        sql = f"select * from (SELECT uid, photo.phid, category_name, url FROM photo, category where photo.phid = category.phid) as test where uid = {uid} and category_name = '{category}'"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"url": data}) # josn 형식의 데이터를 반환합니다.
    
# 사직 삭제 (D) -> 특정 사진만 삭제
@api.route('/api/photo/delete/<int:uid>/<int:pid>/<int:phid>')  
class DeletePhotoOne(Resource):
    def get(self, uid, pid, phid):
        sql = f"delete from photo where pid = {phid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        s3 = sc.s3_connection() # s3 객체 생성
        # s3 에서 이미지 삭제
        delete = sc.s3_delete_file(s3, ak.bucket_name(), f"{uid}/{pid}/{phid}.png")
        
# 사직 삭제 (D) -> 해당 장소의 모든 사진 삭제
@api.route('/api/photo/delete/<int:uid>/<int:pid>')  
class DeletePhotoWithPlace(Resource):
    def get(self, uid, pid):
        sql = f"delete from photo where uid = {uid} and pid = {pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        s3 = sc.s3_connection() # s3 객체 생성
        # 특정 장소에 대응되는 s3 디렉토리 경로에 포함되는 모든 파일의 Key값 리스트 반환
        keys = sc.s3_get_file_list(s3, ak.bucket_name(), f"{uid}/{pid}")
        # s3 에서 이미지 삭제
        delete = sc.s3_delete_files(s3, ak.bucket_name(), keys)
        
# 사직 삭제 (D) -> 해당 스케줄의 모든 사진 삭제
@api.route('/api/photo/delete/<int:uid>/<int:schedule>/<int:pid>')  
class DeletePhotoWithSchedule(Resource):
    def get(self, uid, sid, pid):
        sql = f"delete from photo where uid = {uid} and pid = {pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        s3 = sc.s3_connection() # s3 객체 생성
        # 특정 장소에 대응되는 s3 디렉토리 경로에 포함되는 모든 파일의 Key값 리스트 반환
        keys = sc.s3_get_file_list(s3, ak.bucket_name(), f"{uid}/{sid}")
        # s3 에서 이미지 삭제
        delete = sc.s3_delete_files(s3, ak.bucket_name(), keys)
        
# 사직 삭제 (D) -> 유저의 모든 사진 삭제
@api.route('/api/photo/delete/<int:uid>')  
class DeletePhotoWithUser(Resource):
    def get(self, uid):
        sql = f"delete from photo where uid = {uid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        s3 = sc.s3_connection() # s3 객체 생성
        # 특정 장소에 대응되는 s3 디렉토리 경로에 포함되는 모든 파일의 Key값 리스트 반환
        keys = sc.s3_get_file_list(s3, ak.bucket_name(), f"{uid}")
        # s3 에서 이미지 삭제
        delete = sc.s3_delete_files(s3, ak.bucket_name(), keys)

if __name__ == '__main__':
    app.run('0.0.0.0', port=5001, debug=True) 