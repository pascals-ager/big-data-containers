FROM debian:stretch

RUN apt-get -o Acquire::Check-Valid-Until=false update \
    && DEBIAN_FRONTEND=noninteractive apt-get  install -y --no-install-recommends openjdk-8-jdk:amd64 \
    && DEBIAN_FRONTEND=noninteractive apt-get  install -y --no-install-recommends net-tools curl \
    && apt-get  install -y --no-install-recommends netcat \
    && apt-get  install -y --no-install-recommends openssh-server \
    && apt-get  install -y --no-install-recommends openssh-client \
    && apt-get  install -y --no-install-recommends wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

ENV HADOOP_VERSION 2.8.5
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
COPY /tars/hadoop-$HADOOP_VERSION.tar.gz /tmp/hadoop.tar.gz
RUN set -x \
    # && curl -fkSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    # && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    # && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

#RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_COMMON_HOME=$HADOOP_PREFIX
ENV HADOOP_HDFS_HOME=$HADOOP_PREFIX
ENV HADOOP_MAPRED_HOME=$HADOOP_PREFIX
ENV HADOOP_YARN_HOME=$HADOOP_PREFIX
ENV HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop

COPY /conf/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
COPY /conf/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
COPY /conf/core-site.xml $HADOOP_CONF_DIR/core-site.xml
COPY /conf/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml
COPY /conf/slaves $HADOOP_CONF_DIR/slaves

ENV PATH $HADOOP_PREFIX/bin/:$HADOOP_PREFIX/sbin:$PATH
ENV PATH $PATH:$JAVA_HOME/bin

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\nexport HADOOP_PREFIX=/opt/hadoop-2.8.5\nexport HADOOP_HOME=/opt/hadoop-2.8.5\n:' $HADOOP_CONF_DIR/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/opt/hadoop-2.8.5/etc/hadoop/:' $HADOOP_CONF_DIR/hadoop-env.sh

COPY config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

# passwordless ssh
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENV SPARK_VERSION 2.4.4
ENV SPARK_HADOOP_BUILD 2.7
ENV SPARK_URL https://www-eu.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_BUILD.tgz
COPY /tars/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_BUILD.tgz /tmp/spark.tar.tgz
RUN set -x \
    #&& curl -fkSL "$SPARK_URL" -o /tmp/spark.tar.tgz \
    #&& curl -fSL "$SPARK_URL.asc" -o /tmp/spark.tar.gz.asc \
    #&& gpg --verify /tmp/spark.tar.gz.asc \
    && tar -xvf /tmp/spark.tar.tgz -C /opt/ \
    && rm /tmp/spark.tar.tgz*

ENV SPARK_PREFIX=/opt/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_BUILD
ENV SPARK_HOME=$SPARK_PREFIX
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_PREFIX/lib/native

ENV PATH $PATH:$SPARK_PREFIX/bin

COPY /conf/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf