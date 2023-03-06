import time
import random
import connect
from celery import Celery


celery = Celery('tasks', broker='amqp://user:password@rabbitmq:5672//', backend='rpc://')

@celery.task
def working(name, email):
    
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