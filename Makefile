.PHONY: proto proto_format

REGISTRY_DOMAIN := stoikheia

init:
	minikube docker-env > .direnv

build:
	docker build -f Dockerfile-client -t ${REGISTRY_DOMAIN}/client-side-lb:client .
	docker build -f Dockerfile-server -t ${REGISTRY_DOMAIN}/client-side-lb:server .

clean:
	docker image rm ${REGISTRY_DOMAIN}/client-side-lb:server
	docker image rm ${REGISTRY_DOMAIN}/client-side-lb:client

push:
	docker push ${REGISTRY_DOMAIN}/client-side-lb:client
	docker push ${REGISTRY_DOMAIN}/client-side-lb:server

minikubebuild:
	minikube image build -f Dockerfile-client -t ${REGISTRY_DOMAIN}/client-side-lb:client .
	minikube image build -f Dockerfile-server -t ${REGISTRY_DOMAIN}/client-side-lb:server .

stop:
	kubectl scale deployments server-deployment --replicas=0
	kubectl scale deployments client-deployment --replicas=0

start:
	kubectl scale deployments server-deployment --replicas=3
	kubectl scale deployments client-deployment --replicas=1

k8screate:
	kubectl create -f master/server-deploy.yml
	kubectl create -f master/client-deploy.yml

k8sdelete:
	kubectl delete -f master/server-deploy.yml
	kubectl delete -f master/client-deploy.yml

k8simagels:
	minikube image ls --format table

k8slogsserver:
	kubectl logs -l app=server

k8slogsclient:
	kubectl logs -l app=client

k8sdesclibeall:
	kubectl describe all

proto: proto_format
	protoc \
	-I=./proto \
	--go_out=. \
	--go-grpc_out=. \
	--go_opt=paths=source_relative \
	./proto/*.proto

proto_format:
	find ./proto/ -name "*.proto" | xargs clang-format -i

