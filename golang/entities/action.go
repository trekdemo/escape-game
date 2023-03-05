package entities

type ActionFunc func(*Action)

type Action struct {
	Name     string
	callback ActionFunc
}

func NewAction(name string, callback ActionFunc) *Action {
	return &Action{Name: name, callback: callback}
}

func (a *Action) Do() {
	a.callback(a)
}

func (a *Action) String() string {
	return a.Name
}
