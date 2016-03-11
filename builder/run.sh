#!/bin/bash
if [[ -n $BAMBOO_DOCKER_AUTO_HOST ]]; then
sed -i "s/^.*Endpoint\": \"\(http:\/\/haproxy-ip-address:8000\)\".*$/    \"EndPoint\": \"http:\/\/$HOST:8000\",/" \
    ${CONFIG_PATH:=config/production.example.json}
fi

#setting up keepalived
sed -i "s|{{ keepalived_interface }}|$KEEPALIVED_INTERFACE|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ keepalived_state }}|$KEEPALIVED_STATE|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ keepalived_priority }}|$KEEPALIVED_PRIORITY|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ keepalived_virtual_ips }}|$KEEPALIVED_VIRTUAL_IPS|g" /etc/keepalived/keepalived.conf
sed -i "s|{{ keepalived_router_id }}|$KEEPALIVED_ROUTER_ID|g" /etc/keepalived/keepalived.conf

echo net.ipv4.ip_nonlocal_bind=1 >> /etc/sysctl.conf && \
sysctl -p

haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
/usr/bin/supervisord
