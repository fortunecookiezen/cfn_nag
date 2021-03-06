bundle:
	docker run \
		--rm \
		--volume $$(pwd):/usr/src/app \
		--workdir /usr/src/app \
		ruby:2.5 \
		bundle install

test:
	docker run \
		--tty \
		--rm \
		--volume $$(pwd):/usr/src/app \
		--workdir /usr/src/app \
		ruby:2.5 \
		./scripts/setup_and_run_end_to_end_tests.sh
