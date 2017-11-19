/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class Gravity implements ForceGenerator {
  private PVector gravity;

  public Gravity(final float gravity) {
  // Gravity is always vertical
    this.gravity = new PVector(0, gravity);
  }

  public void update(Particle p) {
    p.addForce(gravity);
  }
}
