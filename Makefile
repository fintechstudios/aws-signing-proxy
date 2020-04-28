name=aws-signing-proxy
registry=fintechstudios
gitrepo=github.com/fintechstudios/aws-signing-proxy
tag=latest
go_ver=1.14

default:
	@echo ""
	@echo "make build:"
	@echo "	compiles the aws-signing-proxy app and builds the docker image"
	@echo "make gobuild:"
	@echo "	compiles the aws-signing-proxy app (binary located in ./_bin)"
	@echo "make dockbuild:"
	@echo "	builds the docker image"
	@echo "make clean:"
	@echo "	removes all temporary files and build artifacts"


build: gobuild dockbuild

dockbuild:
	[ -e ca-certificates.crt ] || wget https://curl.haxx.se/ca/cacert.pem -O ca-certificates.crt
	docker build -t ${registry}/${name}:${tag} .

docker-push: dockbuild
	docker push ${registry}/${name}:${tag}

gobuild:
	go build -o aws-signing-proxy main.go

clean:
	rm -rf ./_* ca-certificates.crt aws-signing-proxy
