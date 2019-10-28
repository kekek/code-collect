include .env_makefile

## If the first argument is "run"...
# ifeq (run,$(firstword $(MAKECMDGOALS)))
##   use the rest as arguments for "run"
#  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#  # ...and turn them into do-nothing targets
#  $(eval $(RUN_ARGS):;@:)
# endif


## color output
NO_COLOR=\x1b[0m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m
WHITE_COLOR=\x1b[1;37m
GRAY_COLOR=\x1b[0;37m

### https://bixense.com/clicolors/

# Go parameters
GOCMD=GO111MODULE=on go
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test

# build version info
GIT_VERSION=$(shell git rev-parse --short HEAD)
DATE_VERSION=$(shell date +%Y%m%d%H%M)

PACKAGE=$(shell head -n 1 go.mod | cut -f 2 -d " ")

# Binary names
#BINARY_FILE_NAME=$(PROJECT)
#BINARY_UNIX_NAME=$(PROJECT)_linux
#VERSION_BINARY_UNIX_NAME=$(BINARY_UNIX)-$(GIT_VERSION)-$(DATE_VERSION)

BIN_DIR=bin

### build编译时传入version参数
IDFLAG_DSC=-ldflags "-X ${PACKAGE}/config.GitLog=${GIT_VERSION} -X  ${PACKAGE}/config.DateVersion=${DATE_VERSION} "
#$package/config.GitLog=$GITLOGVERSION  -X $package/config.DateVersion=$NOW

.PHONY : build build-linux docker scp transport publish clean color build-linux-exec build-exec check

build: clean build-exec

build-linux : clean build-linux-exec

scp: transport

build-exec:
	if [ ! -d $(BIN_DIR) ]; then mkdir $(BIN_DIR) ; fi
	$(foreach program, $(PROGRAMS), $(shell $(GOBUILD) ${IDFLAG_DSC} -mod=vendor -v -o $(BIN_DIR)/$(program)_linux cmd/$(program)/*))

build-linux-exec:
	if [ ! -d $(BIN_DIR) ]; then mkdir $(BIN_DIR) ; fi
		$(foreach program, $(PROGRAMS), $(shell GOOS=linux $(GOBUILD) -mod=vendor ${IDFLAG_DSC} -v -o $(BIN_DIR)/$(program)_linux cmd/$(program)/*))

docker:
	docker run --rm -v $(PWD):/project -w /project golang:1.13  make build

transport:
	@echo $(SERVERS)
	@echo $(PROGRAMS)
	@echo $(PROJECT)
	$(foreach ip, $(SERVERS), $(foreach pro, $(shell ls $(BIN_DIR)), $(call scp-to-server, $(pro), $(ip), $(PROJECT))))

publish:
	$(foreach ip, $(SERVERS), $(foreach pro, $(PROGRAMS), $(call restart-service-on-server, $(pro), $(ip), $(PROJECT))))

check:
	$(foreach ip, $(SERVERS), $(foreach pro, $(PROGRAMS), $(call check-active, $(pro), $(ip), $(PROJECT))))


clean:
	rm -rf $(BIN_DIR)/

color:

	@echo "${OK_COLOR} ok ${NO_COLOR}"
	@echo "${ERROR_COLOR} error ${NO_COLOR}"
	@echo "${WARN_COLOR} warn ${NO_COLOR}"


test:

	@echo $(PROGRAMS)

api:
	./bin/api_linux
server:
	./bin/server_linux
admin:
	./bin/admin_linux
web:
	./bin/web_linux

################################# self-define functions############################################################
### 发送编译好的二进制文件到服务器
### 1 : program [api,admin, server]
### 2 : ip
### 3 : PROJECT
define scp-to-server

	@echo "--- scp-to-server called now: "
	@echo "--- scp $(BIN_DIR)/$(strip $(1)) root@$(strip $(2)):$(DEPLOY_ROOT_PATH)/$(strip $(3))/bin/ "
	scp $(BIN_DIR)/$(strip $(1)) root@$(strip $(2)):$(DEPLOY_ROOT_PATH)/$(strip $(3))/bin/

endef

### 登录远程服务器，替换重启服务
### 1 : program [api,admin, server]
### 2 : ip
### 3 : PROJECT
define restart-service-on-server

	@echo "--- restart-service-on-server called now: "
	@echo "--- ssh root@$(strip $(2)) $(SCRIPT_PATH) $(strip $(3)) $(1)"
	ssh root@$(strip $(2)) $(SCRIPT_PATH) $(strip $(3)) $(1)

endef


### 检查更新是否成功
### 1 : program [api,admin, server]
### 2 : ip
### 3 : PROJECT
define check-active

	@echo "--- check-active called now: "
#	@echo "--- ssh root@$(strip $(2)) $(SCRIPT_PATH) $(strip $(3)) $(1)"
	ssh root@$(strip $(2)) $(CHECK_SCRIPT_PATH) $(strip $(3)) $(1)

endef

################################# self-define functions END############################################################


