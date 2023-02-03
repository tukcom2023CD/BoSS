import boto3
import s3_access_key as ak

# s3 연동
def s3_connection():
    try:
        # s3 객체 생성
        s3 = boto3.client(
            service_name = "s3", 
            region_name = "ap-northeast-2", 
            aws_access_key_id = ak.access_key_id(), 
            aws_secret_access_key = ak.access_secret_key(), 
        )
    except Exception as e:
        print(e)
    else:
        print("s3 bucket connected!")
        return s3

# s3 파일 업로드 
def s3_put_object(s3, bucket, local_file, remote_file):
    try:
        s3.upload_file(
            local_file,
            bucket,
            remote_file,
            ExtraArgs={"ContentType": "image/jpeg"} # 컨텐트 타입 설정 -> url을 통해 이미지를 바로 열 수 있음
        )
    except Exception as e:
        print("fail! : " + f"{e}")
        return False
    print("upload suceess!")
    return True

# s3 한개 파일 삭제
def s3_delete_file(s3, bucket, key) :
    try :
        s3.delete_object(Bucket = bucket, Key = key)
    except Exception as e:
        print("fail! : " + f"{e}")
        return False
    print("delete suceess!")
    return True

# s3 여러개 파일 삭제
def s3_delete_files(s3, bucket, keys) :
    try :
        s3.delete_objects (
            Bucket = bucket, 
            Delete = {
                'Objects' : keys
            }
        )
    except Exception as e:
        print("fail! : " + f"{e}")
        return False
    print("delete suceess!")
    return True
    
# 특정 경로의 파일리스트 얻기
def s3_get_file_list (s3, bucket, prefix) :
    # 특정 버킷에서 특정 경로에 해당하는 파일 리스트를 가져옴
    file_list = s3.list_objects(Bucket = bucket, Prefix = prefix)
    # 파일 리스트에서 Contents를 가져옴
    file_contents = file_list['Contents']
    # Contents에서 각 파일의 Key 값을 새로운 리스트에 저장
    file_key_list = [] # 각 파일의 Key값들을 저장할 리스트
    for content in file_contents :
        key = content['Key'] # Key값 저장
        file_key_list.append({'Key' : key}) # Key값을 딕셔너리 형대로 리스트에 추가
    return file_key_list
    
# 파일 url 얻기
def s3_get_image_url(s3, filename):
    location = s3.get_bucket_location(Bucket=ak.bucket_name())["LocationConstraint"]
    return f"https://{ak.bucket_name()}.s3.{location}.amazonaws.com/{filename}"

# 특정 경로의 파일리스트 얻기
def s3_get_file_list2 (s3, bucket, prefix) :
    # 특정 버킷에서 특정 경로에 해당하는 파일 리스트를 가져옴
    file_list = s3.list_objects(Bucket = bucket, Prefix = prefix)
    # # 파일 리스트에서 Contents를 가져옴
    file_contents = file_list['Contents']
    # Contents에서 각 파일의 Key 값을 새로운 리스트에 저장
    file_key_list = [] # 각 파일의 Key값들을 저장할 리스트
    for content in file_contents :
        key = content['Key'] # Key값 저장
        file_key_list.append({'Key' : key}) # Key값을 딕셔너리 형대로 리스트에 추가
    return file_key_list
