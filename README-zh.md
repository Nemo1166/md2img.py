# Markdown to Image API (md2img)

[English](./README.md) | 简体中文

这是一个基于 FastAPI 开发的微服务，能够将 Markdown 文本转换为精美、高质量的图片。本项目使用 `uv` 进行环境管理，使用 `markdown` 库进行解析，通过 Jinja2 配合类 GitHub 的样式进行 HTML 渲染，并使用 Playwright 在无头 Chromium 浏览器中进行最终截图。

## AIGC 声明

本项目由 Google Gemini 3.1 Pro 协助，在 Antigravity 平台合作构建。

## 功能特性

- **Markdown 支持：** 完全支持 Markdown 语法，包括表格、代码块以及引用。
- **主题切换：** 内置 `light` (明亮) 和 `dark` (暗黑) 两种主题。
- **高度定制化：** 可以在生成的图片顶部和底部添加自定义的头部 (header) 和尾部 (footer) 文本。
- **响应式宽度：** 可以定义生成图片的像素宽度，文字会自动适应换行。
- **容器化部署：** 提供现成的 `Dockerfile` 和 `docker-compose.yml`，方便快捷部署。

## 环境要求

- Python 3.13+
- `uv` (快速的 Python 包管理和解析工具)
- Docker & Docker Compose (用于容器化部署)

## 快速开始

### 1. Docker Compose (推荐)

使用 Docker Compose 是运行该服务最简单的方法，它将直接从 GitHub Container Registry 拉取预构建好的镜像。

1. 确保已安装 Docker Compose。您无需克隆整个代码仓库。
2. 下载 `docker-compose.yml` 文件：
   ```bash
   curl -O https://raw.githubusercontent.com/Nemo1166/md2img/main/docker-compose.yml
   ```

3. (可选) 在同级目录下创建一个 `.env` 文件来自定义端口：
   ```bash
   # .env
   APP_PORT=3921
   ```

4. 启动容器：
   ```bash
   docker compose up -d
   ```

### 2. 本地开发 (uv)

如果您希望直接在宿主机上运行此应用：

1. 克隆基于 Git 的代码仓库：
   ```bash
   git clone https://github.com/nemo1166/md2img.git
   cd md2img
   cp .env.example .env
   ```

2. 使用 [uv](https://github.com/astral-sh/uv) 安装依赖项：
   ```bash
   uv sync
   uv run playwright install --with-deps chromium
   ```

3. 启动开发服务器：
   ```bash
   uv run uvicorn main:app --host 0.0.0.0 --port 3921 --reload
   ```

### API 使用指南

该服务暴露了一个 `POST` 接口：`/api/generate_image`。调用成功后，会返回包含生成图片 URL 的 JSON 对象。

#### 接口端点
`POST /api/generate_image`

#### 请求参数 Payload (JSON)

| 参数名 | 类型 | 必填 | 默认值 | 描述 |
|-----------|------|----------|---------|-------------|
| `content` | string | 是 | | 需要渲染的 markdown 原文文本。 |
| `header` | string | 否 | `null` | 可选文本，显示在图片顶部。 |
| `footer` | string | 否 | `null` | 可选文本，显示在图片底部。 |
| `theme` | string | 否 | `"light"` | 图片视觉主题（可选 `"light"` 或 `"dark"`）。 |
| `width` | integer | 否 | `800` | 图片的像素宽度。 |

#### 请求示例

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

#### 响应示例
```json
{
  "url": "http://localhost:3921/public/4b998cfbba4444cda019808a3dcb5380.png"
}
```

## 目录结构

- `main.py`：核心 FastAPI 应用和 Playwright 图片渲染逻辑。
- `template.html`：定义页面 CSS 布局和排版的 Jinja2 模板。
- `public/`：存放并静态挂载生成的 `.png` 截图的目录。
- `Dockerfile`：容器镜像的构建指令。
- `docker-compose.yml`：基于包含挂载声明的 Compose 定义文件。
- `.env.example`：示例环境变量配置文件。
