/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class Gun {
  public static final int SPEED = 5;

  private PVector position;
  public final PVector direction;
  private float elevation = 45;
  private int power = 10;

  public final int width;
  public final int height;

  public Gun(final PVector position, final PVector direction, final int w, final int h) {
    this.position = position.get();
    this.direction = direction.get();
    width = w;
    height = h;
  }

  public void update(final char key) {
    switch (key) {
      // More power
      case '+':
        power++;
        break;
      // Less power
      case '-':
        if (power > 1) {
          power--;
        }
        break;
      // Gun up
      case 'w':
        elevation++;
        break;
      // Gun down
      case 's':
        elevation--;
        break;
    }
  }

  public void moveLeft(final float distance) {
    position.x -= distance;
  }

  public void moveRight(final float distance) {
    position.x += distance;
  }

  public void draw() {
    // The tanks are drawn in a different colour
    fill(GUN_C[0], GUN_C[1], GUN_C[2]);
    stroke(GUN_C[0], GUN_C[1], GUN_C[2]);

    // The tank is a simple rectangle
    rect(position.x, position.y, width, height);

    // Draw a line representing the angle of the shot
    strokeWeight(4);
    final PVector pos = position.get();
    pos.x += width / 2;
    final PVector end = elevationToVector();
    // Scale and position the normalised vector
    setDirection(end).mult(50).add(pos);
    line(pos.x, pos.y, end.x, end.y);

    // Reset the colours and stroke
    fill(FILL_C[0], FILL_C[1], FILL_C[2]);
    stroke(0);
    strokeWeight(2);
  }

  public PVector setDirection(PVector vector) {
    // Set a vector's direction for the gun's current direction
    vector.x *= direction.x;
    vector.y *= direction.y;
    return vector;
  }

  public PVector getPosition() {
    return position.get();
  }

  public float getElevation() {
    return elevation;
  }

  public int getPower() {
    return power;
  }

  public PVector elevationToVector() {
    // Convert the gun elevation in degrees to a normalised vector
    final float x = (float) Math.cos(Math.toRadians(elevation));
    // Get the y pointing in the right direction
    final float y = (float) -Math.sin(Math.toRadians(elevation));
    // Return a normalised vector representing the angle of fire
    return new PVector(x, y);
  }
}
