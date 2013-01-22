package template

import (
	"html/template"
	"io/ioutil"
	"fmt"
	"net/http"
	"net/url"
	"path/filepath"
	"com.lockerz/meatshop/route"
)

type Template struct {
	*template.Template
	err error
}

var funcMap = template.FuncMap {
	"require_javascript" : requireJavascript,
	"require_css" : requireCSS,
	"url_to" : urlTo,
	"link_to" : linkTo,
}


func linkTo(title string, name string, pairs ...string) (template.HTML) {
	u := urlTo(name, pairs...)
	return template.HTML(`<a href="` + u.String() + `">` + title + `</a>`)
}
func urlTo(name string, pairs ...string) (*url.URL) {
	lnk, err := route.Router.Get(name).URL(pairs...)
	if err != nil {
		panic(err.Error())
	} 
	return lnk
}

func requireJavascript (s string) (template.HTML) {
	return template.HTML(`<script type="text/javascript" src="` + s + `"></script>`)
}

func requireCSS(s string) (template.HTML) {
	return template.HTML(`<link rel="stylesheet" href="` + s + `" type="text/css" />`)
}



func load(path string) (string, error) {
	b,err := ioutil.ReadFile(path)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

var blocknames = []string{"javascripts", "title", "contents", "stylesheets"}



func get(driver *Template, name string) (*Template) {

	var contents string
	var t *template.Template
	var err error

	pth := "resources/template/" + name + ".tmpl"
	partials := filepath.Join(filepath.Dir(pth), "partials", "_*.tmpl")
	
	contents, err = load(pth)
	if err != nil {
		return &Template{nil, err}
	}
	
	if driver != nil {
		t,err = driver.Clone()
		if err != nil {
			return &Template{nil,err}
		}

		_,err = t.Parse(contents)
		for _,name := range blocknames {
			if found := t.Lookup(name); found == nil {
				t.Parse("{{ define `" + name + "`}}{{ end }}")
			}
		}
		
		t.ParseGlob(partials)

	} else {
		t  = template.New(name)
		if err != nil {
			return &Template{nil, err}
		}
		t,err = t.Funcs(funcMap).Parse(contents)
	}
	return &Template{t,err}
}



func layout() (*Template) {
	return get(nil, "lib/layout")
}



func Get(name string) (*Template) {
	layout := layout()
	if layout.err != nil {
		return layout
	}
	return get(layout, name)
}

func (t *Template) Render(w http.ResponseWriter, ctx interface{}) {
	if t.err != nil {
		fmt.Fprintln(w, t.err)
	} else {
		err := t.Execute(w, ctx)
		if err != nil {
			fmt.Fprintln(w, err)
		}
	}
}


