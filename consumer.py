import argparse
import json

from confluent_kafka import Consumer

parser = argparse.ArgumentParser(description="Read demo events from Kafka")
parser.add_argument("--topic", default="demo-topic")
parser.add_argument("--group", default="g1", help="consumer group id")
parser.add_argument("--name", default="C1", help="label shown in the output")
parser.add_argument("--from-beginning", action="store_true",
                    help="start at the oldest record (only for a group with no saved offset)")
args = parser.parse_args()

consumer = Consumer({
    "bootstrap.servers": "localhost:9092",
    "group.id": args.group,
    "auto.offset.reset": "earliest" if args.from_beginning else "latest",
    "enable.auto.commit": True,
})


def on_assign(c, partitions):
    print(f"[{args.name}] ASSIGNED partitions {sorted(p.partition for p in partitions)}")


def on_revoke(c, partitions):
    print(f"[{args.name}] REVOKED  partitions {sorted(p.partition for p in partitions)}")


consumer.subscribe([args.topic], on_assign=on_assign, on_revoke=on_revoke)
print(f"[{args.name}] group={args.group} waiting for records, Ctrl+C to stop")

last_by_key = {}
max_seq = -1

try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            print("ERROR:", msg.error())
            continue
        event = json.loads(msg.value())
        key = msg.key().decode() if msg.key() else None
        seq = event.get("seq")
        print(f"[{args.name}] partition={msg.partition()} offset={msg.offset()} "
              f"key={str(key):<8} seq={seq}")
        if key is not None:
            if key in last_by_key and seq < last_by_key[key]:
                print(f"   !! KEY ORDER BROKEN for {key}: seq {seq} after {last_by_key[key]}")
            last_by_key[key] = seq
        if seq is not None:
            if seq < max_seq:
                print(f"   note: seq {seq} arrived after {max_seq} "
                      "(order across partitions is not guaranteed)")
            max_seq = max(max_seq, seq)
except KeyboardInterrupt:
    pass
finally:
    consumer.close()
