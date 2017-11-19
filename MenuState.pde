/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class MenuState implements GameState {
  // The state to transition to next
  private Class<? extends GameState> next = MenuState.class;

  // These will be displayed on the screen
  public final String title;
  private MenuOption[] options;

  // Which option (or none) is currently being set
  private int settingOption = -1;

  public MenuState(final String title, final MenuOption[] options) {
    this.title = title;
    this.options = options;
  }

  public void update(final char input, Game game) {
    if (settingOption >= 0) {
      // An option has been picked and is being set
      setOption(settingOption, Character.getNumericValue(input));
    } else {
      // No option is currently being set
      pickOption(Character.getNumericValue(input));
    }
    // Play the menu sound
    soundManager.start("Menu Select");
  }

  public void update(Game game) {
    // The menu is entirely input-driven
  }

  private void setOption(final int index, final int value) {
    // Ignore an invalid option
    if (index < 0 || index >= options.length) {
      return;
    }
    if (index >= 0 && index < options.length) {
      options[index].setValue(value);
      // Now listening for a new option
      settingOption = -1;
    }
  }

  private void pickOption(final int index) {
    // Ignore invalid input
    if (index < 0 || index >= options.length) {
      return;
    }
    final MenuOption option = options[index];
    // This option has no value to set, it must transition
    if (option.min == option.max) {
      next = option.transition;
    } else {
      // Listening for an input value
      settingOption = index;
    }
  }

  public void draw(final Game game) {
    // Handle font size and spacing
    final float padding = 20;
    final int fontSize = 48;
    final int titleScale = 2;

    // Display the title
    float offset = displayTitle(padding, fontSize * titleScale);
    // Reset the font size
    textSize(fontSize);
    // List the game commands to the side
    listCommands(offset, padding);
    // Display the available options
    displayOptions(offset, padding, fontSize);

    // Display an explanation
    textAlign(LEFT, BOTTOM);
    text("press a key to select an option,", 25, displayHeight - 75);
    text("then press a key to change the value.", 25, displayHeight - 25);
  }

  private float displayTitle(final float padding, final int fontSize) {
    float offset = 0;
    // The title is large and centred
    textSize(fontSize);
    textAlign(CENTER, TOP);
    offset += padding;

    text(title, HALF_W, offset);

    // Add spacing beneath it
    offset += fontSize;
    offset += padding * 2;
    return offset;
  }

  private void listCommands(float offset, final float padding) {
    // The controls are right-aligned
    final float x = displayWidth - 50;
    textAlign(RIGHT, TOP);
    final int fontSize = 36;
    textSize(fontSize);
    text("a : move to the left", x, offset);
    offset += fontSize + padding;
    text("d : move to the right", x, offset);
    offset += fontSize + padding;
    text("w : increase gun elevation", x, offset);
    offset += fontSize + padding;
    text("s : decrease gun elevation", x, offset);
    offset += fontSize + padding;
    text("+ : increase gun power", x, offset);
    offset += fontSize + padding;
    text("- : decrease gun power", x, offset);
    offset += fontSize + padding;
    text("enter : fire a shell", x, offset);
  }

  private void displayOptions(float offset, final float padding, final int fontSize) {
    textAlign(LEFT, TOP);
    for (String label : getOptionLabels()) {
      offset += padding;
      text(label, padding, offset);
      offset += fontSize;
    }
  }

  public int[] getOptions() {
    // Return the values of the menu options
    int[] values = new int[options.length];
    for (int i = 0; i < options.length; ++i) {
      values[i] = options[i].getValue();
    }
    return values;
  }

  private String getOptionLabel(final int index) {
    // Number the option
    return "[" + index + "] " +
      // and label it
      options[index].label +
      // and if it has bounds,
      (options[index].min == options[index].max ? "" :
        // display its value bounds
        " [" + options[index].min + ";" + options[index].max + "] " +
        // and its current value
        ": " + options[index].getValue());
  }

  public String[] getOptionLabels() {
    String[] labels = new String[options.length];
    for (int i = 0; i < options.length; ++i) {
      labels[i] = getOptionLabel(i);
    }
    return labels;
  }

  public boolean willTransition() {
    return next != MenuState.class;
  }

  public Class<? extends GameState> transition() {
    // Set the game options before transitioning
    game.setOptions(getOptions());
    // Build the game world
    game.buildWorld();
    return next;
  }

  public void resetTransition() {
    next = MenuState.class;
  }
}

  // A menu option
public static class MenuOption {
  public final String label;
  public final int min; // minimum value
  public final int max; // maximum value
  public final int def; // default value
  public final Class<? extends GameState> transition;

  private int value;

  // An option with a label and a single value
  public MenuOption(final String l, final int def, Class<? extends GameState> transition) {
    label = l;
    min = def;
    max = def;
    this.def = def;
    value = def;
    this.transition = transition;
  }

  // An option with a label and a range of values
  public MenuOption(final String l, final int min, final int max, final int def, Class<? extends GameState> transition) {
    label = l;
    this.min = min;
    this.max = max;
    this.def = def;
    value = def;
    this.transition = transition;
  }

  public void setValue(final int value) {
    if (value >= min && value <= max) {
      this.value = value;
    }
  }

  public int getValue() {
    return value;
  }
}
