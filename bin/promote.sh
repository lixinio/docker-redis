#!/usr/bin/env bash
MASTERIP=$6
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

# Convert the IP of the promoted pod to a hostname
MASTERPOD=`kubectl -n $NAMESPACE get pod -o jsonpath='{range .items[*]}{.metadata.name} {..podIP} {.status.containerStatuses[0].state}{"\n"}{end}' -l redis-role=slave --sort-by=.metadata.name|grep running|grep $MASTERIP|awk '{print $1}'`
echo "PROMO ARGS: $@"
echo "PROMOTING $MASTERPOD ($MASTERIP) TO MASTER"
kubectl -n $NAMESPACE label --overwrite pod $MASTERPOD redis-role="master"

# Demote anyone else who jumped to master
kubectl -n $NAMESPACE get pod -o jsonpath='{range .items[*]}{.metadata.name} {.status.containerStatuses[0].state}{"\n"}{end}' -l redis-role=master --sort-by=.metadata.name|grep running|awk '{print $1}'|grep $REDIS_PREFIX|grep -v $MASTERPOD|xargs -n1 -I% kubectl -n $NAMESPACE label --overwrite pod % redis-role="slave"
echo "OTHER MASTERS $MASTERS"
