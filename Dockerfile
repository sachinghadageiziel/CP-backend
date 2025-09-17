# -------------------------
# Dockerfile - FastAPI backend (Render-ready)
# -------------------------

FROM python:3.12-slim

# set working dir
WORKDIR /app

# system deps (needed by PDF/Doc packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# optionally create non-root user (safer for production)
# RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
# USER appuser

# expose port (Render assigns $PORT at runtime)
EXPOSE 8000

# use Render's dynamic PORT environment variable
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
