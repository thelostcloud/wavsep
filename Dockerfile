FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
RUN apt-get update && apt-get install -y \
    default-jdk \
    wget \
    mysql-server \
    unzip \
    curl \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Install Tomcat 9
ENV CATALINA_HOME=/opt/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH

ENV TOMCAT_VERSION=9.0.109
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mkdir -p /opt/tomcat \
    && tar xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat --strip-components=1 \
    && rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Expose ports
EXPOSE 8080 3306

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

COPY target/wavsep.war /opt/tomcat/webapps/

# Start both services
CMD ["/startup.sh"]

