FROM ubuntu:19.04

RUN echo -e "\n\n\n***** Add wget *****\n"                                                                 && \
apt-get update \
  && apt-get install -y wget gcc g++ make curl ca-certificates apt-transport-https lsb-release gnupg \
  && rm -rf /var/lib/apt/lists/*

RUN echo -e "\n\n\n***** Add dotnet core *****\n"                                                                 && \
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
 dpkg -i packages-microsoft-prod.deb

RUN echo -e "\n\n\n***** Install dotnet core *****\n"                                                                 && \
apt-get install apt-transport-https && \
apt-get update  && \
apt-get install -y dotnet-sdk-2.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && \
apt-get install -y nodejs

RUN echo -e "\n\n\n***** Install azure cli *****\n"                                                                 && \
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN echo -e "\n\n\n***** Set curl path to azure cli *****\n"                                                                 && \
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

RUN echo -e "\n\n\n***** run bash command *****\n"                                                                 && \
AZ_REPO=$(lsb_release -cs) && \
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

RUN echo -e "\n\n\n***** Install azure cli *****\n"                                                                 && \
apt-get install -y azure-cli 

RUN echo -e "\n\n\n***** Azure functions core tools *****\n"                                                                 && \
npm install --unsafe-perm --global --silent npm                                     && \
npm install --unsafe-perm --global --silent azure-functions-core-tools
