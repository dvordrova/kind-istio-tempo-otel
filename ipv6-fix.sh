# according to https://github.com/dvordrova/kind-istio-tempo-otel/issues/1

# change settings
if [ ! -f /etc/docker/daemon.json ];
    then echo "{}" > /etc/docker/daemon.json;
fi;
echo $(jq ' . += { "ip6tables": false }' /etc/docker/daemon.json) > /etc/docker/daemon.json;

# restart dockerd
DOCKERD_CMD=$(ps aux | grep [d]ockerd | awk 'NF{print $(NF-2),$(NF-1),$NF}');
pkill dockerd && \
    while pgrep -l dockerd; do sleep 1; done;
echo "RUN $DOCKERD_CMD"
$DOCKERD_CMD > /dev/null 2>&1 &
