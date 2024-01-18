#!/usr/bin/env bash
echo "复制redis.con到指定位置(不同镜像，位置不同)"
cp /tmp/redis/conf/redis-conf /etc/redis/redis.conf
REDIS_PASSWORD=$(cat /tmp/redis/secret/password)
echo "修改一些公共参数"
cat >> /etc/redis/redis.conf <<EOF

port 6379
bind 0.0.0.0
dbfilename dump.rdb
dir /data
appendonly yes
appendfilename "appendonly.aof"
requirepass $REDIS_PASSWORD
EOF

if [ "$(redis-cli -h sentinel -p 26379 ping)" != "PONG" ]; then
    echo "Sentinel 没有找到 master, 默认设置 redis-0 为master"
    if [ "$(hostname)" = "redis-0" ]; then
        echo "主节点是redis-0, 不需要修改配置"
    else
        echo "其他节点认为是slave, 修改redis.conf开启复制"
        # 获取master 全域名 redis-0.redis-headless.zz-redis.svc.cluster.local
        MASTER_FDQN=`hostname -f | sed -e 's/redis-[0-9]\./redis-0./'`
        cat >> /etc/redis/redis.conf <<EOF

masterauth $REDIS_PASSWORD
replicaof $MASTER_FDQN 6379
EOF
    fi
else
    echo "Sentinel 找到了 master"
    MASTER="$(redis-cli -h sentinel -p 26379 sentinel get-master-addr-by-name mymaster | grep -E '(^redis-\d{1,})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})')"
    echo "Master got: $MASTER, updating this in redis.conf"
    echo -e "\nreplicaof $MASTER 6379" >> /etc/redis/redis.conf
fi
cat /etc/redis/redis.conf