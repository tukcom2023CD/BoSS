from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
from s3 import s3_access_key as ak
from s3 import s3_connect as sc
import connect
from AI import yolov5
import celery_task
from threading import Thread

# 빈 url photo 레코드 생성 함수
def createPhotoRecord(uid, pid) :
    # 빈 url 을 가진 photo 레코드 생성
    sql = f"insert into photo (uid, pid) values ({uid}, {pid})"
    print("레코드 생성")
    conn = connect.ConnectDB(sql) # DB와 연결합니다.
    conn.execute() # sql문 수행합니다.
    del conn # DB와 연결을 해제합니다.
    
# 이미지 저장 함수
def downloadImages(file, phidArray, index) :
    # 파일이름 설정
    file_name = str(phidArray[index]) + ".jpg"
    # 이미지 임시 저장 경로 -> 서버 컴퓨터에 따라 적절한 경로 지정
    save_image_dir = f"/app/images/{file_name}"
    # save_image_dir = f"/Users/jun/Desktop/무제 폴더/{file_name}"
    # 파일 저장
    file.save(save_image_dir)
    print("이미지 저장")
    
# s3 이미지 저장 함수
def s3UploadImages(phid, uid, sid, pid, s3) :    
    
    # 버킷이름 저장
    bucket_name = ak.bucket_name()
    
    # 이미지 저장 경로
    save_image_dir = f"/app/images/{phid}.jpg"
    # save_image_dir = f"/Users/jun/Desktop/무제 폴더/{phid}.jpg"

    # s3에 저장할 파일 이름 설정
    s3_file_name = f"{uid}/{sid}/{pid}/{phid}.jpg"
    
    # 해당 uid, pid, phid 값을 이름으로 갖는 이미지를 s3에 저장 
    # 파일 업로드 함수 호출
    put = sc.s3_put_object(s3, bucket_name, save_image_dir, s3_file_name)
    # 파일 url 얻는 함수 호출
    get = sc.s3_get_image_url(s3, s3_file_name)
            
    # url 저장
    sql = f"update photo set url = '{get}' where phid = {phid}" # sql문 
    conn = connect.ConnectDB(sql) # DB와 연결합니다.
    conn.execute() # sql문 수행합니다.
    del conn # DB와 연결을 해제합니다.
    
# 객체 탐지 함수
def detectObjects(phid) :
    # 사진 경로
    # save_image_dir = f"/Users/jun/Desktop/무제 폴더/{phid}.jpg"
    save_image_dir = f"/app/images/{phid}.jpg"
    # 사진에대한 객체탐지후 DB 저장
    categoryArray = [] # 탐지된 카테고리 저장 배열
    categoryArray = yolov5.model(save_image_dir) # yolov5 모델로 해당 사진의 객체 탐지후 저장
            
    # 탐지된 객체가 없는 경우
    if categoryArray == [] :
        categoryArray.append("기타")
            
    # 각 카테고리 DB 저장
    for category_name in categoryArray :
        sql = f"insert into category (phid, category_name) values ({phid}, '{category_name}')"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.

Photo = Namespace('Photo')

