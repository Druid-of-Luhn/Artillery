/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class Shell extends Particle {
  public static final int width = 10;
  public static final int height = 10;

  public Shell(final PVector position) {
    // A shell weights 100 units
    super(position, 100);
  }

  public void draw() {
    // Same colour as the players
    fill(GUN_C[0], GUN_C[1], GUN_C[2]);

    rect(getPosition().x, getPosition().y, width, height);

    fill(FILL_C[0], FILL_C[1], FILL_C[2]);
  }
}
