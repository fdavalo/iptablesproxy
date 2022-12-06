#!/bin/sh

if [ -z "$SERVERIP" ]; then
  echo "Environment variable SERVERIP must be set."; exit 1;
fi

# IPTables prerouting
iptables -t nat -A PREROUTING -i ${HOSTDEV} -j DNAT --to-destination ${SERVERIP} > /dev/null 2>&1

## ...and check for privileged access real quickly like
if ! [ $? -eq 0 ]; then
    echo "Sorry, this container requires the '--cap-add=NET_ADMIN' flag to be set in order to use for iptables"; exit 1;
fi

# Create rules for postrouting
iptables -t nat -A POSTROUTING -j MASQUERADE

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

while [ true ]; do
    sleep 3600;
done
