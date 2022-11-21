package main

import (
	"context"
	"log"
	"net"

	pb "github.com/koalaops/GreetingService/proto"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"google.golang.org/protobuf/proto"
)

type greetingsServer struct {
	pb.UnimplementedGreetingsServer
}

func (s *greetingsServer) GetGreeting(context.Context, *pb.GreetingRequest) (*pb.GreetingResponse, error) {
	return &pb.GreetingResponse{Greeting: proto.String("Greetings Koala!")}, nil
}

func main() {
	log.Println("Starting listening on port 8080")
	port := ":8080"
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	log.Printf("Listening on %s", port)

	grpcServer := grpc.NewServer()
	reflection.Register(grpcServer)
	pb.RegisterGreetingsServer(grpcServer, &greetingsServer{})
	err = grpcServer.Serve(lis)
	if err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
