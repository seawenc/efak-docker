FROM seawenc/centos7fat:1.0
MAINTAINER chengsheng(seawenc)

#rm -rf /etc/yum.repos.d/* && \
#curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && \


#RUN wget -c https://github.com/smartloli/kafka-eagle-bin/archive/v3.0.1.tar.gz （本地：http://192.168.56.1:8000/v3.0.1.tar.gz）
RUN cd /opt/app && curl -O https://github.com/smartloli/kafka-eagle-bin/archive/v3.0.1.tar.gz && \
    tar -xzvf v3.0.1.tar.gz && \
    tar -xzf kafka-eagle-bin-3.0.1/efak-web-3.0.1-bin.tar.gz && \
    rm -rf kafka-eagle-bin-* v3.0.1.tar.gz && \
    mv efak-web-* efak

#替换jar包，解决两个bug：1.不支持双ip，2.jmx异常时提示不对
#已提merge request, 合并后，用新版本，将不再需要以下两行内容: https://github.com/smartloli/EFAK/pull/649
COPY /efak-common-3.0.1.jar /
RUN sed -i '/ke.war/a\ \\cp -f /efak-common-3.0.1.jar /opt/app/efak/kms/webapps/ke/WEB-INF/lib/' /opt/app/efak/bin/ke.sh

ENV KE_HOME=/opt/app/efak
ENV PATH $KE_HOME/bin:$PATH
WORKDIR /opt/app/efak
COPY /ke-start.sh /
COPY /healthcheck.sh /
#添加建康检查
HEALTHCHECK --start-period=30s --retries=1 --interval=10s --timeout=5s CMD sh /healthcheck.sh

EXPOSE 8048

CMD ["sh","/ke-start.sh"]