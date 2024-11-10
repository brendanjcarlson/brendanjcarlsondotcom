#!/usr/bin/env bash

build_styles() {
    rm -rf ./static/styles/dist
    mkdir -p ./static/styles/dist

    local pids=()
    for FILE in ./static/styles/src/**; do
        if ! [ -f "$FILE" ]; then
            continue
        fi

        npx lightningcss \
            --bundle \
            --minify \
            --sourcemap \
            --targets ">= 0.25%" \
            $FILE \
            -o "./static/styles/dist/$(basename $FILE .css).min.css" & pids+=($!)
    done
    wait "${pids[@]}"

    local pids=()
    for FILE in ./static/styles/dist/**; do
        gzip --best -k -S .gz $FILE & pids+=($!)
    done
    wait "${pids[@]}"
}

build_scripts() {
    rm -rf ./static/scripts/dist
    mkdir -p ./static/scripts/dist

    local pids=()
    for FILE in ./static/scripts/src/**; do
        if ! [ -f "$FILE" ]; then
            continue
        fi

        npx esbuild \
            $FILE \
            --bundle \
            --minify \
            --sourcemap \
            --outfile="./static/scripts/dist/$(basename $FILE .ts).min.js" \
            --target=es2016 \
            --format=iife \
            --log-level=warning & pids+=($!)
    done
    wait "${pids[@]}"

    local pids=()
    for FILE in ./static/scripts/dist/**; do
        gzip --best -k -S .gz $FILE & pids+=($!)
    done
    wait "${pids[@]}"
}

build_go() {
    go build -o ./bin/web ./cmd/web/main.go
}

build() {
    local pids=()

    build_styles & pids+=($!)
    build_scripts & pids+=($!)

    wait "${pids[@]}"

    build_go
}

build
