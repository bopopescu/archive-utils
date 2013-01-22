package session

import (
	"net/http"
	"github.com/gorilla/sessions"
)

const sessionName = "meatshop-session"
const keyAuthenticated = "Authenticated"

var store = sessions.NewCookieStore([]byte("very-very-secret"))

type Session struct {
	s *sessions.Session
	r *http.Request
	w http.ResponseWriter
}

func (this *Session) Save() {
	this.s.Save(this.r, this.w)
}

func (this *Session) IsAuthenticated() bool {
	val, exists := this.s.Values[keyAuthenticated]
	if !exists {
		return false
	}
	if !val.(bool) {
		return false
	}
	return true
}

func (this *Session) Authenticate() {
	this.s.Values[keyAuthenticated] = true
	this.s.Save(this.r, this.w)
}

func (this *Session) Logout() {
	this.s.Values[keyAuthenticated] = false
	this.s.Save(this.r, this.w)
}

func Get(w http.ResponseWriter, r *http.Request) *Session {
	session, _ := store.Get(r, sessionName)
	return &Session{session, r, w}
}


