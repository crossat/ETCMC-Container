FROM python:3.12.5-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gcc \
    python3-dev

# Create a separate directory for your application code
RUN mkdir /app/ETCMC

# Download and unzip the application code into /app/code
RUN curl -O -L https://github.com/Nowalski/ETCMC_Software/releases/download/Setup%2FWindows/ETCMC_Linux.zip
RUN unzip ETCMC_Linux.zip -d /app/ETCMC

RUN chmod -R 777 /app/ETCMC

WORKDIR /app/ETCMC

RUN pip install -r requirements.txt

# Declare /app/ETCMC as a volume for persistent storage
VOLUME /app/ETCMC

EXPOSE 5000

CMD ["sh", "-c", "python Linux.py start --port 5000 & tail -f /dev/null"]