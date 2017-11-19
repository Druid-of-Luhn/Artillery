/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import java.awt.geom.*;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

class Game {
  // The wind varies between -MAX_WIND and MAX_WIND
  public static final int MAX_WIND = 10;
  // Dampen the gun power
  public static final float POWER_DAMP = 0.8;
  // Option index constants
  public static final int IDX_MAX_SCORE = 0;
  public static final int IDX_GRAV_SCALE = 1;

  private ForceRegistry forces = new ForceRegistry();
  private Statistics stats = new Statistics();

  private Gun[] players;
  private int[] score;
  private int turn = 0;
  private Shell shell;

  private int[] indices;
  private int maxScore;
  private int gravityScale;

  private List<Block> terrain;
  private Gravity gravity;
  private Wind wind = new Wind();
  private float ground;

  public Game(final int[] optionIndices) {
    // Where to fetch the options from the menu
    indices = optionIndices;
  }

  public Game reset() {
    return new Game(indices);
  }

  public void setOptions(final int[] options) {
    // Set the score to win
    maxScore = options[indices[IDX_MAX_SCORE]];
    // Scale gravity
    gravityScale = options[indices[IDX_GRAV_SCALE]];
    gravity = new Gravity(gravityScale / 5.0 * 9.81);
  }
  
  public void buildWorld() {
    // Set an initial wind value
    wind.setWind();
    // Set the ground level
    ground = displayHeight - 120;
    // Generate the central terrain blocks
    terrain = new Terrain().generate(9, 7, ground);

    // Create the players and place them in the world
    players = new Gun[] {
      new Gun(new PVector(100, ground - 50), new PVector(1, 1), 75, 50),
      new Gun(new PVector(displayWidth - 175, ground - 50), new PVector(-1, 1), 75, 50)
    };
    // Set their scores to 0
    score = new int[players.length];
    for (int i = 0; i < score.length; ++i) {
      score[i] = 0;
    }
  }

  private int nextPlayer() {
    // What is the next player's index
    return (turn + 1) % players.length;
  }

  public void nextTurn() {
    // Change turn
    turn = nextPlayer();
    // The wind gets a new value
    wind.setWind();
    // Save a statistic
    stats.turn();
  }

  public Gun currentPlayer() {
    return players[turn];
  }

  public boolean finished() {
    // The game is finished if any player has reached the maximum score
    for (final int s : score) {
      if (s >= maxScore) {
        return true;
      }
    }
    return false;
  }

  public void fireGun() {
    // Only one shell may be fired at a time
    if (shell != null) {
      return;
    }
    // Create the shell and give it a starting velocity
    makeShell(currentPlayer());
    shootShell(currentPlayer());
    // The shell is subject to gravity
    forces.register(gravity, shell);
    // The shell is subject to the wind
    forces.register(wind, shell);
    // Play the gun firing sound
    soundManager.start("Gun Blast");
    // Save a statistic
    stats.fireShell(turn);
  }

  private void makeShell(final Gun gun) {
    // The shell starts at the top/centre of the gun
    PVector shellPos = gun.getPosition();
    shellPos.x += gun.width / 2;
    shellPos.y -= Shell.height;
    shell = new Shell(shellPos);
  }

  private void shootShell(final Gun gun) {
    // Give it an initial firing velocity
    PVector shellVelocity = gun.elevationToVector();
    shellVelocity.mult(gun.getPower() * POWER_DAMP);
    // Point the shell in the right direction
    shellVelocity = gun.setDirection(shellVelocity);
    shell.setVelocity(shellVelocity);
  }

  public void update() {
    // Apply all forces
    forces.updateForces();
    if (shell != null) {
      shell.update();
      // The shell may collide, resulting in a turn change
      // and possibly a score update
      detectShellCollision();
    }
    updateBlocks();
  }

  private void detectShellCollision() {
    // Get the shell's collision box
    final PVector pos = shell.getPosition();
    final Rectangle2D shellBox = new Rectangle2D.Float(pos.x, pos.y, shell.width, shell.height);
    // Detect and handle collision
    if (playerCollision(shellBox) ||
        terrainCollision(shellBox) ||
        groundCollision()) {
      // The shell is destroyed upon hitting something
      destroyShell();
    }
  }

  private boolean playerCollision(final Rectangle2D shellBox) {
    // Now check for collisions with players
    for (final Gun player : players) {
      final PVector pos = player.getPosition();
      // If the shell collides with a player
      if (shellBox.intersects(pos.x, pos.y, player.width, player.height)) {
        // Update the score; +1 for hitting the opponent,
        // or +1 to the opponent for hitting oneself.
        if (player == players[turn]) {
          score[nextPlayer()]++;
        } else {
          score[turn]++;
        }
        return true;
      }
    }
    return false;
  }

