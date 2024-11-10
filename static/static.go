package static

import (
	"embed"
	"net/http"
	"strings"
)

//go:embed all:styles/dist
var stylesFS embed.FS

func Styles() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		target := r.URL.Path

		if strings.Contains(r.Header.Get("Accept-Encoding"), "gzip") {
			target += ".gz"
			w.Header().Set("Content-Encoding", "gzip")
		}

		http.ServeFileFS(w, r, stylesFS, target)
	})
}

//go:embed all:scripts/dist
var scriptsFS embed.FS

func Scripts() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		target := r.URL.Path

		if strings.Contains(r.Header.Get("Accept-Encoding"), "gzip") {
			target += ".gz"
			w.Header().Set("Content-Encoding", "gzip")
		}

		http.ServeFileFS(w, r, scriptsFS, target)
	})
}
