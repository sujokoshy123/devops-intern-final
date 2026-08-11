# Use a lightweight official Python image
FROM python:3.12-slim

# Set working directory inside the container
WORKDIR /app

# Copy the hello.py script into the container
COPY hello.py .

# Run the script when the container starts
CMD ["python", "hello.py"]
