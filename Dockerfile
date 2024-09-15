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

# Change to the etcmcnodecheck directory and download the nodecheck client
RUN mkdir -p /app/nodechecker-telegram
RUN cd /app/nodechecker-telegram
RUN curl -O -L https://etcmcnodecheck.apritec.dev/files-linux/etcmcnodecheck-linux-v0.10.tar
RUN tar -xvf etcmcnodecheck-linux-v0.10.tar

#RUN chmod -R 777 Etcmcnodecheck


# Pre-configure the monitoring ID file with a default ID
RUN chmod -R 777 Etcmcnodecheck \
&& echo 012345678-mynode01 > /app/nodechecker-telegram/Etcmcnodecheck/etcmcnodemonitoringid.txt

WORKDIR /app/ETCMC

RUN pip install -r requirements.txt

# Declare /app/ETCMC as a volume for persistent storage
VOLUME /app/ETCMC
VOLUME /app/nodechecker-telegram


EXPOSE 5000

# Start both ETCMC and the nodecheck client on container boot
CMD ["sh", "-c", "python Linux.py start --port 5000 & cd /app/nodechecker-telegram/Etcmcnodecheck && ./check-node.sh & tail -f /dev/null"]
