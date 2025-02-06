#!make
SHELL := /usr/bin/env bash

build:
	docker compose build

fix-file-permissions:
	docker compose exec -it jupyter sudo chown -R 1000:100 /home/jovyan/workspace

setup-explorer:
	# Initialise and create product summaries
	docker compose exec -T explorer cubedash-gen --init --all
	docker compose exec -T explorer cubedash-run

get-jupyter-token:
	docker compose exec -T jupyter jupyter notebook list

init: ## Prepare the database
	docker compose exec -T jupyter datacube -v system init

add-products:
	docker compose exec -T jupyter datacube product add ./workspace/products/iwmi_blue_et_monthly.odc-product.yaml
	docker compose exec -T jupyter datacube product add ./workspace/products/iwmi_green_et_monthly.odc-product.yaml

create-stac-iwmi_blue_et_monthly:
	docker compose exec -T jupyter
	
up: ## Bring up your Docker environment
	docker compose up -d postgres
	docker compose run checkdb
	docker compose up -d jupyter
	make fix-file-permissions
	docker compose up -d explorer

down:
	docker compose down --remove-orphans

logs:
	docker compose logs