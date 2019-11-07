FROM base:1.0

ENV HIVE_VERSION 2.3.3

ENV HIVE_HOME /opt/hive

ENV PATH $HIVE_HOME/bin:$PATH

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
RUN apt-get -o Acquire::Check-Valid-Until=false update \
	&& apt-get install -y --no-install-recommends wget procps \
	&& wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz \
	&& tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz \
	&& mv apache-hive-$HIVE_VERSION-bin hive \
	&& wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar \
	&& rm apache-hive-$HIVE_VERSION-bin.tar.gz  \
	&& apt-get -o Acquire::Check-Valid-Until=false --purge remove -y wget \
	&& apt-get -o Acquire::Check-Valid-Until=false clean \
	&& rm -rf /var/lib/apt/lists/*


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
