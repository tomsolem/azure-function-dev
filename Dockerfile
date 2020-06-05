FROM ubuntu:focal

RUN apt-get update
RUN apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg dirmngr gcc g++ make wget apt-utils

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt-get update
RUN apt-get install -y dotnet-sdk-3.1

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

RUN AZ_REPO=$(lsb_release -cs) && \
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

RUN apt-get update
RUN apt-get install -y azure-cli

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && \
apt-get install -y nodejs

RUN npm install --unsafe-perm --global --silent npm   
RUN npm install --unsafe-perm --global --silent azure-functions-core-tools@3
