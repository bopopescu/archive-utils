package valid

import (
	"time"
)
type Validatable interface {
	Validate() (bool, []FieldError)
}

type field struct {
	value interface{}
	name string
	errors []string
}


type FieldError struct {
	key string
	errors []string
}


func Check(val interface{}, name string) (f *field) {
	return &field{val, name, []string{} }
}

func (f *field) addError(fe string) *field {
	f.errors = append(f.errors, fe)
	return f
}

func (f *field) checkState(val bool, fe string) *field {
	if !val {
		f.addError(fe)
	}
	return f
}

func (f *field) hasErrors() bool {
	return len(f.errors) > 0
}

func All(fields ...*field) (bool, []FieldError) {
	fes := []FieldError{}
	ok := true
	for _,fld := range fields {
		if fld.hasErrors() {
			ok = false
			fes = append(fes, FieldError{fld.name, fld.errors})
		}
	}
	return ok, fes	
}


func (f *field) NotEmpty() *field {
	return f.NotEmptyMsg("required")
}

func (f *field) NotEmptyMsg(msg string) *field {
	if f.value == nil {
		return f.addError(msg)
	}

	if str, ok := f.value.(string); ok {
		return f.checkState(len(str) > 0, msg)
	}

	if list, ok := f.value.([]interface{}); ok {
		return f.checkState(len(list) > 0, msg)
	}
	if b, ok := f.value.(bool); ok {
		return f.checkState(b, msg)
	}
	if i, ok := f.value.(int); ok {
		return  f.checkState(i != 0, msg)
	}
	if t, ok := f.value.(time.Time); ok {
		return f.checkState(!t.IsZero(), msg)
	}
	return f
}


