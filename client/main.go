package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	pb "github.com/jun06t/grpc-sample/client-side-lb/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/resolver"
)

var (
	endpoint = "localhost:8080"
)

func init() {
	ep := os.Getenv("ENDPOINT")
	if ep != "" {
		endpoint = ep
	}
}

func main() {
	fmt.Println("Endpoint: ", endpoint)
	conn, err := getConn()
	// conn, err := getConnDeprecated()
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	c := pb.NewGreeterClient(conn)

	req := &pb.HelloRequest{
		Name: "alice",
	}
	for {
		resp, err := c.SayHello(context.Background(), req)
		if err != nil {
			log.Fatal(err)
		}
		log.Printf("Machine: %s, Reply: %s\n", resp.MachineId, resp.Message)
		time.Sleep(1 * time.Second)
	}
}

func getConn() (*grpc.ClientConn, error) {
	resolver.SetDefaultScheme("dns")
	conn, err := grpc.Dial(endpoint,
		grpc.WithInsecure(),
		grpc.WithDefaultServiceConfig(`{"loadBalancingConfig": [{"round_robin":{}}]}`),
	)
	return conn, err
}

// func getConnDeprecated() (*grpc.ClientConn, error) {
// 	resolver, _ := resolver.NewDNSResolverWithFreq(5 * time.Second)
// 	balancer := grpc.RoundRobin(resolver)
// 	conn, err := grpc.Dial(endpoint,
// 		grpc.WithInsecure(),
// 		grpc.WithBalancer(balancer),
// 	)
// 	return conn, err
// }
