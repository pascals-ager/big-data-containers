FROM debian:8
MAINTAINER Advith Nagappa

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -t jessie-backports -y --no-install-recommends openjdk-8-jdk

RUN apt-get install wget -y --fix-missing

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends net-tools curl

RUN apt-get install netcat -y && apt-get install -y openssh-server && apt-get install -y openssh-client

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    07617D4968B34D8F13D56E20BE5AAA0BA210C095 \
    2CAC83124870D88586166115220F69801F27E622 \
    4B96409A098DBD511DF2BC18DBAF69BEA7239D59 \
    9DD955653083EFED6171256408458C39E964B5FF \
    B6B3F7EDA5BA7D1E827DE5180DFF492D8EE2F25C \
    6A67379BEFC1AE4D5595770A34005598B8F47547 \
    47660BC98BC433F01E5C90581209E7F13D0C92B9 \
    CE83449FDC6DACF9D24174DCD1F99F6EE3CD2163 \
    A11DF05DEA40DA19CE4B43C01214CF3F852ADB85 \
    686E5EDF04A4830554160910DF0F5BBC30CD0996 \
    5BAE7CB144D05AD1BB1C47C75C6CC6EFABE49180 \
    AF7610D2E378B33AB026D7574FB955854318F669 \
    6AE70A2A38F466A5D683F939255ADF56C36C5F0F \
    70F7AB3B62257ABFBD0618D79FDB12767CC7352A \
    842AAB2D0BC5415B4E19D429A342433A56D8D31A \
    1B5D384B734F368052862EB55E43CAB9AEC77EAF \
    785436A782586B71829C67A04169AA27ECB31663 \
    5E49DA09E2EC9950733A4FF48F1895E97869A2FB \
    A13B3869454536F1852C17D0477E02D33DD51430 \
    A6220FFCC86FE81CE5AAC880E3814B59E4E11856 \
    EFE2E7C571309FE00BEBA78D5E314EEF7340E1CB \
    EB34498A9261F343F09F60E0A9510905F0B000F0 \
    3442A6594268AC7B88F5C1D25104A731B021B57F \
    6E83C32562C909D289E6C3D98B25B9B71EFF7770 \
    E9216532BF11728C86A11E3132CF4BF4E72E74D3 \
    E8966520DA24E9642E119A5F13971DA39475BD5D \
    1D369094D4CFAC140E0EF05E992230B1EB8C6EFA \
    A312CE6A1FA98892CB2C44EBA79AB712DE5868E6 \
    0445B7BFC4515847C157ECD16BA72FF1C99785DE \
    B74F188889D159F3D7E64A7F348C6D7A0DCED714 \
    4A6AC5C675B6155682729C9E08D51A0A7501105C \
    8B44A05C308955D191956559A5CEE20A90348D47

RUN gpg --keyserver pool.sks-keyservers.net --recv-key C36C5F0F
RUN gpg --keyserver pool.sks-keyservers.net --recv-key D33D195C
RUN gpg --keyserver pool.sks-keyservers.net --recv-key 52293533

ENV HADOOP_VERSION 2.8.4
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

#RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_COMMON_HOME=$HADOOP_PREFIX
ENV HADOOP_HDFS_HOME=$HADOOP_PREFIX
ENV HADOOP_MAPRED_HOME=$HADOOP_PREFIX
ENV HADOOP_YARN_HOME=$HADOOP_PREFIX
ENV HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop

ADD /conf/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml
ADD /conf/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
ADD /conf/core-site.xml $HADOOP_CONF_DIR/core-site.xml
ADD /conf/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml
ADD /conf/hive-site.xml $HADOOP_CONF_DIR/hive-site.xml
ADD /conf/slaves $HADOOP_CONF_DIR/slaves

ENV PATH $HADOOP_PREFIX/bin/:$HADOOP_PREFIX/sbin:$PATH
ENV PATH $PATH:$JAVA_HOME/bin

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\nexport HADOOP_PREFIX=/opt/hadoop-2.8.4\nexport HADOOP_HOME=/opt/hadoop-2.8.4\n:' $HADOOP_CONF_DIR/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/opt/hadoop-2.8.4/etc/hadoop/:' $HADOOP_CONF_DIR/hadoop-env.sh

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

# passwordless ssh
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ENV SPARK_VERSION 2.3.1
ENV SPARK_HADOOP_BUILD 2.7
ENV SPARK_URL https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_BUILD.tgz
RUN set -x \
    && curl -fSL "$SPARK_URL" -o /tmp/spark.tar.tgz \
    #&& curl -fSL "$SPARK_URL.asc" -o /tmp/spark.tar.gz.asc \
    #&& gpg --verify /tmp/spark.tar.gz.asc \
    && tar -xvf /tmp/spark.tar.tgz -C /opt/ \
    && rm /tmp/spark.tar.tgz*

ENV SPARK_PREFIX=/opt/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_BUILD
ENV SPARK_HOME=$SPARK_PREFIX
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_PREFIX/lib/native

ENV PATH $PATH:$SPARK_PREFIX/bin

ADD /conf/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf