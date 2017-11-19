/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import java.util.List;

class Block extends Particle {
  public final int width;
  public final int height;

  public Block(final PVector pos, final int w, final int h) {
    // Weighs 200 units
    super(pos, 200);
    width = w;
    height = h;
  }

  public void draw() {
    rect(getPosition().x, getPosition().y, width, height);
  }

  public boolean collides(final float ground, final List<Block> blocks) {
    // The block may collide with the ground
    if (getPosition().y + height >= ground) {
      return true;
    }
    // Now check for collisions with the block beneath this one
    for (final Block b : blocks) {
      // Don't compare with itself
      if (b != this &&
          // same column
          getPosition().x == b.getPosition().x &&
          // vertical intersection
          b.getPosition().y - getPosition().y >= 0 &&
          b.getPosition().y - getPosition().y <= height) {
        return true;
      }
    }
    return false;
  }
}
