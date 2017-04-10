install:
	cp -f scripts/setup-docker-containers.sh /usr/local/bin
	cp -f scripts/teardown-docker-containers.sh /usr/local/bin
	mkdir -p /etc/docker-containers
	cp -f docker-containers.conf.example /etc/docker-containers
	cp -f systemd/docker-containers.service /etc/systemd/system/multi-user.target.wants
