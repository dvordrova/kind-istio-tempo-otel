package server

func ReinitHandler(handler *Handler) {
	handler.HelloWorld = func() (HelloWorldResponse, error) {
		return HelloWorldResponse{"Hello, World!"}, nil
	}
}
