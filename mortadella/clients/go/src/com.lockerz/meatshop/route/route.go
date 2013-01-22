package route

import (
	"net/http"
	"github.com/gorilla/mux"
)

var Router *mux.Router

func init() {
	Router = mux.NewRouter()
}

func Redirect(w http.ResponseWriter, r *http.Request, to string, args ...string) error {
	url, err := Router.Get(to).URL(args...)
	if err != nil {
		return err
	}
	http.Redirect(w, r, url.String(), http.StatusTemporaryRedirect)
	return nil
}