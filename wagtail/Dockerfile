# Use an official Python runtime based on Debian 10 "buster" as a parent image.
FROM python:3.8.1-slim-buster

# Add user that will be used in the container.
RUN useradd wagtail

# Port used by this container to serve HTTP.
EXPOSE 8000

# Set environment variables.
# 1. Force Python stdout and stderr streams to be unbuffered.
# 2. Set PORT variable that is used by Gunicorn. This should match "EXPOSE"
#    command.
ENV PYTHONUNBUFFERED=1 \
    PORT=8000

# Install system packages required by Wagtail and Djangod.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    build-essential \
		libpq-dev \
		libmariadbclient-dev \
    libjpeg62-turbo-dev \
		zlib1g-dev \
		libwebp-dev \
		&& rm -rf /var/lib/apt/lists/*

# To satisfy debconf: delaying package configuration, since apt-utils is not installed
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install the application server.
RUN pip install "gunicorn==20.0.4"
RUN pip install twine

# Install the project requirements.
COPY requirements.txt /
RUN pip install -r /requirements.txt

# Use /app folder as a directory where the source code is stored.
WORKDIR /app
