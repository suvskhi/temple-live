
FROM oven/bun:1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-pip \
    curl \
    build-essential \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.local/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV OMP_NUM_THREADS=3
ENV OMP_WAIT_POLICY=PASSIVE
ENV MKL_NUM_THREADS=3

COPY package.json package-lock.json ./
RUN bun install

COPY . .

RUN uv venv .venv \
    && uv pip install --python .venv/bin/python zerotts pillow

EXPOSE 3000

CMD ["bun", "start"]
