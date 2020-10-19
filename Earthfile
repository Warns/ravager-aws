FROM python:3.8-slim

# Set working directory
WORKDIR /app

# Set environment variables
# Prevents Python from writing pyc files to disc (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

deps:
    RUN pip install --upgrade pip
    COPY ./requirements.txt .
    RUN pip install -r requirements.txt
    SAVE IMAGE

build:
    FROM +deps
    COPY ./src .
    SAVE ARTIFACT src /src

docker:
    COPY +build/src src
    COPY requirements.txt ./
    RUN pip install --no-index -r requirements.txt
