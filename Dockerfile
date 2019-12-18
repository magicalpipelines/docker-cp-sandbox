FROM byrnedo/alpine-curl AS build-env

ENV CONFLUENT_VERSION 5.3.0
ENV CONFLUENT_SCALA_VERSION 2.11

# Install Confluent Platform
ADD http://packages.confluent.io/archive/5.3/confluent-community-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz /opt
RUN tar xf /opt/confluent-community-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz -C /opt/ && rm /opt/confluent-community-$CONFLUENT_VERSION-$CONFLUENT_SCALA_VERSION.tar.gz

# Install Confluent Hub
ADD http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz /opt/
RUN mkdir -p /opt/confluent-hub && tar xf /opt/confluent-hub-client-latest.tar.gz -C /opt/confluent-hub && rm /opt/confluent-hub-client-latest.tar.gz

# Setup symlink
RUN ln -s /opt/confluent-$CONFLUENT_VERSION /opt/confluent

# Install the Confluent CLI
RUN curl -L https://cnfl.io/cli | sh -s -- -b /opt/confluent/bin

# Set permissions correctly
RUN chown 1000:1000 /opt/confluent-$CONFLUENT_VERSION/share/java/kafka/connect-*
RUN chmod go+r /opt/confluent-$CONFLUENT_VERSION/share/java/kafka/connect-*

FROM openjdk:8-jdk-slim
COPY --from=build-env /opt /opt

# Add Confluent binaries to path
ENV PATH="/opt/confluent/bin/:/opt/confluent-hub/bin:${PATH}"

# Install curl and kafkacat
RUN apt-get update && apt-get --assume-yes install curl kafkacat

CMD ["bash"]
#ENTRYPOINT ["/docker-entrypoint.sh"]
