package main

import (
	"log"
	"regexp"
	"strconv"

	e "escape-go/entities"
	"escape-go/tui"
)

var (
	g                Game
	player           e.Player
	basement, pantry e.Room
)

func setup() {
	player = *e.NewPlayer(3)
	g = Game{Player: player, UI: *tui.New()}

	g.UI.Display(`You wake up to the muffled bang of a closing door. The sound came somewhere
above you. You cannot see, you are blindfolded. Something cutting into your
wrists. Your hands are sore and tied behind you. To top it there is a dull
pain coming from the back of your head.
After fiddling with your shoulders, you manage to push the blindfolds up a bit.
It's blury first, you blink a couple, squeeze your eyes and you start to see...`)

	// =========================================================================
	// SETUP BASEMENT
	// =========================================================================
	basement = e.Room{
		Title: "Basement",
		Description: `It's dim here. There are a couple racks next to the wall. There are some
containers on them but mostly empty. One of them is broken, and a sharp, metal
piece hangs out, about three steps from you.
On the ceiling to your left there's a pull-down ladder.`,
	}
	unreachable_ladder := e.NewAction(
		"climb up on the ladder",
		func(act *e.Action) {
			g.UI.Display("Your hands are tied. You cannot reach the pull-down handle.")
		},
	)

	free_hands_challange := e.NewAction(
		"cut the quick-ties using the broken rack.",
		func(act *e.Action) {
			answer := g.UI.Ask("How far is the metal piece?")
			expectation := regexp.MustCompile(`(3|three)\s*(steps)?`)
			distance, err := strconv.Atoi(answer)

			if err != nil {
				g.UI.Display("Incorrect answer")
				log.Fatalln(err)
			} else if expectation.MatchString(answer) {
				g.UI.Display("Great, your hands are free.")
				// basement.Remove(act, unreachable_ladder)
				// basement.Add(ladder_to_pantry)
			} else if distance > 3 {
				g.UI.Display("Ouch! You walked into the sharp piece and cut yourself.")
				g.Player.Damage(1)
			} else {
				g.UI.Display("You are not close enough to cut the ties.")
			}
		},
	)

	basement.Add(unreachable_ladder, free_hands_challange)
}

func main() {
	setup()
	g.MoveTo(&basement)
	g.loop()
}
