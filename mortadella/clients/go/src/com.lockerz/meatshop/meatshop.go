package main

import (
	"code.google.com/p/rsc/devweb/slave"
	"com.lockerz/meatshop/handlers"
	"net/http"
)

func main() {
	http.HandleFunc("/", handlers.Handler)
	slave.Main()
}
