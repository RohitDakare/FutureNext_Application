FROM python:3.11-slim

WORKDIR /app

# Copy requirements file to the working directory
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

# Copy all the application files to the container
COPY . .

# Set environment variables
ENV ENVIRONMENT=production

# Expose port
EXPOSE 8000

# Command to run the application using Gunicorn with Uvicorn workers
CMD ["gunicorn", "main:app", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
