root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
backend_img_sha := $(shell docker images -q localhost:32000/backend-image:latest)
frontend_img_sha := $(shell docker images -q localhost:32000/frontend-image:latest)
kubernetes_namespace := tiny-django
backend_pod_name := backend-deployment
helm_installation_name := tiny-django

backend_build:
	docker build -t localhost:32000/backend-image:latest -f Dockerfile.back_dev back -q
backend_push:
	docker push localhost:32000/backend-image:latest
backend_run:
	echo "Running backend $(backend_img_sha)"
	docker run --init --add-host=host.docker.internal:host-gateway -p 8000:8000 -v $(root_dir)/back:/back -it $(backend_img_sha)

backend_migrate_static:
	docker run -v $(root_dir)/back:/back -it $(backend_img_sha) python3 app.py makemigrations
	docker run -v $(root_dir)/back:/back -it $(backend_img_sha) python3 app.py migrate
	docker run -v $(root_dir)/back:/back -it $(backend_img_sha) python3 app.py collectstatic --noinput

backend_build_push:
	$(MAKE) backend_build
	$(MAKE) backend_push
	
frontend_build:
	docker build --progress=plain -t localhost:32000/frontend-image:latest -f Dockerfile.front_dev front -q
frontend_push:
	docker push localhost:32000/frontend-image:latest
frontend_run:
	docker run --init --add-host=host.docker.internal:host-gateway -p 3000:3000 -v $(root_dir)/front:/front -it $(frontend_img_sha)
	
frontend_build_push:
	$(MAKE) frontend_build
	$(MAKE) frontend_push
	
microk8s_attach_backend:
	microk8s kubectl exec --stdin --tty $(backend_pod_name) -n $(kubernetes_namespace) -- sh
	
microk8s_route_backend_local:
	microk8s kubectl port-forward $(backend_pod_name) 8000:8000 -n $(kubernetes_namespace)
	
microk8s_setup:
	microk8s status
	microk8s enable helm ingress dns registry
	microk8s create namespace $(kubernetes_namespace)
	
microk8s_status:
	microk8s kubectl get all -n $(kubernetes_namespace)
	
helm_dry_install:
	microk8s helm install --debug $(helm_installation_name) ./helm-chart/ --set rootDir=$(root_dir) --dry-run
	
helm_install:
	microk8s helm install --debug $(helm_installation_name) ./helm-chart/ --set rootDir=$(root_dir)

helm_uninstall:
	microk8s helm uninstall $(helm_installation_name)