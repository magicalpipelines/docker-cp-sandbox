# Confluent Platform - Sandbox
![Docker Pulls](https://img.shields.io/docker/pulls/magicalpipelines/cp-sandbox.svg)
![Docker Automated](https://img.shields.io/docker/automated/magicalpipelines/cp-sandbox.svg)
![Docker Build](https://img.shields.io/docker/build/magicalpipelines/cp-sandbox.svg)

Yes, I know running multiple processes in a single container is a Docker anti-pattern. However, this is very convenient for adhoc testing and sandboxing purposes.

# Local Development
## Building
```bash
$ docker build -t magicalpipelines/cp-sandbox:latest .
```

## Mounting Kafka Streams code
```
$ cd /path/to/kafka/streams/app
$ docker run --name sandbox -v "$(pwd)":/app -ti magicalpipelines/cp-sandbox bash
```


## Helpful commands
```bash
# start kafka and zookeeper
$ confluent local start kafka

# list topics
$ kafkacat -q -b localhost:9092 -L

# produce to local kafka cluster
$ kafkacat -q -b localhost:9092 -t hello -P
hello
world

# consume from local kafka cluster
$ kafkacat -q -b localhost:9092 -t hello -o beginning

# run Kafka Streams app
# (assumes gradle wrapper is used)
$ /app/gradlew run --info
```
