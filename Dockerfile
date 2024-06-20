# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y cmake && apt-get clean

# Install pipenv
RUN pip install pipenv

# Copy the Pipfile and Pipfile.lock into the container at /app
COPY Pipfile Pipfile.lock /app/

# Add debugging information
RUN echo "Pipfile content:"
RUN cat Pipfile

# Install dependencies
RUN pipenv install --deploy --ignore-pipfile || { echo "Pipenv install failed"; exit 1; }

# Copy the rest of the application code into the container at /app
COPY . /app

# Expose port 5000 for the Flask app
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=api/index.py
ENV FLASK_RUN_HOST=0.0.0.0

# Command to run the Flask app
CMD ["pipenv", "run", "flask", "run"]
