.SILENT:

include ./.env

rabbitmq-hosts:
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_RABBITMQ}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_RABBITMQ}' | sudo tee -a "${HOSTS}"
mailhog-hosts:
	grep -q "127.0.0.1 ${LOCAL_HOSTNAME_MAILHOG}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_MAILHOG}' | sudo tee -a "${HOSTS}"
redis-commander-hosts:
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_REDIS_COMMANDER}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_REDIS_COMMANDER}' | sudo tee -a "${HOSTS}"
lms-hosts:
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_LMS}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_LMS}' | sudo tee -a "${HOSTS}"
lms-git-clone:
	- git clone ${REPOSITORY}:gushinDev/lms.git -b ${BRANCH_LMS} ${LOCAL_CODE_PATH_LMS}
lms-git-pull:
	cd ${LOCAL_CODE_PATH_LMS} && git pull
lms-git-checkout:
	cd ${LOCAL_CODE_PATH_LMS} && git checkout ${BRANCH_LMS}
lms-env-copy:
	yes | cp -rf env-example/.lms.env.example ${LOCAL_CODE_PATH_LMS}/.env
lms-install:
	docker-compose exec lms composer update  | tee ./logs/composer-logs/lms-install.log
	docker-compose exec lms composer install  | tee ./logs/composer-logs/lms-install.log
lms-migrate-seed:
	docker-compose exec -T lms php artisan migrate | tee ./logs/migrate-logs/lms-migrate.log
	docker-compose exec -T lms php artisan db:seed | tee ./logs/migrate-logs/lms-migrate-seed.log

notifications-hosts:
	grep -q "127.0.0.1  ${LOCAL_HOSTNAME_NOTIFICATIONS}" "${HOSTS}" || echo '127.0.0.1  ${LOCAL_HOSTNAME_NOTIFICATIONS}' | sudo tee -a "${HOSTS}"
notifications-git-clone:
	- git clone git@github.com:gushinDev/notifications.git -b ${MAIN_BRANCH} ${LOCAL_CODE_PATH_NOTIFICATIONS}
notifications-git-pull:
	cd ${LOCAL_CODE_PATH_NOTIFICATIONS} && git pull
notifications-git-checkout:
	cd ${LOCAL_CODE_PATH_NOTIFICATIONS} && git checkout ${MAIN_BRANCH}
notifications-env-copy:
	yes | cp -rf env-example/.lms-notifications.env.example ${LOCAL_CODE_PATH_NOTIFICATIONS}/.env
notifications-install:
	docker-compose exec notifications composer update  | tee ./logs/composer-logs/notifications-install.log
	docker-compose exec notifications composer install  | tee ./logs/composer-logs/notifications-install.log
notifications-migrate-seed:
	docker-compose exec -T notifications php artisan migrate | tee ./logs/migrate-logs/notifications-migrate.log
	docker-compose exec -T notifications php artisan db:seed | tee ./logs/migrate-logs/notifications-migrate-seed.log

hosts:
	make \
		lms-hosts \
		notifications-hosts
git-clone:
	make \
		lms-git-clone \
		notifications-git-clone
git-pull:
	make \
		lms-git-pull \
		notifications-git-pull
git-checkout:
	make \
		lms-git-checkout \
		notifications-git-checkout

env-copy:
	make \
		lms-env-copy \
		notifications-env-copy

install:
	make \
		lms-install \
		notifications-install

migrate:
	make \
		lms-migrate \
		notifications-migrate

migrate-seed:
	make \
		lms-migrate-seed \
		notifications-migrate-seed

lms: hosts git-clone git-checkout env-copy network build up install migrate-seed

network:
	docker network inspect app-network >/dev/null 2>&1 || docker network create app-network

build:
	docker-compose build
up:
	docker-compose up -d
restart:
	docker-compose restart
down:
	docker-compose down
clean-build-cache:
	yes | docker builder prune -a
clean: clean-build-cache
	docker-compose down --rmi local
down-v:
	docker-compose down -v --rmi local
workers-up:
	docker-compose -f docker-compose-workers.yml up -d
workers-down:
	docker-compose -f docker-compose-workers.yml down
tests-up:
	docker-compose -f docker-compose-tests.yml up -d
tests-down:
	docker-compose -f docker-compose-tests.yml down





