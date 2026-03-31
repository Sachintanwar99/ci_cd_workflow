# FROM python:3.11-slim

# WORKDIR /app

# # Copy requirements
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy full project
# COPY . .

# # Run tests
# CMD ["pytest", "-v"]


# ---------- Stage 1: Builder ----------
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies (if any package needs compilation)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install into a separate folder
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ---------- Stage 2: Final ----------
FROM python:3.11-slim

WORKDIR /app

# Copy only installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy project files
COPY . .

# Run tests
CMD ["pytest", "-v"]