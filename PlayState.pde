/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class PlayState implements GameState {
  private Class<? extends GameState> next = PlayState.class;

  public void update(final char input, Game game) {
    switch (input) {
      case RETURN:
      case ENTER:
        game.fireGun();
        break;
      // The game handles player movement
      case 'a':
      case 'd':
        game.move(input);
        break;
      default:
        // Send the player the input
        game.currentPlayer().update(input);
    }
  }

  public void update(Game game) {
    // Transition to the score state when the game is over
    if (game.finished()) {
      next = ScoreState.class;
    } else {
      game.update();
    }
  }

  public void draw(final Game game) {
    // The game draws itself
    game.draw();
  }

  public boolean willTransition() {
    return next != PlayState.class;
  }

  public Class<? extends GameState> transition() {
    return next;
  }

  public void resetTransition() {
    next = PlayState.class;
  }
}
