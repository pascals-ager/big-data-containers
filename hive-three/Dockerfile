FROM base:1.0

ENV HIVE_VERSION  3.1.2

ENV HIVE_HOME /opt/hive

ENV PATH $HIVE_HOME/bin:$PATH

WORKDIR /opt

RUN apt-get -o Acquire::Check-Valid-Until=false update \
	&& apt-get install -y --no-install-recommends wget procps \
	&& apt-get -o Acquire::Check-Valid-Until=false --purge remove -y wget \
	&& apt-get -o Acquire::Check-Valid-Until=false clean \
	&& rm -rf /var/lib/apt/lists/*

COPY /tars/apache-hive-$HIVE_VERSION-bin.tar.gz /opt/apache-hive-$HIVE_VERSION-bin.tar.gz
COPY /jars/postgresql-9.4.1212.jar $HIVE_HOME/lib/postgresql-jdbc.jar

#Install Hive and PostgreSQL JDBC

# && wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz \
# && wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar \
RUN tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz \
	&& cp -r apache-hive-$HIVE_VERSION-bin/* hive/ \
	&& rm apache-hive-$HIVE_VERSION-bin.tar.gz


#Custom configuration goes here
COPY conf $HIVE_HOME/conf
RUN mv $HIVE_HOME/conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop
RUN mv $HIVE_HOME/conf/core-site.xml $HADOOP_PREFIX/etc/hadoop
RUN mv $HIVE_HOME/conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop
RUN mv $HIVE_HOME/conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop


COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 10000
EXPOSE 10002

ENTRYPOINT ["entrypoint.sh"]

CMD startup.sh
