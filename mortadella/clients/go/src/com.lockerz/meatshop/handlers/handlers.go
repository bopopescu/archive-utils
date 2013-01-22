package handlers

import (
	"net/http"
	"com.lockerz/meatshop/route"
	"github.com/gorilla/schema"	
)

var Decoder *schema.Decoder
	

func init() {
	Decoder = schema.NewDecoder()
	RegisterMeatHandlers(route.Router)
	RegisterUserHandlers(route.Router)
	http.Handle("/static/", 
		http.StripPrefix("/static/", http.FileServer(http.Dir("resources/static/"))))
}

func Handler (w http.ResponseWriter, r *http.Request) {
	route.Router.ServeHTTP(w, r)
}






