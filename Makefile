build:
	docker build . -t atomenger/tmate-alpine
push: build
	docker push atomenger/tmate-alpine