@Photo.route('/api/photo/create/<int:uid>/<int:sid>/<int:pid>')
class CreatePhoto(Resource):
    def post(self, uid, sid, pid):

        # 해당 장소에 해당하는 모든 장소 삭제
        sql = f"delete from photo where uid = {uid} and pid = {pid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        s3 = sc.s3_connection() # s3 객체 생성
        # 특정 장소에 대응되는 s3 디렉토리 경로에 포함되는 모든 파일의 Key값 리스트 반환
        keys = sc.s3_get_file_list(s3, ak.bucket_name(), f"{uid}/{pid}")
        # s3 에서 이미지 삭제
        delete = sc.s3_delete_files(s3, ak.bucket_name(), keys)
        
        # 바디에 포함된 파일들을 가져옴
        file_objects = request.files
        
        # 사진 수 계산
        fileCount = 0
        for field_name in file_objects : 
            fileCount += 1
            
        phidArray = [] # phid 저장할 배열
        
        createPhotoRecordThreadArray = [] # 쓰레드 저장하기 위한 배열
        # 사진 개수 만큼 빈 url을 가지는 photo 레코드 생성
        for i in range(0, fileCount) : 
            createPhotoRecordThreadArray.append(Thread(target = createPhotoRecord, args=(uid, pid,))) # 쓰레드 배열에 추가
            createPhotoRecordThreadArray[i].start()
        # 쓰레드 모든 종료시까지 메인은 대기
        for i in range(0, fileCount) : 
            createPhotoRecordThreadArray[i].join()
            
        # 해당 uid, pid 를 가지는 photo 레코드들중 가장 큰 phid 값 fileCount 개 리턴
        sql = f"select phid from photo where uid = {uid} and pid = {pid} order by phid desc limit {fileCount}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # 쿼리문 결과 데이터를 가져옵니다.
        for phid in data :
            phidArray.append(phid['phid'])
        phidArray.sort()
        del conn # DB와 연결을 해제합니다.
     
        # 리퀘스트 바디로부터 이미지 저장 
        downloadImagesThreadArray = [] # 쓰레드 저장하기 위한 배열
        index = -1 # phid 배열 접근하기 위한 인덱스
        for field_name in file_objects : 
            index += 1 # 1증가
            # 필드이름으로 각 파일을 받음
            file = file_objects[field_name] 
            # 이미지 다운로드 함수 멀티쓰레드로 호출
            downloadImagesThreadArray.append(Thread(target = downloadImages, args=(file, phidArray, index,))) # 쓰레드 배열에 추가
            downloadImagesThreadArray[index].start()
        # 쓰레드 모두 종료시까지 메인은 대기
        for i in range(0, fileCount) : 
            downloadImagesThreadArray[i].join()
        
        # s3 이미지 저장 및 url DB 저장
        s3UploadThreadArray = []
        s3 = sc.s3_connection() # s3 객체 생성
        index = 0
        for phid in phidArray :
            # 이미지 다운로드 함수 멀티쓰레드로 호출
            s3UploadThreadArray.append(Thread(target = s3UploadImages, args=(phid, uid, sid, pid, s3,))) # 쓰레드 배열에 추가
            s3UploadThreadArray[index].start()
            index += 1
        # 쓰레드 모든 종료시까지 메인은 대기
        for i in range(0, fileCount) : 
            s3UploadThreadArray[i].join()
        
        count = 1
        # 객체 탐지 (celery)
        for phid in phidArray :
            # 이미지 경로 설정
            path = f"/app/images/{phid}.jpg"
            # s3 객체 생성
            s3 = sc.s3_connection() 
            # s3 이미지 이름
            s3_file_name = f"{uid}/{sid}/{pid}/{phid}.jpg"
            # 이미지 url 값 받아오기
            url = sc.s3_get_image_url(s3, s3_file_name)
            # 객체 탐지 함수 호출 
            celery_task.working.delay(path, phid, url, count)
            count += 1
        
        # # 객체 탐지 (Thread)
        # detectObjectThreadArray = []
        # index = 0
        # for phid in phidArray :
        #     # 이미지 경로 설정
        #     detectObjectThreadArray.append(Thread(target= detectObjects, args=(phid,)))
        #     detectObjectThreadArray[index].start()
        #     index += 1
            
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
@Photo.route('/api/photo/delete/<int:uid>/<int:sid>/<int:pid>/<int:phid>')  
class DeletePhotoOne(Resource):
    def get(self, uid, sid, pid, phid):
        sql = f"delete from photo where phid = {phid}"
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
        s3 = sc.s3_connection() # s3 객체 생성
        # s3 에서 이미지 삭제
        delete = sc.s3_delete_file(s3, ak.bucket_name(), f"{uid}/{sid}/{pid}/{phid}.jpg")
        
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
