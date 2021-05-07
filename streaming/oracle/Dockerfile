FROM debezium-jdbc-es:latest

# Ref: https://debezium.io/documentation/reference/install.html#_installing_a_debezium_connector
RUN curl -L 'https://oss.sonatype.org/service/local/artifact/maven/redirect?r=snapshots&g=io.debezium&a=debezium-connector-oracle&v=LATEST&c=plugin&e=tar.gz' | tar xvzf - -C $KAFKA_CONNECT_PLUGINS_DIR
COPY ojdbc8-full/* /kafka/libs
