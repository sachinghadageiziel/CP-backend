# Dockerfile
FROM python:3.12-slim

# set working dir
WORKDIR /app

# system deps (needed by some PDF/Doc packages)
RUN apt-get update && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    libjpeg62-turbo-dev \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# copy dependency list and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy application code
COPY . .

# create outputs folder with full access
RUN mkdir -p /app/outputs && chmod -R 777 /app/outputs

EXPOSE 8000

# start uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
