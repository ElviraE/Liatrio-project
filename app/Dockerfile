FROM alpine:latest

RUN apk add --no-cache python3-dev \
    && apk add --no-cache py3-pip \
    && pip3 install --upgrade pip

COPY src /app

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip &&\
    pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

EXPOSE 5000

CMD ["python3", "app.py"]
