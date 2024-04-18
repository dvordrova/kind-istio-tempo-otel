package main

import (
	"context"
	"flag"
	"log"

	"github.com/dvordrova/go-server-template/server"
	"github.com/dvordrova/go-server-template/utils"
	"github.com/go-fuego/fuego"
)

func main() {
	addrFlag := flag.String("address", "localhost:8080", "address to listen on")
	basePathFlag := flag.String("base-path", "", "base path for the server")
	traceEndpointFlag := flag.String("trace-endpoint", "", "trace endpoint")
	proxyEndpointFlag := flag.String("proxy-endpoint", "", "proxy endpoint")
	flag.Parse()

	ctx := context.Background()
	shutdown, err := utils.SetupOTelSDK(ctx, *traceEndpointFlag)
	if err != nil {
		log.Fatalf("failed to setup OpenTelemetry SDK: %v", err)
	}
	defer func() { _ = shutdown(ctx) }()
	handler := server.Handler{}
	server.InitHandler(&handler)
	server.ReinitHandler(&handler)
	server.NewServer(
		&handler,
		"go-server-template",
		*proxyEndpointFlag,
		fuego.WithAddr(*addrFlag),
		fuego.WithBasePath(*basePathFlag),
	).Run()
}
