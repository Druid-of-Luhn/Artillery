/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class Wind implements ForceGenerator {
  // The wind varies between -MAX_WIND and MAX_WIND
  public static final int MAX_WIND = 10;
  // Use a weaker value than the one shown to the user
  public static final float WIND_DAMP = 0.33;

  private PVector wind = new PVector(0, 0);

  public void update(Particle p) {
    p.addForce(wind.get().mult(WIND_DAMP));
  }

  public void setWind() {
    // The wind is always horizontal, between -MAX_WIND and MAX_WIND
    this.wind.x = (float) Math.floor(random(MAX_WIND * 2) - MAX_WIND);
  }

  public float getWind() {
    return wind.x;
  }
}
