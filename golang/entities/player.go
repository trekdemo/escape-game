package entities

func NewPlayer(lives int) *Player {
	return &Player{
		Lives: lives,
		Room:  nil,
	}
}

type Player struct {
	Lives int
	Room  *Room
}

func (p *Player) Damage(val int) {
	p.Lives -= val
}
