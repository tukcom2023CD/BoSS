from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
from s3 import s3_access_key as ak
from s3 import s3_connect as sc
import connect
from yolov5 import yolov5


Photo = Namespace('Photo')


@Photo.route('/api/photo/create/<int:uid>/<int:sid>/<int:pid>')
class CreatePhoto(Resource):
    def post(self, uid, sid, pid):
        
        # 바디에 포함된 파일들을 가져옴
        file_objects = request.files
        
        # 각 파일들에 접근
        for field_name in file_objects : 
            file = request.files[field_name] # 필드이름으로 각 파일을 받음
        
            # 파일이름 저장
            file_name = file.filename
    
            # 이미지 임시 저장 경로 -> 서버 컴퓨터에 따라 적절한 경로 지정
            save_image_dir = f"/app/images/{file_name}"

            # 파일 저장
            file.save(save_image_dir)
            
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
            
            # 사진에대한 객체탐지후 DB 저장
            path = save_image_dir # 사진 저장 경로
            categoryArray = [] # 탐지된 카테고리 저장 배열
            categoryArray = yolov5.model(path) # yolov5 모델로 해당 사진의 객체 탐지후 저장
            
            # 탐지된 객체가 없는 경우
            if categoryArray == [] :
                categoryArray.append("기타")
            
            # 각 카테고리 DB 저장
            for category_name in categoryArray :
                sql = f"insert into category (phid, category_name) values ({phid}, '{category_name}')"
                conn = connect.ConnectDB(sql) # DB와 연결합니다.
                conn.execute() # sql문 수행합니다.
                del conn # DB와 연결을 해제합니다.
        
# test 사진 데이터 삽입
@Photo.route('/api/photo/create/<int:uid>')  
class CreateTestPhotosWithUid(Resource):
    def get(self, uid):
        for x in range(1, 100) :
            url =  f"https://picsum.photos/id/{x}/300"
            sql = f"insert into photo (uid, pid, url) values ({uid}, 1, '{url}')"
            conn = connect.ConnectDB(sql) # DB와 연결합니다.
            conn.execute() # sql문 수행합니다.
            data = conn.fetch() # json 형식의 데이터를 가져옵니다.
            del conn # DB와 연결을 해제합니다. 

# 사진 url 가져오기 (R) -> 특정 유저의 전체 사진
@Photo.route('/api/photo/read/<int:uid>')  
class ReadPhotosWithUid(Resource):
    def get(self, uid):
        sql = f"select * from photo where uid = {uid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"url": data}) # josn 형식의 데이터를 반환합니다.

# 사진 url 가져오기 (R) -> 특정 유저의, 특정 장소의 사진
@Photo.route('/api/photo/read/<int:uid>/<int:pid>')  
class ReadPhotoswithUidAndPid(Resource):
    def get(self, uid, pid):
        sql = f"select * from photo where uid = {uid} and pid = {pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"url": data}) # josn 형식의 데이터를 반환합니다.
    
# 사진 url 가져오기 (R) -> 특정 유저의, 특정 카테고리 사진
@Photo.route('/api/photo/read/<int:uid>/<string:category>')  
class ReadPhotosWithUidAndCategory(Resource):
    def get(self, uid, category):
        sql = f"select * from (SELECT uid, photo.phid, category_name, url FROM photo, category where photo.phid = category.phid) as test where uid = {uid} and category_name = '{category}'"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"url": data}) # josn 형식의 데이터를 반환합니다.
    
# 사직 삭제 (D) -> 특정 사진만 삭제
@Photo.route('/api/photo/delete/<int:uid>/<int:pid>/<int:phid>')  
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
@Photo.route('/api/photo/delete/<int:uid>/<int:pid>')  
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
@Photo.route('/api/photo/delete/<int:uid>/<int:schedule>/<int:pid>')  
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
@Photo.route('/api/photo/delete/<int:uid>')  
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
