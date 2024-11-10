package main

import (
	"errors"
	"log/slog"
	"net/http"
	"os"

	"github.com/brendanjcarlson/brendanjcarlsondotcom/static"
)

func main() {
	mux := http.NewServeMux()

	mux.Handle("GET /static/styles/dist/", http.StripPrefix("/static/", static.Styles()))
	mux.Handle("GET /static/scripts/dist/", http.StripPrefix("/static/", static.Scripts()))

	server := &http.Server{
		Addr:    "127.0.0.1:8080",
		Handler: mux,
	}

	if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
		slog.Error("failed to start server", "err", err)
		os.Exit(1)
	}
}
