FROM python:3.12-slim-bookworm

# Install System Dependencies 
RUN apt-get update && apt-get install -y \
    runit \
    nginx \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /app/.cache

# Add Tini
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]

# Set Working Directory
WORKDIR /usr/src/

# Copy Project
COPY . /usr/src/

# Install Poetry
ENV POETRY_VERSION=1.8.0
RUN pip install "poetry==$POETRY_VERSION"

# Install Dependencies
ENV POETRY_VIRTUALENVS_CREATE=false
RUN poetry install --no-dev --no-interaction --no-ansi

# Gunicorn service
COPY docker/gunicorn.service /etc/service/gunicorn

# Nginx service
COPY docker/nginx.service /etc/service/nginx
COPY docker/nginx.conf /nginx/
COPY docker/mime.types /nginx/
COPY docker/headers.conf /nginx/

RUN chmod -R +x /etc/service

EXPOSE 80

CMD ["runsvdir", "/etc/service"]
