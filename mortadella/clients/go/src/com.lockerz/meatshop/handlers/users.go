package handlers

import (
	"fmt"
	"net/http"
	"github.com/gorilla/mux"
	"com.lockerz/meatshop/template"
	"com.lockerz/meatshop/session"
	"com.lockerz/meatshop/route"
)

type User struct {
	Email string
	Password string
}

func (this *User) fromRequest(r *http.Request) (*User) {
	r.ParseForm()
	Decoder.Decode(this, r.Form)
	return this
}

func (this *User) passwordOk() bool {
	if this.Email == "andrew@lockerz.com" && this.Password == "am100181" {
		return true
	} 
	return false
}


func RegisterUserHandlers(m *mux.Router) {
	m.HandleFunc("/login", userLoginForm).Methods("GET").Name("user.login")
	m.HandleFunc("/login", userLoginSubmit).Methods("POST")
	m.HandleFunc("/logout", userLogout).Name("user.logout")
}

func userLoginForm(w http.ResponseWriter, r *http.Request) {
	s := session.Get(w,r)
	if s.IsAuthenticated() {
		fmt.Fprintln(w, "You are authed!")
	}
	template.Get("user/login").Render(w, "")
}

func userLoginSubmit(w http.ResponseWriter, r *http.Request) {
	user := new(User)
	user.fromRequest(r)
	if !user.passwordOk() {
		fmt.Fprintln(w, "bad password dude")
	}
	session.Get(w,r).Authenticate()
	route.Redirect(w,r, "meat.list")
	
}

func userLogout(w http.ResponseWriter, r *http.Request) {
	session.Get(w,r).Logout()
	route.Redirect(w,r, "user.login")
	
}