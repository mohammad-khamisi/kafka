python --version
pip install confluent-kafka

python -c "from confluent_kafka.admin import AdminClient; print(list(AdminClient({'bootstrap.servers':'localhost:9092'}).list_topics(timeout=10).topics))"

python producer.py
python consumer.py --name C1 --group g1 --from-beginning

#OR
python consumer.py --name C1 --group trio --from-beginning
python consumer.py --name C2 --group trio --from-beginning
python consumer.py --name C3 --group trio --from-beginning


