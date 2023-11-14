FROM python:3.9-alpine

WORKDIR /flask_app

COPY requirements.txt .

RUN apk --no-cache add build-base libffi-dev openssl-dev
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install pytest

COPY app/ .
COPY tests/ app/tests/

ENV FLASK_APP=app.py
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
