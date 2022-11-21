.PHONY: default
default:
	@echo "No default target; see 'deploy' target"

.PHONY: deploy
deploy:
	podman build . --tag clickme_server
	podman save -o clickme_server.tar localhost/clickme_server:latest
	scp clickme_server.tar clickme.case.edu:~
	rm clickme_server.tar
	ssh clickme.case.edu "podman load -i ~/clickme_server.tar && rm clickme_server.tar && systemctl --user stop clickme-server.service && podman run --env-file /home/simon/clickme/VARS.env -v /home/simon/clickme/db/:/var/clickme/db:rw,U --rm localhost/clickme_server:latest /app/bin/migrate && systemctl --user restart clickme-server.service"
