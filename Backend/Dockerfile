FROM python:3.9.0

WORKDIR /app

# COPY requirements.txt requirements.txt
COPY . .

RUN pip install -r requirements.txt

# RUN chmod +x wait-for.sh

# ENTRYPOINT ["./wait-for.sh", "db:3306", "--", "python", "app.py"]

# COPY . .

CMD ["python", "app.py"]


