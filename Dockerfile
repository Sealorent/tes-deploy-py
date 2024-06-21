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
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgtk-3-dev \
        v4l-utils \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libtbb2 \
        tini \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN adduser -u 5678 --disabled-password --gecos "" appuser && \
    adduser appuser video && \
    chown -R appuser /app

# Switch to the non-root user
USER appuser

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install gunicorn

# Expose port 5000 for the Flask application
EXPOSE 5000

# Use tini as the init process
ENTRYPOINT ["tini", "-g", "--"]

# Command to run the Flask application with Gunicorn
CMD ["gunicorn", "api.index:app"]
