# Use the official Python image as the base
FROM python:3.8-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the Python script into the container
COPY app/ .

# Set the script as the entrypoint
ENTRYPOINT ["python", "-u", "main.py"]

CMD ["--filename", "catalog/message.txt"]