/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class Particle {
  // Simple air resistance
  public static final float DAMPING = 0.997;

  private PVector position;
  private PVector velocity;
  private final float inverseMass;
  private PVector forceAccumulator;

  public Particle(final PVector position, final float mass) {
    this.position = position.get();
    velocity = new PVector(0, 0);
    inverseMass = 1 / mass;
    clearAccumulator();
  }

  public void update() {
    // Update the position
    position.add(velocity);
    // Calculate the acceleration
    PVector acceleration = forceAccumulator.get().mult(inverseMass);
    // Update the velocity
    velocity.add(acceleration);
    velocity.mult(DAMPING);
    // Clear the force accumulator
    clearAccumulator();
  }

  public void addForce(final PVector force) {
    forceAccumulator.add(force);
  }

  public void setVelocity(final PVector velocity) {
    this.velocity = velocity.get();
  }

  public float mass() {
    return 1 / inverseMass;
  }

  public PVector getPosition() {
    return position.get();
  }

  private void clearAccumulator() {
    forceAccumulator = new PVector(0, 0);
  }
}
