package tui

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"

	"escape-go/entities"
)

type TUI struct {
	in  io.Reader
	out io.StringWriter
}

func New() *TUI {
	return &TUI{
		in:  os.Stdin,
		out: os.Stdout,
	}
}

func (ui *TUI) Display(msg string) {
	if strings.TrimSpace(msg) != "" {
		ui.out.WriteString(fmt.Sprintln(msg))
	}
}

func (ui *TUI) DisplayRoom(room entities.Room) {
	ui.Header(room.Title)
	ui.Display(room.Description)
}

func (ui *TUI) ListActions(actions []*entities.Action) {
	for i, act := range actions {
		ui.Display(fmt.Sprintf("[%d] %s", i+1, act.Name))
	}
}

func (ui *TUI) Header(msg string) {
	fmt.Printf("\n%s\n", strings.ToUpper(msg))
}

func (ui *TUI) Ask(question string) string {
	ui.Display(question)
	ui.out.WriteString(">")
	reader := bufio.NewReader(ui.in)

	if answer, err := reader.ReadString('\n'); err == nil {
		return strings.TrimSpace(answer)
	} else {
		return ""
	}
}
