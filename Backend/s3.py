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
            # ExtraArgs={"ContentType": "image/png"}
        )
    except Exception as e:
        print("fail! : " + f"{e}")
        return False
    print("suceess!")
    return True


# 파일 url 얻기
def s3_get_image_url(s3, filename):
    location = s3.get_bucket_location(Bucket=ak.bucket_name())["LocationConstraint"]
    return f"https://{ak.bucket_name()}.s3.{location}.amazonaws.com/{filename}"


# s3 객체 생성
s3 = s3_connection()

# 원격 파일 생성을 위한 uid, phid 값
uid = "uid" # uid 값 넣기
phid = "phid" # phid 값 넣기

# 파일 업로드 함수 호출
put = s3_put_object(s3, ak.bucket_name(), '/Users/jun/Desktop/Swift/Swift_Icon.png', f"{uid}/{phid}")

# 파일 url 얻는 함수 호출
get = s3_get_image_url(s3, f"{uid}/{phid}")

print(get)