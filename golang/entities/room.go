package entities

type Room struct {
	Title       string
	Description string
	Actions     []*Action
}

func (room *Room) Add(actions ...*Action) {
	room.Actions = append(room.Actions, actions...)
}
