# Confluent Platform - Sandbox
![Docker Pulls](https://img.shields.io/docker/pulls/magicalpipelines/cp-sandbox.svg)
![Docker Automated](https://img.shields.io/docker/cloud/automated/magicalpipelines/cp-sandbox.svg)
![Docker Build](https://img.shields.io/docker/cloud/build/magicalpipelines/cp-sandbox.svg)

Developing Kafka Streams and ksqlDB applications can require a surprising amount of technologies:
- Zookeeper
- Kafka
- ksqlDB
- ksql-datagen
- Kafka Connect
- Kafka Rest Proxy
- Schema Registry
- kafkacat

Typically, many of these are cobbled together using [huge docker-compose files][huge-compose], manually installing the entire Confluent Platform, or writing shitloads of yaml in the form of Helm / Kubernetes configs. I think part of the motivation of these unneccessarily complicated setups is the avoidance of a well-known Docker anti-pattern: running multiple processes in a single container.

But for beginners, minimalists, and pragmatists, it is much more convenient to run an all-in-one sandbox like the one provided here. Enjoy ❤️

[huge-compose]: https://github.com/confluentinc/demo-scene/blob/c3ddb47e6e2a06d511c1fa878212bc085cd0b419/community-components-only/docker-compose.yml

# Kafka Streams
```bash
$ git clone <your-kafka-streams-repo>

$ cd your/repo

$ docker run --name sandbox \
  -v "$(pwd)":/app \
  -w /app \
  -ti magicalpipelines/cp-sandbox:5.3.0 \
  bash -c "confluent local start kafka; bash"

# wait for kafka and zookeeper to start
# ...

# create your source topics
$ kafka-topics \
  --bootstrap-server localhost:9092 \
  --topic hello-world \
  --replication-factor 1 \
  --partitions 4 \
  --create

# run your app
./gradlew run
```

# KSQL (ksqlDB coming soon)
```bash
docker run --name sandbox \
  -v "$(pwd)":/app \
  -w /app/hello-streams \
  -ti magicalpipelines/cp-sandbox:5.3.0 \
  bash -c "confluent local start ksql-server; ksql"
```

# Generating Data
Once your sandbox is running, you can use ksql-datagen to produce data using a built-in schema, or by defining your own. This example uses the former, and assumes you have a topic named `hello-world`:

```bash
$ docker exec -ti sandbox \
  ksql-datagen quickstart=users topic=hello-world format=delimited
```

# Kafkacat
Some examples of using the kafkacat CLI.
```bash
# list topics
$ kafkacat -q -b localhost:9092 -L

# produce to local kafka cluster
$ kafkacat -q -b localhost:9092 -t hello -P
hello
world

# consume from local kafka cluster
$ kafkacat -q -b localhost:9092 -t hello -o beginning
```
