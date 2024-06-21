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
    && rm -rf /var/lib/apt/lists/*

# Grant access to the camera device
RUN usermod -a -G video root

# Copy the current directory contents into the container at /app
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

# Expose port 5000 for the Flask application
EXPOSE 5000

# Command to run the Flask application with Gunicorn
CMD ["bash", "-c", "chmod 777 /dev/video0 && gunicorn api.index:app"]
