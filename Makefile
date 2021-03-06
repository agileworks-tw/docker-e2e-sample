deploy-production-docker:
	- ssh jenkins@localhost docker rm -f sails_sample_prod
	ssh jenkins@localhost docker run -d --name sails_sample_prod -p 8800:1337 agileworks/sails_sample_prod

deploy-production-legacy:
	ssh jenkins@localhost mkdir -p ~/deploy/production
	scp sailsSampleProd.tar.gz jenkins@localhost:~/deploy/production
	tar -C ~/deploy/production/ -vxf ~/deploy/production/sailsSampleProd.tar.gz

package-production:
	- rm sailsSampleProd.tar.gz
	tar cvf ./sailsSampleProd.tar.gz ./

restart-production:
	- ssh jenkins@localhost cd ~/deploy/production && pm2 delete production
	ssh jenkins@localhost  cd ~/deploy/production && NODE_ENV=production pm2 start -f app.js --name 'production'

start-e2e-docker:
	- docker-compose up -d e2e-env

preview:
	- pm2 stop cargo-preview
	- pm2 delete cargo-preview
	pm2 start app.js --name cargo-preview

restart-dojo:
	- docker rm -f `docker ps -a -q`
	- docker network rm `docker network ls -q`
	git checkout .
