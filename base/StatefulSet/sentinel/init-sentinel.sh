#!/usr/bin/env bash
echo "复制sentinel.conf到指定位置(不同镜像，位置不同)"
cp /tmp/redis/conf/sentinel-conf /etc/redis/sentinel.conf
REDIS_PASSWORD=$(cat /tmp/redis/secret/password)
nodes=redis-0,redis-1,redis-2,redis-3
echo "循环节点直到查到master信息"
for i in ${nodes//,/ }
do
    # 按规则拼接全域名访问
    NODE_NAME="$i.redis-headless.zz-redis.svc.cluster.local"
    MASTER=$(redis-cli --no-auth-warning --raw -h $NODE_NAME -a $REDIS_PASSWORD info replication | tr -d '\r' | awk '{print $1}' | grep master_host: | cut -d ":" -f2)
    if [ "$MASTER" = "" ]; then
        echo "no master info found in $NODE_NAME"
        MASTER=""
    else
        echo "found master info"
        break
    fi
done

echo "修改sentinel.conf"
cat >> /etc/redis/sentinel.conf << EOF

SENTINEL monitor mymaster $MASTER 6379 2
SENTINEL resolve-hostnames yes
SENTINEL announce-hostnames yes
SENTINEL down-after-milliseconds mymaster 5000
SENTINEL failover-timeout mymaster 60000
SENTINEL parallel-syncs mymaster 1
SENTINEL auth-pass mymaster $REDIS_PASSWORD
EOF

cat /etc/redis/sentinel.conf