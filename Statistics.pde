/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

class Statistics {
  private int turnsTaken;
  private int[] shellsFired;
  private int[] blocksDestroyed;
  private int[] distanceTravelled;

  public Statistics() {
    turnsTaken = 0;
    shellsFired = new int[] { 0, 0 };
    blocksDestroyed = new int[] { 0, 0 };
    distanceTravelled = new int[] { 0, 0 };
  }

  public void turn() {
    ++turnsTaken;
  }

  public void fireShell(final int player) {
    ++shellsFired[player];
  }

  public void destroyBlock(final int player) {
    ++blocksDestroyed[player];
  }

  public void travel(final int player) {
    ++distanceTravelled[player];
  }

  public int getTurnsTaken() {
    return turnsTaken;
  }

  public int[] getShellsFired() {
    return shellsFired;
  }

  public int[] getBlocksDestroyed() {
    return blocksDestroyed;
  }

  public int[] getDistanceTravelled() {
    return distanceTravelled;
  }
}
