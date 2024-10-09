
FROM python:3.9-slim

RUN pip3 install --upgrade pip
RUN pip3 install poetry

RUN apt-get update \
     && apt-get install \
     ca-certificates \
     gcc \
     bash \
     curl \
     musl-dev \
     libffi-dev \
     git \
     g++ -y

# add g++ because greenlet needs it (imported by sqlalchemy 1.4)

WORKDIR /app
COPY pyproject.toml poetry.lock /app

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
COPY . .
RUN poetry install -vvv



ENTRYPOINT ["poetry", "run", "data-simulator", "submitting_data", "--host=https://heal.krum.app", "--project=sim/GEN", "--dir=./simulated/GEN/1/", "--access_token_file=./token", "--chunk_size=1"]