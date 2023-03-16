FROM python:3.9.0

WORKDIR /app

# COPY requirements.txt requirements.txt
COPY . .

RUN apt-get update
RUN apt-get -y install libgl1-mesa-glx

RUN pip install pillow

RUN pip install -r requirements.txt

RUN pip install celery

RUN mkdir -p /app/images

# RUN chmod +x wait-for.sh

# ENTRYPOINT ["./wait-for.sh", "db:3306", "--", "python", "app.py"]

# COPY . .

CMD ["python", "app.py"]


