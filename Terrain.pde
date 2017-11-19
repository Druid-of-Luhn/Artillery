/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import java.util.LinkedList;
import java.util.List;

class Terrain {
  public List<Block> generate(final int maxCols, final int maxRows, final float ground) {
    // Scale blocks to the window size
    final int blockWidth = HALF_W / maxCols;
    final int blockHeight = displayHeight / 3 / maxRows;
    final PVector position = new PVector(HALF_W - blockWidth * (maxCols / 2.0), ground - blockHeight);

    List<Block> terrain = new LinkedList<Block>();
    for (int col = 0; col < maxCols; ++col) {
      // Decide how many blocks there should be in this column
      final int k = col <= maxCols / 2 ?
        poissonDistribution(col + 1) :
        poissonDistribution(Math.abs(maxCols - col));
      for (int row = 0; row < k; ++row) {
        // Determine the block's position
        final PVector newPos = position.get();
        newPos.x += col * blockWidth;
        newPos.y -= row * blockHeight;
        // Create the block
        final Block block = new Block(newPos, blockWidth, blockHeight);
        terrain.add(block);
      }
    }
    return terrain;
  }

  // Get a Poisson Distribution for a given lambda
  // Source: http://stackoverflow.com/questions/1241555/algorithm-to-generate-poisson-and-binomial-random-numbers
  private int poissonDistribution(final double lambda) {
    final double L = Math.exp(-lambda);
    double p = 1.0;
    int k = 0;
    do {
      ++k;
      p *= Math.random();
    } while (p > L);
    return k - 1;
  }
}
