root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
backend_img_sha := $(shell docker images -q localhost:32000/backend-image:latest)
backend_build:
	docker build -t localhost:32000/backend-image:latest -f Dockerfile.back_dev back -q
backend_push:
	docker push localhost:32000/backend-image:latest
backend_run:
	echo "Running backend $(backend_img_sha)"
	docker run --init -p 8000:8000 -v $(root_dir)/back:/back -it $(backend_img_sha)