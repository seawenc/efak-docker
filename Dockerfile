FROM seawenc/centos7fat:1.0
MAINTAINER chengsheng(seawenc)

#rm -rf /etc/yum.repos.d/* && \
#curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && \
WORKDIR /opt/app
#RUN wget -c https://github.com/smartloli/kafka-eagle-bin/archive/v3.0.1.tar.gz
RUN cd /opt/app && curl -O  https://github.com/smartloli/kafka-eagle-bin/archive/v3.0.1.tar.gz && \
    tar -xzvf v3.0.1.tar.gz && \
    tar -xzf kafka-eagle-bin-3.0.1/efak-web-3.0.1-bin.tar.gz && \
    rm -rf kafka-eagle-bin-* v3.0.1.tar.gz && \
    mv efak-web-* efak

ENV KE_HOME=/opt/app/efak
ENV PATH $KE_HOME/bin:$PATH

COPY /ke-start.sh /
COPY /healthcheck.sh /
#添加建康检查
HEALTHCHECK --start-period=30s --retries=1 --interval=10s --timeout=5s CMD sh /healthcheck.sh

EXPOSE 8048

CMD ["sh","/ke-start.sh"]