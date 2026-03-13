FROM python:3.13-slim

WORKDIR /app

# 1. Infrastructure
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg fontconfig \
    && rm -rf /var/lib/apt/lists/*

# 2. uv
RUN pip install --no-cache-dir uv

# 3. Python dependencies
COPY pyproject.toml ./
RUN uv pip install --system fastapi uvicorn 'markdown[extra]' playwright jinja2 python-multipart python-dotenv

# 4. Playwright browsers
RUN playwright install --with-deps chromium

# 5. Fonts
COPY HarmonyOS_Sans_SC /usr/share/fonts/HarmonyOS_Sans_SC/
RUN fc-cache -fv

# 6. Copy application code
COPY main.py template.html ./
RUN mkdir -p public

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]