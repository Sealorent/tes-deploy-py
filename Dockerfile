# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get install -y \
        cmake \
        build-essential \
        libopenblas-dev \
        liblapack-dev \
        libjpeg-dev \
        zlib1g-dev \
        libgl1 \
        libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies with Poetry
RUN poetry install --no-dev

# Command to run the Flask application with Gunicorn using Poetry
CMD ["poetry", "run", "gunicorn", "api.index:app"]
