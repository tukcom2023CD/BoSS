from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
import connect


Category = Namespace('Category')

# 사진에 대한 카테고리 생성 (C)
        
# 카테고리 종류 가져오기 (R)
@Category.route('/api/categorytype/read')  
class ReadCategortType(Resource):
    def get(self):
        sql = f"select DISTINCT category_name from category" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"categoryTypes": data}) # josn 형식의 데이터를 반환합니다.
    
# 사진의 카테고리 가져오기 (R)
@Category.route('/api/categories/read/<int:phid>')  
class ReadCategories(Resource):
    def get(self, phid):
        sql = f"select * from category where phid = {phid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        data = conn.fetch() # json 형식의 데이터를 가져옵니다.
        del conn # DB와 연결을 해제합니다.
        return jsonify({"categories": data}) # josn 형식의 데이터를 반환합니다.
    
# 사진의 카테고리 업데이트 (U)
@Category.route('/api/categories/update')  
class UpdateCategories(Resource):
    def poset(self):
        phid = (request.json.get('phid')) # json 데이터에서 sid 값을 저장합니다.
        category_name = (request.json.get('category_name')) # json 데이터에서 title 값을 저장합니다.
        
        sql = f"update category set category_name ='{category_name}' where phid = {phid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.
  
# 사진의 카테고리 삭제하기 (D)
@Category.route('/api/categories/delete/<int:phid>')  
class DeleteCategories(Resource):
    def get(self, phid):
        sql = f"delete from category where phid = {phid}" # sql문을 생성합니다.
        conn = connect.ConnectDB(sql) # DB와 연결합니다.
        conn.execute() # sql문 수행합니다.
        del conn # DB와 연결을 해제합니다.