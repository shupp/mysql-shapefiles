RELEASE=2020d
TZ_FILE=timezones-with-oceans.shapefile.zip
GITHUB_URL=https://github.com/evansiroky/timezone-boundary-builder/releases/download/$(RELEASE)/$(TZ_FILE)
IMAGE=shupp/shapefile-seed-client

help:
	@# Helper for listing available targets
	@echo "\nAvailable targets: \n"
	@grep -oE '^[a-zA-Z0-9_.%-]+:([^=]|$$)' Makefile | grep -v '.PHONY' | sed -e 's/:.*$$//' | sort

all: up logs

build:
	docker build -t $(IMAGE):latest .

$(TZ_FILE):
	curl -sLO $(GITHUB_URL)

up: $(TZ_FILE)
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

shell:
	docker-compose exec db bash

clean:
	rm -f $(TZ_FILE)

clean-images:
	docker rmi -f mariadb:latest $(IMAGE):latest alpine:latest


# For debugging
db-bash:
	docker run \
		-v $(PWD)/check.sh:/check.sh \
		--rm \
		-it \
		mariadb:latest \
		bash

seed-bash: $(TZ_FILE)
	docker run \
		-v $(PWD)/$(TZ_FILE):/$(TZ_FILE) \
		--rm \
		-it \
		--entrypoint bash \
		$(IMAGE):latest
