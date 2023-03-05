package main

import (
	"escape-go/entities"
	"escape-go/tui"
	"strconv"
)

type Game struct {
	Player entities.Player
	UI     tui.TUI
}

func (g *Game) MoveTo(room *entities.Room) {
	g.Player.Room = room
	g.UI.DisplayRoom(*room)
}

func (g *Game) loop() {
	for {
		g.UI.ListActions(g.Player.Room.Actions)
		command := g.UI.Ask("")

		switch command {
		case "exit":
			return
		case "help":
			g.help()
		case "look":
			g.look()
		default:
			g.handleSelectedAction(command)
		}
	}
}

func (g *Game) handleSelectedAction(actionID string) {
	ind, err := strconv.Atoi(actionID)
	if err != nil {
		g.UI.Display("Invalid action!")
		return
	}

	if len(g.Player.Room.Actions) < ind {
		g.UI.Display("Invalid action!")
		return
	}

	act := g.Player.Room.Actions[ind-1]
	act.Do()
}

func (g *Game) look() {
	g.UI.DisplayRoom(*g.Player.Room)
}

func (g *Game) help() {
	g.UI.Display(`To choose a listed option enter the number of your choice shown within
brackets.
Additionally, you can use the following commands.

help    Prints this message
look    Display the description of the room.
exit    Immediately leaves the game.`)
}
