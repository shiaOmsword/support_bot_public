FROM python:3.12-slim

WORKDIR /app

# asyncpg часто требует сборку (gcc) и libpq
#RUN apt-get update && apt-get install -y --no-install-recommends \
#    gcc \
#    libpq-dev \
#    && rm -rf /var/lib/apt/lists/*

# зависимости
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# код
COPY . /app

# по умолчанию запускаем бота
CMD ["python", "main.py"]
