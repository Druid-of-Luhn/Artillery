/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

interface ForceGenerator {
  public void update(Particle p);
}

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

class ForceRegistry {
  // Register particles with force generators
  private Map<ForceGenerator, Set<Particle>> registry;

  public ForceRegistry() {
    registry = new HashMap<ForceGenerator, Set<Particle>>();
  }

  public void register(final ForceGenerator fg, final Particle p) {
    Set<Particle> particles = registry.get(fg);
    if (particles == null) {
      // Registering a new force generator
      particles = new HashSet<Particle>();
      registry.put(fg, particles);
    }
    // Make sure a particle is only registered once to each force
    if (!particles.contains(p)) {
      particles.add(p);
    }
  }

  public void deregister(final ForceGenerator fg, final Particle p) {
    Set<Particle> particles = registry.get(fg);
    if (particles != null) {
      particles.remove(p);
    }
  }

  public void clear() {
    registry.clear();
  }

  public void updateForces() {
    // For every force generator
    for (final Map.Entry<ForceGenerator, Set<Particle>> reg : registry.entrySet()) {
      final ForceGenerator fg = reg.getKey();
      // Update every particle registered to it
      for (Particle p : reg.getValue()) {
        fg.update(p);
      }
    }
  }
}
