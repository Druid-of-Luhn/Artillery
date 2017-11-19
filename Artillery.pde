/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// Prevent need to halve screen dimensions in updates
static int HALF_W = 0;
static int HALF_H = 0;

// Define colours [r, g, b]
static final int[] FILL_C = new int [] { 210, 5, 40 };
static final int[] GUN_C = new int [] { 5, 210, 40 };

// Manage the different game states
GameStateManager stateManager;
// Hold the current state of the game
Game game;
// Handle starting and stopping sounds
SoundManager soundManager;

void setup() {
  // Set display options
  fullScreen();
  stroke(0, 0);
  strokeWeight(2);
  PFont font = loadFont("assets/font.vlw");
  textFont(font);
  HALF_W = displayWidth / 2;
  HALF_H = displayHeight / 2;
  
  // Create the different game states
  final MenuState menu = new MenuState("artillery game", new MenuOption[] {
      new MenuOption("start human vs. human", 0, PlayState.class),
      new MenuOption("set maximum score", 1, 9, 5, MenuState.class),
      new MenuOption("set gravity scale", 1, 9, 5, MenuState.class)
      });
  final PlayState play = new PlayState();
  final ScoreState score = new ScoreState();
  // And put them together
  stateManager = new GameStateManager(new GameState[] { menu, play, score });

  // Set up the sounds
  soundManager = new SoundManager(this);
  soundManager.addSound("assets/gun_blast.mp3", "Gun Blast");
  soundManager.addSound("assets/menu_select.mp3", "Menu Select");
  soundManager.addSound("assets/shell_hit.mp3", "Shell Hit");
  soundManager.addSound("assets/tank_driving.mp3", "Tank Drive");

  // Create the game object, telling it where to fetch the target score
  // and gravity scale from the menu options.
  game = new Game(new int[] { 1, 2 });
}

void draw() {
  // Clear the screen with black
  background(0);
  // Draw with the main colour
  fill(FILL_C[0], FILL_C[1], FILL_C[2]);

  // Update the current game state
  stateManager.update(game);
  // Display the current game state
  stateManager.draw(game);
}

void keyPressed() {
  // Send keyboard input to the current game state
  stateManager.update(game, key);
}
