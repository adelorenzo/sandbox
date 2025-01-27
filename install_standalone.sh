#Add docker in docker
docker volume create standalone-certs-ca
docker volume create standalone-certs-ca-client
docker run --privileged --name standalone \
--restart=always -d \
-e DOCKER_TLS_CERTDIR=/certs \
-v standalone-certs-ca:/certs/ca \
-v standalone-certs-ca-client:/certs/client \
docker:dind
sleep 3

#Install Portainer Agent
docker exec standalone /usr/local/bin/docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent

#Add docker endpoint
#docker exec -it standalone /sbin/ip a show eth0 | grep inet | awk '{ print $2 }' | sed 's/.\{3\}$//' > /root/.standalone_ip
#standalone_ip=`cat .standalone_ip`
#jwt=`http POST :9000/api/auth Username="portainer" Password="portainer1234" | jq '.jwt' | sed 's/^.//' | sed 's/.$//'`
#http --form POST :9000/api/endpoints "Authorization: Bearer $jwt" Name="docker" URL="tcp://$standalone_ip:9001" EndpointCreationType=2  TLS="true" TLSSkipVerify="true" TLSSkipClientVerify="true"