  private boolean terrainCollision(final Rectangle2D shellBox) {
    // Check for a collision with any blocks
    Iterator<Block> it = terrain.iterator();
    while (it.hasNext()) {
      final Block b = it.next();
      final PVector pos = b.getPosition();
      // Collision
      if (shellBox.intersects(pos.x, pos.y, b.width, b.height)) {
        // Remove the block that was hit
        it.remove();
        // Save a statistic
        stats.destroyBlock(turn);
        return true;
      }
    }
    return false;
  }

  private boolean groundCollision() {
    // Determine whether the shell is bellow ground
    return shell.getPosition().y >= ground;
  }

  private void destroyShell() {
    // Deregister the forces on the shell
    forces.deregister(gravity, shell);
    forces.deregister(wind, shell);
    // Remove the shell
    shell = null;
    nextTurn();
    // Play a sound
    soundManager.start("Shell Hit");
  }

  private void updateBlocks() {
    // Update the blocks, which drop if unsupported
    for (Block block : terrain) {
      if (block.collides(ground, terrain)) {
        // Remove the influence of gravity
        forces.deregister(gravity, block);
      } else {
        // Reset the influence of gravity
        forces.register(gravity, block);
        // Update the block
        block.update();
      }
    }
  }

  public void move(final char input) {
    for (int s = Gun.SPEED; s > 0; --s) {
      // Move the player
      if (input == 'a') {
        currentPlayer().moveLeft(s);
      } else if (input == 'd') {
        currentPlayer().moveRight(s);
      }
      // Test for a collision
      if (playerCollision()) {
        // Move it back and try a smaller distance
        if (input == 'a') {
          currentPlayer().moveRight(s);
        } else if (input == 'd') {
          currentPlayer().moveLeft(s);
        }
      } else {
        // Save a statistic
        stats.travel(turn);
        break;
      }
    }
    // Play a sound
    final String sound = "Tank Drive";
    if (!soundManager.isPlaying(sound)) {
      soundManager.start(sound);
    }
  }

  private boolean playerCollision() {
    final Gun gun = currentPlayer();
    // Get the gun's collision box
    final PVector pos = gun.getPosition();
    final Rectangle2D gunBox = new Rectangle2D.Float(pos.x, pos.y, gun.width, gun.height);
    // Test for different types of collision
    return playerWallCollision() ||
      playerPlayerCollision(gunBox) ||
      playerTerrainCollision(gunBox);
  }

  private boolean playerWallCollision() {
    // Determine whether the left side sticks off the left
    return currentPlayer().getPosition().x < 0 ||
      // or the right side sticks off the right
      currentPlayer().getPosition().x + currentPlayer().width > displayWidth;
  }

  private boolean playerPlayerCollision(final Rectangle2D gunBox) {
    final Gun other = players[nextPlayer()];
    final PVector pos = other.getPosition();
    return gunBox.intersects(pos.x, pos.y, other.width, other.height);
  }

  private boolean playerTerrainCollision(final Rectangle2D gunBox) {
    for (final Block b : terrain) {
      final PVector pos = b.getPosition();
      if (gunBox.intersects(pos.x, pos.y, b.width, b.height)) {
        return true;
      }
    }
    return false;
  }

  public void draw() {
    textAlign(TOP);
    drawState(50, 50);
    drawTerrain();
    drawPlayers();
    drawShell();
  }

  private void drawState(final int offX, final int offY) {
    text("score: " + score[0] + " - " + score[1], offX, offY);
    text("turn:   player " + (turn + 1), offX, offY + 40);
    final float w = wind.getWind();
    final String direction = w == 0 ? "" : w < 0 ? "<<<" : ">>>";
    text("wind:   " + Math.abs(w) + " " + direction, offX, offY + 80);
  }

  private void drawTerrain() {
    rect(0, ground, displayWidth, 10);
    for (final Block b : terrain) {
      b.draw();
    }
  }

  private void drawPlayers() {
    drawPlayerInfo(50, displayHeight - 75);
    for (final Gun gun : players) {
      gun.draw();
    }
  }

  private void drawPlayerInfo(final int offX, final int offY) {
    // Left player
    textAlign(LEFT, TOP);
    text("elevation: " + players[0].getElevation(), offX, offY);
    text("power: " + players[0].getPower(), offX, offY + 40);
    // Right player
    textAlign(RIGHT, TOP);
    text("elevation: " + players[1].getElevation(), displayWidth - offX, offY);
    text("power: " + players[1].getPower(), displayWidth - offX, offY + 40);
  }

  private void drawShell() {
    if (shell != null) {
      shell.draw();
    }
  }

  public int[] getScore() {
    return score;
  }

  public Statistics getStats() {
    return stats;
  }
}
