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
RUN curl -O -L https://github.com/Nowalski/ETCMC_Software/releases/download/Setup%2FWindows/ETCMC_Linux.zip \
    && unzip ETCMC_Linux.zip -d ETCMC \
    && chmod -R 777 ETCMC \
    && rm -f ETCMC_Linux.zip  # Remove the zip file after extraction

# Create a separate directory for your application code
RUN mkdir /app/Etcmcnodecheck

# Change to the etcmcnodecheck directory and download the nodecheck client
RUN curl -O -L https://etcmcnodecheck.apritec.dev/files-linux/etcmcnodecheck-linux-v0.10.tar \
    && tar -xvf etcmcnodecheck-linux-v0.10.tar \
    && chmod -R 777 Etcmcnodecheck \
    && rm -f etcmcnodecheck-linux-v0.10.tar

# Pre-configure the monitoring ID file with a default ID
RUN echo 012345678-mynode01 > /app/Etcmcnodecheck/etcmcnodemonitoringid.txt

RUN cp ./check-node.sh /app/etcmcnodecheck/check-node.sh

WORKDIR /app/ETCMC

RUN pip install -r requirements.txt

# Declare /app/ETCMC as a volume for persistent storage
VOLUME /app/ETCMC
VOLUME /app/Etcmcnodecheck

EXPOSE 5000

# Start both ETCMC and the nodecheck client on container boot
CMD ["sh", "-c", "python Linux.py start --port 5000 & cd /app/Etcmcnodecheck && ./check-node.sh & tail -f /dev/null"]