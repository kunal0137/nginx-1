# Main Docker File for All the SEMOSS Pieces

# Start from the loaded R-Base-with-java
# Using R 3.5

FROM debian

LABEL maintainer="semoss@semoss.org"

ENV PATH=$PATH:/opt/semosshome/apache-maven-3.5.4/bin:/opt/semoss-artifacts/artifacts/scripts
 
# Install Java
# Install git
# Clone from prabhuk12/nginx need to change this once tim comes back
# Start listening

RUN echo "Starting install " 
RUN apt-get update	\
	&& apt-get install -y software-properties-common \
	&& apt-get install -y  openjdk-8-jdk \
	&& apt install -y wget \
	&& apt install -y git \
	&& apt install -y procps \
	&& apt install -y nginx \
	&& apt install -y vim \
	&& apt install -y curl \
	&& apt install -y nano \
	&& mkdir /opt/semosshome \
	&& cd /opt/semosshome \
	&& wget -P /opt/semosshome https://apache.claz.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz \
	&& cd /opt/semosshome && tar -xvf /opt/semosshome/apache-maven-3.5.4-bin.tar.gz && rm /opt/semosshome/apache-maven-3.5.4-bin.tar.gz \
	&& mkdir /opt/semosshome/nginx \
	&& mkdir /opt/semosshome/nginx/scripts \
	&& cd /opt/semosshome \ 
	&& apt-get clean all \
	&& git config --global http.sslverify false \
	&& cd /opt && git clone https://github.com/SEMOSS/semoss-artifacts \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/* \
	&& /opt/semoss-artifacts/artifacts/scripts/update_latest_dev_cluster.sh 
#	&& git clone https://github.com/prabhuk12/nginx

WORKDIR /opt/semosshome/nginx/scripts

CMD ["runAll.sh"]
