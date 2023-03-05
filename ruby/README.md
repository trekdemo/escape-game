# The escape game

A short game where you can escape after you got kidnapped.

- **Play the game** by running `bin/start`.
- Setup the game and its dependencies with `bin/setup`.
- Run the tests with `bundle exec rspec`

## Building blocks
The game is created using two building blocks. `Room`s and `Action`s. Next to these classes there are three more, to help create the world.

`Room`s store the name, and the description of a room. Next to these attributes, a room has a collection of actions. The player can activate these actions.

`Action`s are blocks of game logic that can display a message, navigate between rooms, or implement a challenge. Just a `Proc` with a human readable name.

The `Game` class mediates between all the objects. The game knows that the UI is implemented through the `TUI` class, and exposes two of its methods, `#display` and `#ask`, so the game script can use them.
The `Player` object knows how much lives it has as well as the current room it stays in.
