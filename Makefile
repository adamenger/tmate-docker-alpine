build:
	docker build . -t atomenger/tmate-alpine:latest
push: build
	docker push atomenger/tmate-alpine:latest
