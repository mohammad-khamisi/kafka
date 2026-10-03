import argparse
import json
import time
import uuid
from datetime import datetime, timezone

from confluent_kafka import Producer

parser = argparse.ArgumentParser(description="Send demo events to Kafka")
parser.add_argument("--topic", default="demo-topic")
parser.add_argument("--count", type=int, default=12, help="how many events to send")
parser.add_argument("--keys", default="user1,user2,user3,user4",
                    help="comma-separated keys, used in turn")
parser.add_argument("--no-key", action="store_true", help="send events without a key")
parser.add_argument("--partition", type=int, default=None,
                    help="force one partition (skips the hash)")
parser.add_argument("--delay", type=float, default=0.3, help="seconds between events")
args = parser.parse_args()

producer = Producer({
    "bootstrap.servers": "localhost:9092",
    # Same hash as the Java client, so the results match the Partition page demo.
    "partitioner": "murmur2_random",
})


def on_delivery(err, msg):
    # Called after the broker confirms the write.
    if err is not None:
        print("FAILED:", err)
        return
    key = msg.key().decode() if msg.key() else None
    print(f"sent  key={str(key):<8} -> partition={msg.partition()} offset={msg.offset()}")


keys = [k.strip() for k in args.keys.split(",") if k.strip()]

for i in range(args.count):
    key = None if args.no_key or not keys else keys[i % len(keys)]
    event = {
        "event_id": str(uuid.uuid4()),
        "event_type": "demo.event",
        "event_time": datetime.now(timezone.utc).isoformat(),
        "seq": i,
        "key": key,
    }
    extra = {}
    if args.partition is not None:
        extra["partition"] = args.partition
    producer.produce(
        args.topic,
        key=key,
        value=json.dumps(event).encode("utf-8"),
        on_delivery=on_delivery,
        **extra,
    )
    producer.poll(0)
    time.sleep(args.delay)

producer.flush()
print("done")
