IMAGE=aknudsen/rethinkdb-kubernetes
TAG=2.4.0-v2

probe: probe.go
	./build-probe.sh

image: probe
	docker build -t ${IMAGE}:${TAG} .

push: image
	docker push ${IMAGE}:${TAG}
