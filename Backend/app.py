from flask import Flask, request, jsonify
from flask_restx import Api, Resource
from s3 import s3_access_key as ak
from s3 import s3_connect as sc
import connect
from api import user, schedule, place, spending, photo, category

# flask 객체를 생섭합니다.
app = Flask(__name__)

# Api 객체를 생성합니다. 
api = Api(app)

api.add_namespace(user.User, '/')
api.add_namespace(schedule.Schedule, '/')
api.add_namespace(place.Place, '/')
api.add_namespace(spending.Spending, '/')
api.add_namespace(photo.Photo, '/')
api.add_namespace(category.Category, '/')


if __name__ == '__main__':
    app.run('0.0.0.0', port=5001, debug=True) 