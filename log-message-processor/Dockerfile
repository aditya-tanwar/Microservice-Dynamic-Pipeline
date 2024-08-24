FROM python:3.6-alpine AS build 

WORKDIR /usr/src/app

RUN apk add --no-cache build-base

COPY requirements.txt main.py . 

RUN pip3 install -r requirements.txt


FROM python:alpine3.19

COPY --from=build  /usr/src/app/main.py .


CMD ["python3","-u","main.py"]

