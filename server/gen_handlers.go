package server

type HelloWorldResponse struct {
	Text string `json:"text"`
}

type Handler struct {
	HelloWorld func() (HelloWorldResponse, error)
}

// To generate this behaviour, redefine ReInitHandler in this package
func InitHandler(handler *Handler) {
	handler.HelloWorld = func() (HelloWorldResponse, error) {
		return HelloWorldResponse{"Hello, World!"}, nil
	}
}
