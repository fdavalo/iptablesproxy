# IPTablesProxy

IPTablesProxy is a quick invention using iptables allowing proxying of external services. By default, it will proxy any traffic it receives. To run it on its own:

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: proxy1
  namespace: openshift-ingress
spec:
  replicas: 2
  selector:
    matchLabels:
      app: proxy1
  template:
    metadata:
      labels:
        app: proxy1
      annotations:
        k8s.v1.cni.cncf.io/networks: '[{ "name": "macvlan-1085" }]'
    spec:
      containers:
        - name: container
          env:
            - name: HOSTDEV
              value: net1
            - name: SERVERIP
              value: 172.30.66.213
            - name: PORTS
              value: '80,443'
          securityContext:
            capabilities:
              add:
                - NET_ADMIN
            privileged: true
          image: 'quay.io/fdavalo/iptablesproxy:v2'
```


## Env Options

* `SERVERIP` - The IP address of the server you are proxying
* `HOSTDEV` - Device to use as source
* `PORTS` - Ports on the container you plan to expose and proxy with. List of <Source Port>:<Destination Port optional>,...

## Build it yourself

Nothing special to build this - but if you want to make sure you have the most up to date alpine source, here ya go:

```bash
$ docker build -t iptablesproxy .
```
