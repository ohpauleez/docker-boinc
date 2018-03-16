
## Docker and Singularity settings
SINGULARITY_BIN = $(HOME)/bin/singularity
SREG = sregistry
DOCKER_BIN = /usr/bin/docker

#CONTAINER_IMAGE = laurentmalvert/docker-boinc
DOCKER_IMAGE = ohpauleez/boinc-client:1.0
DOCKER_CMD_IMAGE = laurentmalvert/docker-boinccmd
SINGULARITY_IMAGE = boinc-client.simg


## Dumping ground
## --------------------------------
#
# Sometimes you need to use sregistry to pull the base images before you build Singularity images,
# because of an error with building as root (and tar archives not looking like archives)
#$(SREG) pull docker://debian:stretch && \

docker-image:
	$(DOCKER_BIN) build -t $(DOCKER_IMAGE) .

start-docker-client:
	docker run --name boinc-client -d $(DOCKER_IMAGE) --allow_remote_gui_rpc

stop-docker-client:
	docker stop boinc-client && \
	docker rm boinc-client;

client-state:
	docker run --rm --link boinc-client:boinc-client $(DOCKER_CMD_IMAGE) --host boinc-client --get_state


singularity-image:
	sudo $(SINGULARITY_BIN) build $(SINGULARITY_IMAGE) Singularity

start-singularity-instance:
	sudo $(SINGULARITY_BIN) instance.start $(SINGULARITY_IMAGE) boinc-client

stop-singularity-instance:
	sudo $(SINGULARITY_BIN) instance.stop boinc-client


