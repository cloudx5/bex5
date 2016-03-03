FROM centos:7
WORKDIR /usr/local

ADD bex5.tar.gz /usr/local/

COPY bex5/startup.sh /usr/local/startup.sh
COPY bex5/mysql/bin/startup.sh /usr/local/mysql/bin/startup.sh

RUN yum install -y libaio
RUN useradd mysql

CMD /usr/local/startup.sh
EXPOSE 8080

