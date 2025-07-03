FROM python:3.12-slim

WORKDIR /app

# Install system dependencies and clean up in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg libgl1 && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies and clean up pip cache
RUN pip install --no-cache-dir opencv-python ultralytics

# Copy only necessary files
COPY detectVideo.py ./detectVideo.py
COPY best.pt ./best.pt

# Create videos directory
RUN mkdir /videos

ENTRYPOINT ["python", "detectVideo.py"]
