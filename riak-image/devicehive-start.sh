#!/bin/bash -e

nginx &

set -x

while ! curl --output /dev/null --silent --head --fail "http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/"; do
  echo "Riak TS host is unavailable. Trying to reconnect..."
  sleep 5
done

sleep 60 # delay for bucket-type bootstrapping

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-login_bin: dhadmin' \
    -d "{\"id\": 1, \"login\":\"dhadmin\", \"passwordHash\":\"DFXFrZ8VQIkOYECScBbBwsYinj+o8IlaLsRQ81wO+l8=\", \"passwordSalt\":\"sjQbZgcCmFxqTV4CCmGwpIHO\", \"role\":\"ADMIN\", \"status\":\"ACTIVE\", \"loginAttempts\":0, \"lastLogin\":null,\"googleLogin\":null,\"facebookLogin\":null,\"githubLogin\":null,\"entityVersion\":0,\"data\":null}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/user/keys/1

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-login_bin: test_admin' \
    -d "{\"id\": 2, \"login\":\"test_admin\", \"passwordHash\":\"+IC4w+NeByiymEWlI5H1xbtNe4YKmPlLRZ7j3xaireg=\", \"passwordSalt\":\"9KynX3ShWnFym4y8Dla039py\", \"role\":\"ADMIN\", \"status\":\"ACTIVE\", \"loginAttempts\":0, \"lastLogin\":null,\"googleLogin\":null,\"facebookLogin\":null,\"githubLogin\":null,\"entityVersion\":0,\"data\":null}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/user/keys/2

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{"increment": 100}' \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/counters/buckets/dh_counters/datatypes/userCounter

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-label_bin: Access Key for dhadmin' \
    -H 'x-riak-index-userId_int: 2' \
    -H 'x-riak-index-key_bin: 1jwKgLYi/CdfBTI9KByfYxwyQ6HUIEfnGSgakdpFjgk=' \
    -H 'x-riak-index-expirationDate_int: -1' \
    -d "{\"id\": 1, \"label\":\"Access Key for dhadmin\", \"key\": \"1jwKgLYi/CdfBTI9KByfYxwyQ6HUIEfnGSgakdpFjgk=\", \"expirationDate\": null, \"type\":\"DEFAULT\", \"user\":{\"id\":2,\"login\":\"test_admin\",\"passwordHash\":\"+IC4w+NeByiymEWlI5H1xbtNe4YKmPlLRZ7j3xaireg=\",\"passwordSalt\":\"9KynX3ShWnFym4y8Dla039py\",\"loginAttempts\":0,\"role\":\"ADMIN\",\"status\":\"ACTIVE\",\"lastLogin\":null,\"googleLogin\":null,\"facebookLogin\":null,\"githubLogin\":null,\"entityVersion\":1,\"data\":null}, \"permissions\": [{\"id\":null,\"domains\":null,\"subnets\":null,\"actions\":null,\"networkIds\":null,\"deviceGuids\":null}]}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/access_key/keys/1

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-label_bin: Access Key for dhadmin' \
    -H 'x-riak-index-userId_int: 1' \
    -H 'x-riak-index-key_bin: 1jwKgLYi/CdfBTI9KByfYxwyQ6HUIEfnGSgakdpFjgk=' \
    -H 'x-riak-index-expirationDate_int: -1' \
    -d "{\"id\": 2, \"label\":\"Access Key for dhadmin\", \"key\": \"1jwKgLYi/CdfBTI9KByfYxwyQ6HUIEfnGSgakdpFjgk=\", \"expirationDate\": null, \"type\":\"DEFAULT\", \"user\":{\"id\":1,\"login\":\"dhadmin\",\"passwordHash\":\"DFXFrZ8VQIkOYECScBbBwsYinj+o8IlaLsRQ81wO+l8=\",\"passwordSalt\":\"sjQbZgcCmFxqTV4CCmGwpIHO\",\"loginAttempts\":0,\"role\":\"ADMIN\",\"status\":\"ACTIVE\",\"lastLogin\":null,\"googleLogin\":null,\"facebookLogin\":null,\"githubLogin\":null,\"entityVersion\":0,\"data\":null}, \"permissions\": [{\"id\":null,\"domains\":null,\"subnets\":null,\"actions\":null,\"networkIds\":null,\"deviceGuids\":null}]}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/access_key/keys/2

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{"increment": 100}' \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/counters/buckets/dh_counters/datatypes/accessKeyCounter

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-name_bin: Sample VirtualLed Device' \
    -d "{\"id\":1, \"name\":\"Sample VirtualLed Device\", \"permanent\": false, \"offlineTimeout\": 600, \"data\":null,\"equipment\":[]}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/device_class/keys/1

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{"increment": 100}' \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/counters/buckets/dh_counters/datatypes/deviceClassCounter

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-name_bin: VirtualLed Sample Network' \
    -d "{\"id\":1,\"key\":null,\"name\":\"VirtualLed Sample Network\", \"description\":\"A DeviceHive network for VirtualLed sample\",\"entityVersion\":null}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/network/keys/1

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{"increment": 100}' \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/counters/buckets/dh_counters/datatypes/networkCounter

curl -XPUT \
    -H "Content-Type: application/json" \
    -H 'x-riak-index-guid_bin: e50d6085-2aba-48e9-b1c3-73c673e414be' \
    -d "{\"id\":1, \"guid\":\"e50d6085-2aba-48e9-b1c3-73c673e414be\", \"name\":\"Sample VirtualLed Device\", \"status\":\"Offline\", \"network\": {\"id\":1,\"key\":null,\"name\":\"VirtualLed Sample Network\", \"description\":\"A DeviceHive network for VirtualLed sample\",\"entityVersion\":null}, \"deviceClass\":{\"id\":1, \"name\":\"Sample VirtualLed Device\", \"permanent\": false, \"offlineTimeout\": 600, \"data\":null,\"equipment\":null}, \"blocked\":null}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/device/keys/1

curl -XPOST \
    -H "Content-Type: application/json" \
    -d '{"increment": 100}' \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/counters/buckets/dh_counters/datatypes/deviceCounter

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"false\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/google.identity.allowed

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"google_id\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/google.identity.client.id

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"false\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/facebook.identity.allowed

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"facebook_id\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/facebook.identity.client.id

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"false\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/github.identity.allowed

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"github_id\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/github.identity.client.id

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"true\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/allowNetworkAutoCreate

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":\"http://${DH_RIAK_HOST}:8080/cassandra\"}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/cassandra.rest.endpoint

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":120000}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/websocket.ping.timeout

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":1200000}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/session.timeout

curl -XPUT \
    -H "Content-Type: application/json" \
    -d "{\"value\":1000}" \
    http://${DH_RIAK_HOST}:${DH_RIAK_HTTP_PORT}/types/default/buckets/configuration/keys/user.login.lastTimeout

echo "Starting DeviceHive"

java -server -Xmx512m -XX:MaxRAMFraction=1 -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark -jar \
-Dflyway.enabled=false \
-Driak.host=${DH_RIAK_HOST} \
-Driak.port=${DH_RIAK_PORT} \
-Dbootstrap.servers=${DH_KAFKA_ADDRESS}:${DH_KAFKA_PORT} \
-Dzookeeper.connect=${DH_ZK_ADDRESS}:${DH_ZK_PORT} \
-Dthreads.count=${DH_KAFKA_THREADS_COUNT:-3} \
-Dhazelcast.port=${DH_HAZELCAST_PORT:-5701} \
-Dserver.context-path=/api \
-Dserver.port=8080 \
./devicehive-services-${DH_VERSION}-boot.jar

set +x