from flask import Flask, request, jsonify
from flask_restx import Api, Resource, Namespace
import connect

Spending = Namespace('Spending')


# 지출 내역 추가 (C)
## JSON 배열로 전달됨
@Spending.route('/api/spending/create')
class CreateSpending(Resource):
    def post(self):

        pid = (request.json.get('pid'))
        spendings = (request.json.get('spendings'))
        
        sql = f"delete from spending where pid={pid}"
    
        conn = connect.ConnectDB(sql)
        conn.execute()

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
@Spending.route('/api/spending/read/<int:pid>')
class ReadSpending(Resource):
    def get(self, pid):
        sql = f"select * from spending where pid={pid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn

        return jsonify({"spendings": data})

# 지출 내역 삭제 (D)
@Spending.route('/api/spending/delete/<int:spid>')
class DeleteSpending(Resource):
    def get(self, spid):
        sql = f"delete from spending where spid={spid}"
        conn = connect.ConnectDB(sql)
        conn.execute()
        data = conn.fetch()
        del conn