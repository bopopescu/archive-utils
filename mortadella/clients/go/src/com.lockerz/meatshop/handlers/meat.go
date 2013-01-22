package handlers

import (
	"fmt"
	"net/http"
	"github.com/gorilla/mux"
	"com.lockerz/meatshop/valid"
	"com.lockerz/meatshop/pbs"
	"com.lockerz/meatshop/template"
)

type Meat struct {
	Name string
	PriceCents int
	Pictures []string
}

type Form struct {
	Method string
	Action string
}
type MeatForm struct {
	Meat 
	Form
}




func (this *MeatForm) parsePB(buf *pbs.Meat) (*MeatForm) {
	this.Name = buf.GetName()
	return this
}

func (this *MeatForm) toPB() *pbs.Meat {
	return &pbs.Meat{Name:&this.Name}
}


func (m *MeatForm) fromRequest(r *http.Request) (*MeatForm) {
	r.ParseForm()
	Decoder.Decode(m, r.Form)
	return m
}

func (m *MeatForm) Validate() (bool, []valid.FieldError) {
	return valid.All(
		valid.Check(m.Name, "name").NotEmpty())
}


func RegisterMeatHandlers(m *mux.Router) {
	m.HandleFunc("/meat", meatList).Name("meat.list")
	m.HandleFunc("/meat/new", meatNewForm).Methods("GET").Name("meat.new")
	m.HandleFunc("/meat/{id}", meatDetail).Name("meat.detail")
	m.HandleFunc("/meat/new", meatNewSave).Methods("POST")
}

func meatNewForm(w http.ResponseWriter, r *http.Request) {
	template.Get("meat/new").Render(w, "")
}

func meatNewSave(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Shoudl save our meat!")
}

func meatList(w http.ResponseWriter, r *http.Request) {
	//_ := &MeatForm{name:"Hi there"}
	//meatsChan := api.GetMeats()
	//x := <- meatsChan
	

	
	template.Get("meat/list").Render(w, "")
}

func meatDetail(w http.ResponseWriter, r *http.Request) {
	template.Get("meat/detail").Render(w, "")
}



