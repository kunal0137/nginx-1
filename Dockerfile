# Dockerfile for SEMOSS NGINX

FROM debian

LABEL maintainer="semoss@semoss.org"

ENV PATH=$PATH:/opt/semosshome/apache-maven-3.5.4/bin:/opt/semoss-artifacts/artifacts/scripts:/opt/semosshome/nginx/scripts

RUN apt-get update	\
	&& echo ------- installing packages ------- \
	&& apt-get install -y software-properties-common \
	&& apt-get install -y  openjdk-8-jdk \
	&& apt-get install -y wget \
	&& apt-get install -y git \
	&& apt-get install -y procps \
	&& apt-get install -y vim \
	&& apt-get install -y nano \
	&& apt-get install -y curl \
	&& apt-get install -y build-essential \
	&& echo ------- installing nginx ------- \
	&& mkdir /opt/nginx-files \
	&& cd /opt/nginx-files \
	&& wget https://nginx.org/download/nginx-1.13.1.tar.gz && tar zxvf nginx-1.13.1.tar.gz \
	&& wget https://ftp.pcre.org/pub/pcre/pcre-8.40.tar.gz && tar xzvf pcre-8.40.tar.gz \
	&& wget http://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz \
	&& wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz && tar xzvf openssl-1.1.0f.tar.gz \
	&& echo ------- installing nginx sticky module ------- \
	&& git clone https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng.git \
	&& rm -rf *.tar.gz \
	&& cd /opt/nginx-files/nginx-1.13.1 \
	&& ./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib/nginx/modules  --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log  --http-log-path=/var/log/nginx/access.log --pid-path=/run/nginx.pid  --lock-path=/var/lock/nginx.lock --user=www-data --group=www-data --build=Ubuntu --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-openssl=/opt/nginx-files/openssl-1.1.0f --with-openssl-opt=enable-ec_nistp_64_gcc_128 --with-openssl-opt=no-nextprotoneg --with-openssl-opt=no-weak-ssl-ciphers --with-openssl-opt=no-ssl3  --with-pcre=/opt/nginx-files/pcre-8.40 --with-pcre-jit --with-zlib=/opt/nginx-files/zlib-1.2.11  --with-compat --with-file-aio --with-threads  --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module  --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_slice_module --with-http_ssl_module --with-http_sub_module --with-http_stub_status_module --with-http_v2_module  --with-http_secure_link_module --with-mail  --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module  --with-stream_ssl_preread_module --with-debug  --with-cc-opt='-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now'  --add-module=/opt/nginx-files/nginx-sticky-module-ng \
	&& make \
	&& make install \
	&& mkdir -p /var/lib/nginx && nginx -t \
	&& cd /etc/systemd/system \
	&& wget https://raw.githubusercontent.com/prabhuk12/nginx/master/nginx_service \
	&& mv nginx_service nginx.service \
	&& systemctl enable nginx.service \
	&& echo ------- testing nginx install ------ \
	&& nginx \
	&& echo ------- installing maven ------- \
	&& mkdir /opt/semosshome \
	&& cd /opt/semosshome \
	&& wget -P /opt/semosshome https://apache.claz.org/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz \
	&& cd /opt/semosshome && tar -xvf /opt/semosshome/apache-maven-3.5.4-bin.tar.gz && rm /opt/semosshome/apache-maven-3.5.4-bin.tar.gz \
	&& echo ------- installing semoss-artifacts ------- \
	&& git config --global http.sslverify false \
	&& cd /opt && git clone https://github.com/SEMOSS/semoss-artifacts.git \
	&& chmod 777 /opt/semoss-artifacts/artifacts/scripts/* \
	&& /opt/semoss-artifacts/artifacts/scripts/update_latest_dev_cluster.sh \
	&& echo ------- cloning nginx conf files ------- \
	&& cd /opt/semosshome && git clone https://github.com/prabhuk12/nginx.git \
	&& echo ------- configuring nginx ------- \
	&& cp /etc/nginx/mime.types /opt/semosshome/nginx/conf/mime.types \
	&& sed -i "s/<replace_with_server_name>/${SERVER_NAME}/g" /opt/semosshome/nginx/templates/upstream.conf \
	&& echo ------- cleaning up ------- \
	&& apt-get clean all

WORKDIR /opt/semosshome/nginx/scripts

CMD ["bash"]
