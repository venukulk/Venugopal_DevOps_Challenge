FROM python:slim

WORKDIR /app
COPY ./src/ .
COPY requirements.txt /app/

RUN pip3 install -r /app/requirements.txt
EXPOSE 5000

CMD ["python3", "/app/app.py"]
