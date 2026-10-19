# syntax=docker/dockerfile:1
# check=error=true;experimental=all

FROM python:3.14-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN useradd -m botuser && mkdir -p /home/botuser/data
WORKDIR /home/botuser

COPY pyproject.toml /home/botuser/pyproject.toml
COPY README.md /home/botuser/README.md
RUN uv sync --no-dev

COPY interactions /home/botuser/interactions
COPY discord_reminder_bot /home/botuser/discord_reminder_bot

ENV DATA_DIR=/home/botuser/data
ENV SQLITE_LOCATION=/data/jobs.sqlite
CMD ["uv", "run", "python", "-m", "discord_reminder_bot.main"]
