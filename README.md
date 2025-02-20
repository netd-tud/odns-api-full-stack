# ODNS-API Full Stack Deployment
This repository contains the full deployment stack for the ODNS-API.
This repository contains submodules (!), use

`git clone --recursive https://github.com/netd-tud/odns-api-full-stack.git`

to also clone the submodules, otherwise it won't work without further steps.

## Network Structure
![Overview of network structure](./img/odns-api-deployment.png)

## Setup
1. Clone repository
2. Rename `.env.template` into `.env` and adjust connection values
3. Rename `config.ini.template` into `config.ini` and adjust connection values
4. Run `sudo docker compose up`

### Production Use
By default, nginx is configured to run locally and is accessible via localhost/127.0.0.1.
To change that edit the `docker-comose.yml` and change the mounted volume from 

`./nginx/odnsapi.dev.conf:`

to

`./nginx/odnsapi.prod.conf:`

Finally, adjust `./nginx/odnsapi.dev.conf` to your needs.

## Teardown
There is a teardown script which you can run with

`sudo ./teardown.sh`

which also removes the postgres volume/data completely -- so be careful.
Removing that volume is necessary when adding new scripts to `postgres-init/` 
These scripts will only run once on database creation as they are mounted to `docker-entrypoint-initdb.d/`
## ToDo List
- [ ] Makefile integration
- [ ] Healthchecks for .Net app
- [ ] ?
