KUBECTL=/usr/bin/kubectl
DRY_RUN=--dry-run=client
OUT_YAML=-o yaml

REDIS_DIR=./redis
REDIS_CLI_COMMAND=redis-cli -a 123456 --raw --no-auth-warning
REDIS_M_EXEC=${KUBECTL} exec -it redis-0 -- bash
REDIS_S1_EXEC=${KUBECTL} exec -it redis-1 -- bash
REDIS_S2_EXEC=${KUBECTL} exec -it redis-2 -- bash
REDIS_S3_EXEC=${KUBECTL} exec -it redis-3 -- bash

SENTINEL_DIR=./sentinel
SENTINEL_CLI_COMMAND=redis-cli -p 26379
SENTINEL_0_EXEC=${KUBECTL} exec -it sentinel-0 -- bash
SENTINEL_1_EXEC=${KUBECTL} exec -it sentinel-1 -- bash
SENTINEL_2_EXEC=${KUBECTL} exec -it sentinel-2 -- bash

.PHONY: help test
help:
	@echo "usage: make <option>"
	@echo "options and effects:"
	@echo "    help                     : Show help"
	@echo "    test                     : Test ..."

test:
	@echo "test ..."
	redis-cli -a 123456 --no-auth-warning -p 32001

# 部署statefulset
.PHONY: ra rdel sa sdel po
ra:
	${KUBECTL} apply -f ${REDIS_DIR}/redis.yaml
rdel:
	${KUBECTL} delete -f ${REDIS_DIR}/redis.yaml

sa:
	${KUBECTL} apply -f ${SENTINEL_DIR}/sentinel.yaml
sdel:
	${KUBECTL} delete -f ${SENTINEL_DIR}/sentinel.yaml

po:
	${KUBECTL} get po -o wide

# Redis #########################################################

# 进入容器命令
.PHONY: en-redis-0 en-redis-1 en-redis-2 en-redis-3 en-box en-sentinel-1
en-redis-0:
	${REDIS_M_EXEC}
en-redis-1:
	${REDIS_S1_EXEC}
en-redis-2:
	${REDIS_S2_EXEC}
en-redis-3:
	${REDIS_S3_EXEC}
en-box:
	${KUBECTL} exec -it box-0 -- sh

# 登录redis
.PHONY: login-redis-0 login-redis-1 login-redis-2 login-redis-3
login-redis-0:
	${REDIS_M_EXEC} -c "${REDIS_CLI_COMMAND}"
login-redis-1:
	${REDIS_S1_EXEC} -c "${REDIS_CLI_COMMAND}"
login-redis-2:
	${REDIS_S2_EXEC} -c "${REDIS_CLI_COMMAND}"
login-redis-3:
	${REDIS_S3_EXEC} -c "${REDIS_CLI_COMMAND}"

# 测试
.PHONY: print-m-replication-info search-m-info
print-m-replication-info:
	@${REDIS_M_EXEC} -c "${REDIS_CLI_COMMAND} INFO replication"
search-m-info:
	@${REDIS_S1_EXEC} -c "${REDIS_CLI_COMMAND} INFO replication" | awk '{print $1}' | grep master_host: | cut -d ":" -f2

# Sentinel #########################################################

# 进入容器
.PHONY: en-sentinel-0 en-sentinel-1 en-sentinel-2
en-sentinel-0:
	${SENTINEL_0_EXEC}
en-sentinel-1:
	${SENTINEL_1_EXEC}
en-sentinel-2:
	${SENTINEL_2_EXEC}

# 登录sentinel
.PHONY: login-sentinel-0 login-sentinel-1 login-sentinel-2
login-sentinel-0:
	${SENTINEL_0_EXEC} -c "${SENTINEL_CLI_COMMAND}"
login-sentinel-1:
	${SENTINEL_1_EXEC} -c "${SENTINEL_CLI_COMMAND}"
login-sentinel-2:
	${SENTINEL_2_EXEC} -c "${SENTINEL_CLI_COMMAND}"

.PHONY: 
sentinel-master-info:
	@${SENTINEL_0_EXEC} -c "${SENTINEL_CLI_COMMAND} sentinel master mymaster"