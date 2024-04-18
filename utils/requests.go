package utils

import (
	"context"
	"io"
	"log/slog"
	"net/http"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/propagation"
	tr "go.opentelemetry.io/otel/trace"
)

func SendRequest(ctx context.Context, method, url string, body io.Reader) (*http.Response, error) {
	ctx, span := otel.GetTracerProvider().Tracer("test").Start(
		ctx,
		"sendRequest",
		tr.WithSpanKind(tr.SpanKindClient),
	)
	defer span.End()

	req, err := http.NewRequestWithContext(ctx, method, url, body)
	if err != nil {
		slog.Info("error in creating request with context: %v", err)
		return nil, err
	}
	propagator := otel.GetTextMapPropagator()
	propagator.Inject(ctx, propagation.HeaderCarrier(req.Header))

	// Send the request
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		slog.Info("error in request: %v", err)
		return nil, err
	}
	slog.Info("good request")
	return resp, nil
}
