# Markdown to Image API (md2img)

English | [简体中文](./README-zh.md)

This is a FastAPI-based microservice that converts Markdown content into beautiful, high-quality images. It uses `uv` for environment management, `markdown` for parsing, Jinja2 for HTML templating with GitHub-like styles, and Playwright for rendering the actual screenshots in a headless Chromium browser.

## AIGC Statement

This project was built with collaboration of Google Gemini 3.1 Pro, in Antigravity.

## Features

- **Markdown Support:** Full support for Markdown including tables, code blocks, and blockquotes.
- **Theming:** Built-in `light` and `dark` themes.
- **Customization:** Add custom headers and footers to your generated images.
- **Responsive Width:** Define the pixel width of the generated image to control how text wraps.
- **Containerized:** Ready-to-use `Dockerfile` and `docker-compose.yml` for easy deployment.

## Requirements

- Python 3.13+
- `uv` (Fast Python package installer and resolver)
- Docker & Docker Compose (for containerized deployment)

## Getting Started

### 1. Docker Compose (Recommended)

Docker Compose is the easiest way to run the service using the pre-built image from GitHub Container Registry.

1. Ensure you have Docker Compose installed. You don't need to clone the entire repository.
2. Download the `docker-compose.yml` file:
   ```bash
   curl -O https://raw.githubusercontent.com/Nemo1166/md2img/refs/heads/master/docker-compose.yml
   ```

3. Start the container:
   ```bash
   docker compose up -d
   ```

### 2. Local Development (uv)

If you wish to run the app directly on your host machine:

1. Clone the repository:
   ```bash
   git clone https://github.com/nemo1166/md2img.git
   cd md2img
   cp .env.example .env
   ```

2. Install dependencies using [uv](https://github.com/astral-sh/uv):
   ```bash
   uv sync
   uv run playwright install --with-deps chromium
   ```

3. Run the development server:
   ```bash
   uv run uvicorn main:app --host 0.0.0.0 --port 3921 --reload
   ```

### API Usage

The service exposes a `POST` endpoint at `/api/generate_image`. It returns a JSON object containing the URL of the generated image.

#### Endpoint
`POST /api/generate_image`

#### Payload (JSON)

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `content` | string | Yes | | The markdown text to render. |
| `header` | string | No | `null` | Optional text to display at the top of the image. |
| `footer` | string | No | `null` | Optional text to display at the bottom of the image. |
| `theme` | string | No | `"light"` | The visual theme (`"light"` or `"dark"`). |
| `width` | integer | No | `800` | The width of the image in pixels. |

#### Example Request

```bash
curl -X POST http://localhost:3921/api/generate_image \
  -H "Content-Type: application/json" \
  -d '{
    "content": "# Hello World\n\nThis is a beautiful **Markdown** rendering API.\n\n```python\nprint(\"Hello, Python!\")\n```",
    "header": "Daily Report",
    "footer": "Generated automatically by md2img",
    "theme": "dark",
    "width": 800
  }'
```

#### Example Response
```json
{
  "url": "http://localhost:3921/public/4b998cfbba4444cda019808a3dcb5380.png"
}
```

## Directory Structure

- `main.py`: The core FastAPI application and Playwright image rendering logic.
- `template.html`: Jinja2 template dictating the CSS layout and typography.
- `public/`: The directory where generated `.png` screenshots are stored and mounted statically.
- `Dockerfile`: Container image build instructions.
- `docker-compose.yml`: Compose definitions to run the application with volume mappings.
- `.env.example`: Example environment variables configuration file.
