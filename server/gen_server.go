package server

import (
	"log/slog"
	"net/http"
	"time"

	"github.com/dvordrova/go-server-template/utils"
	"github.com/go-fuego/fuego"
)

type Server struct {
	fuegoServer *fuego.Server
}

func NewServer(handler *Handler, appName string, proxyEndpoint string, options ...func(*fuego.Server)) *Server {
	server := &Server{fuegoServer: fuego.NewServer(options...)}
	fuego.Use(server.fuegoServer, func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			slog.Info(r.URL.Path)
			ctx, traceSpan := utils.TraceRequest(r)
			defer traceSpan.End()
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	})

	fuego.Get(server.fuegoServer, "/hello", func(c fuego.ContextNoBody) (HelloWorldResponse, error) {
		time.Sleep(time.Millisecond * 200)
		return handler.HelloWorld()
	}).Summary("HelloWorld").Description("HelloWorld")
	fuego.Get(server.fuegoServer, "/proxy", func(c fuego.ContextNoBody) (HelloWorldResponse, error) {
		utils.SendRequest(c.Context(), http.MethodGet, proxyEndpoint+"/hello", nil)
		return handler.HelloWorld()
	}).Summary("Proxy").Description("Proxy")

	return server
}

func (server *Server) Run() {
	server.fuegoServer.Run()
}
