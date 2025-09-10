.PHONY: bootstrap up deploy down clean

bootstrap:
	bash scripts/bootstrap.sh

up:
	bash -lc 'source ./env.sh && scripts/network-up.sh'

deploy:
	bash -lc 'source ./env.sh && scripts/deploy-go.sh vote'

down:
	bash -lc 'source ./env.sh && scripts/network-down.sh'

clean:
	rm -rf _deps env.sh organizations crypto-config wallet *.block *.tx
