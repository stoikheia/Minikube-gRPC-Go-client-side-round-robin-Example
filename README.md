# Client Side LB sample

Reference: https://christina04.hatenablog.com/entry/grpc-client-side-lb

## Init for minikube (using direnv)
```
make init
direnv allow .
```

## Compile proto
```
make proto
```

## Build docker image
```
make build
```


## Run servers and client
```
make k8screate
```

## observe server log
```
make k8slogserver
```

## stop
```
make k8sdelete
```

## clean (remove docker images)
```
make clean
```
