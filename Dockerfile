FROM centos:7
WORKDIR /usr/local

ADD bex5.tar.gz /usr/local/

COPY bex5/startup.sh /usr/local/startup.sh
COPY bex5/mysql/bin/startup.sh /usr/local/mysql/bin/startup.sh
COPY bex5/tomcat/bin/catalina.sh /usr/local/apache-tomcat/bin/catalina.sh
COPY bex5/tomcat/config/context.xml /usr/local/apache-tomcat/conf/context.xml

RUN yum install -y libaio
RUN useradd mysql

EXPOSE 8080

CMD /usr/local/startup.sh
