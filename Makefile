IMAGE = ansible
CONTAINER = ansible
PORT = 30022
USER = ansible

all: build

build:
	docker build . -t ${IMAGE}

run:
	docker run -d --name ${CONTAINER} -p ${PORT}:22 ${IMAGE}

ssh:
	ssh -p ${PORT} -o 'StrictHostKeyChecking no' ${USER}@localhost

clean-ssh:
	ssh-keygen -R [localhost]:${PORT}

bash:
	docker run -it --rm ${IMAGE} /bin/bash

rm:
	docker stop ${CONTAINER} && docker rm ${CONTAINER}

rmi:
	docker rmi ${IMAGE}

