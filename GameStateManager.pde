/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class GameStateManager {
  // The different game states
  private GameState[] states;
  // Current game state index
  private int state;

  public GameStateManager(final GameState[] states) {
    this.states = states;
    // The game starts in a menu state
    setState(MenuState.class);
  }

  public void update(Game game) {
    testTransition();
    // Update the current state
    states[state].update(game);
  }

  public void update(Game game, final char key) {
    testTransition();
    // Pass the input to the current state
    states[state].update(key, game);
  }

  public void draw(final Game game) {
    // Display the current state
    states[state].draw(game);
  }

  private void setState(final Class<? extends GameState> next) {
    // Find the state to transition to
    for (int i = 0; i < states.length; ++i) {
      if (next.isInstance(states[i])) {
        // Set the new current state
        state = i;
        // Stop the new state from transitioning directly
        states[state].resetTransition();
        break;
      }
    }
  }

  private void testTransition() {
    // Test whether the current state is transitioning
    if (states[state].willTransition()) {
      // Transition to the next state
      setState(states[state].transition());
    }
  }
}
