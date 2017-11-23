IMAGE=aknudsen/rethinkdb-kubernetes
TAG=2.3.6-v1

probe: probe.go
	./build-probe.sh

image: probe
	docker build -t ${IMAGE}:${TAG} .

push: image
	docker push ${IMAGE}:${TAG}
