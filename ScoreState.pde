/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class ScoreState implements GameState {
  private Class<? extends GameState> next = ScoreState.class;

  public void update(final Game game) {
    // The score state is fully input driven
  }

  public void update(final char input, final Game game) {
    if (input == RETURN || input == ENTER) {
      // Transition to the next state
      next = MenuState.class;
    }
  }

  public void draw(final Game game) {
    // Determine the winner
    final int[] score = game.getScore();
    final int winner = score[0] > score[1] ? 1 : 2;
    // Get the statistics
    final Statistics stats = game.getStats();

    float offset = 50;
    final float x = 50;

    textAlign(LEFT);
    textSize(18);
    text("press ENTER to return to the menu", x, offset);
    offset += 25;

    textAlign(CENTER, TOP);
    textSize(100);
    text("winner: player " + winner, HALF_W, offset);
    offset += 120;

    textAlign(LEFT);
    textSize(32);
    text("Score: " + score[0] + " - " + score[1], x, offset);
    offset += 40;
    text("Turns taken: " + stats.getTurnsTaken(), x, offset);
    offset += 40;
    final int[] shells = stats.getShellsFired();
    text("Shells fired: " + shells[0] + " - " + shells[1], x, offset);
    offset += 40;
    final int[] blocks = stats.getBlocksDestroyed();
    text("Blocks destroyed: " + blocks[0] + " - " + blocks[1], x, offset);
    offset += 40;
    final int[] distance = stats.getDistanceTravelled();
    text("Distance travelled: " + distance[0] + "px - " + distance[1] + "px", x, offset);
  }

  public boolean willTransition() {
    return next != ScoreState.class;
  }

  public Class<? extends GameState> transition() {
    game = game.reset();
    return next;
  }

  public void resetTransition() {
    next = ScoreState.class;
  }
}
