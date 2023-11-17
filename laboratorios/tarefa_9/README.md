# Lab 09: Spark Streaming e Kafka

## Environment preparation (TODO)

## Exercices

### 1. [Create Confluent Cloud and topic_0](https://confluent.cloud/)


### 2. [Create Databricks Community Cloud and create cluster_0](https://community.cloud.databricks.com/)

https://medium.com/analytics-vidhya/beginners-guide-on-databricks-spark-using-python-pyspark-de74d92e4885

https://www.analyticsvidhya.com/blog/2021/09/a-comprehensive-guide-on-databricks-beginners/


### 3. Create databricks notebook, test kafka producer and consumer

#### Env and Config

```
CLUSTER_API_KEY='ANP2HUOQO4DXZKC2'
CLUSTER_API_SECRET='Hl4F/c6CDDJpArOoIdynbtZ0JBtfBmG/y9jhsCdrubDNb4BNzDLrfcMWMKm7B9ap'

config_file = \
f'''
# Required connection configs for Kafka producer, consumer, and admin
bootstrap.servers=pkc-921jm.us-east-2.aws.confluent.cloud:9092
security.protocol=SASL_SSL
sasl.mechanisms=PLAIN
sasl.username={ CLUSTER_API_KEY }
sasl.password={ CLUSTER_API_SECRET }
'''.split("\n")

def read_ccloud_config(config_file):
    conf = {}
    for line in config_file:
        line = line.strip()
        if len(line) != 0 and line[0] != "#":
            parameter, value = line.strip().split('=', 1)
            conf[parameter] = value.strip()
    print(conf)
    return conf

config_file_dict = read_ccloud_config(config_file)

```

#### Test Kafka Producer
```
from confluent_kafka import Producer
producer = Producer(config_file_dict)
producer.produce("topic_0", key="key", value="1")
producer.produce("topic_0", key="key", value="2")
producer.produce("topic_0", key="key", value="3")
producer.produce("topic_0", key="key", value="4")
producer.produce("topic_0", key="key", value="5")
producer.flush()
```
#### Test Kafka Consumer
```
from confluent_kafka import Consumer

props = config_file_dict
props["group.id"] = "python-group-1"
props["auto.offset.reset"] = "earliest"

consumer = Consumer(props)
consumer.subscribe(["topic_0"])
try:
    while True:
        msg = consumer.poll(1.0)
        if msg is not None and msg.error() is None:
            print("key = {key:12} value = {value:12}".format(key=msg.key().decode('utf-8'), value=msg.value().decode('utf-8')))
except KeyboardInterrupt:
    pass
finally:
    consumer.close()
```



### 4. Add twitter app setup notebook


https://github.com/kaantas/kafka-twitter-spark-streaming/blob/master/kafka_twitter_spark_streaming.py

https://disa.mil/-/media/Files/DISA/News/Events/Symposium/KMS/Big-Data-Road-Map-Use-Case-1---Rand.ashx

#### Env Variables
```
consumer_key = 'G9PkD5CW1Z2EMAgl4ZFTjk9iW'
consumer_secret = '6RKRs1h5dmK8wsrGIs6Xbsmizw3iCtRt8834jejDfed97dsYdZ'
access_token = '1426467908520120327-aJhDAK3KtNPte49b7qzkz2KzknZ99Z'
access_secret = '5sow2HLXiuELU7XuPt3Swd3KQ72V7mCnqufa0qFdmq0DS'
bearerToken = 'AAAAAAAAAAAAAAAAAAAAALQ6rAEAAAAABjUFNaR0GUBhJQj26ZqljfAPZBo%3Dq0DzSOeJ96zl9Pun1esPrZQZ83VLdFoX6880EZBp3teFVL3hMI'
```
#### Creating Kafka Producer
```
import tweepy
import logging
import json

consumerKey = consumer_key
consumerSecret = consumer_secret
accessToken = access_token
accessTokenSecret = access_secret

logging.basicConfig(level=logging.INFO)

producer = Producer(config_file_dict)
search_term = 'HarryPotter'  
topic_name = 'twitter'

def twitterAuth():
    authenticate = tweepy.OAuthHandler(consumerKey, consumerSecret)
    authenticate.set_access_token(accessToken, accessTokenSecret)
    api = tweepy.API(authenticate, wait_on_rate_limit=True)
    return api

class TweetListener(tweepy.Stream):

    def on_data(self, raw_data):
        logging.info(raw_data)

        tweet = json.loads(raw_data)

        if tweet['data']:
            data = {
                'message': tweet['data']['text'].replace(',', '')
            }
            producer.send(topic_name, value=json.dumps(data).encode('utf-8'))

        return True

    @staticmethod
    def on_error(status_code):
        if status_code == 420:
            return False

    def start_streaming_tweets(self, search_term):
        self.add_rules(tweepy.StreamRule(search_term))
        self.filter()

twitter_stream = TweetListener(bearerToken)
twitter_stream.start_streaming_tweets(search_term)
```

### 5. Add Spark Streaming and Kafka utils to make process using some spark function

https://github.com/kaantas/kafka-twitter-spark-streaming/blob/master/kafka_twitter_spark_streaming.py

https://github.com/sridharswamy/Twitter-Sentiment-Analysis-Using-Spark-Streaming-And-Kafka

#### Creating Kafka Consumer
```
from pyspark.sql.functions import from_json, udf
from pyspark.sql.types import StructType, StructField, StringType, ArrayType

# Schema for the incoming data
schema = StructType([StructField("message", StringType())])

# Read the data from kafka
df = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "twitter") \
    .option("startingOffsets", "latest") \
    .option("header", "true") \
    .load() \
    .selectExpr("CAST(value AS STRING) as message")

df = df \
    .withColumn("value", from_json("message", schema))

# Pre-processing the data
pre_process = udf(
    lambda x: re.sub(r'[^A-Za-z\n ]|(http\S+)|(www.\S+)', '', x.lower().strip()).split(), ArrayType(StringType())
)

df = df.withColumn("cleaned_data", pre_process(df.message)).dropna()
```
