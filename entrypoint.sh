until $(curl -s --output /dev/null --silent --head --fail http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT); do echo "Waiting for Elasticsearch to be online"; sleep 5; done
sleep 3
TEST=$(curl -s -I http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/elastalert_status | head -n1)
if [[ $TEST == *"404"* ]]; then
  elastalert-create-index --host $ELASTICSEARCH_HOST --port $ELASTICSEARCH_PORT --no-auth --no-ssl --index elastalert_status --url-prefix "" --old-index ""
else
    echo "Elastalert index already exists in Elasticsearch."
fi
curl -s -XPUT "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/elastalert_status/_settings" -d "{ \"index.number_of_replicas\": ${ELASTALERT_INDEX_REPLICAS} }" -H 'Content-Type: application/json'
curl -s -XPUT "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/elastalert_status_error/_settings" -d "{ \"index.number_of_replicas\": ${ELASTALERT_INDEX_REPLICAS} }" -H 'Content-Type: application/json'
curl -s -XPUT "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/elastalert_status_past/_settings" -d "{ \"index.number_of_replicas\": ${ELASTALERT_INDEX_REPLICAS} }" -H 'Content-Type: application/json'
curl -s -XPUT "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/elastalert_status_silence/_settings" -d "{ \"index.number_of_replicas\": ${ELASTALERT_INDEX_REPLICAS} }" -H 'Content-Type: application/json'
curl -s -XPUT "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/elastalert_status_status/_settings" -d "{ \"index.number_of_replicas\": ${ELASTALERT_INDEX_REPLICAS} }" -H 'Content-Type: application/json'

elastalert --config /etc/elastalert/config.yaml --verbose
