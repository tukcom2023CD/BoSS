from flask import Flask, request, jsonify
from flask_restx import Api, Resource
import connect

# @app.route("/")

# flask 객체를 생섭합니다.
app= Flask(__name__)

# Api 객체를 생성합니다. 
api= Api(app)

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