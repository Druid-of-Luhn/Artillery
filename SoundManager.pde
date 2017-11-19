/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import ddf.minim.*;
import java.util.HashMap;
import java.util.Map;

// A simple wrapper around minim.AudioPlayer
class Sound {
  private final AudioPlayer player;
  private boolean playing;

  public Sound(final AudioPlayer player) {
    this.player = player;
    playing = false;
  }

  public void start() {
    // Always start from the beginning
    player.rewind();
    player.play();
    playing = true;
  }

  public void stop() {
    // Always return to the beginning
    player.pause();
    player.rewind();
    playing = false;
  }

  public boolean isPlaying() {
    // The song may have ended on its own
    playing = playing && player.isPlaying();
    return playing;
  }
}

class SoundManager {
  private Minim minim;
  // Sounds are given a name
  private Map<String, Sound> sounds;

  public SoundManager(Object that) {
    minim = new Minim(that);
    sounds = new HashMap<String, Sound>();
  }

  public void addSound(final String file, final String name) {
    sounds.put(name, new Sound(minim.loadFile(file)));
  }

  public void start(final String name) {
    final Sound sound = sounds.get(name);
    if (sound != null) {
      sound.start();
    }
  }

  public void stop(final String name) {
    final Sound sound = sounds.get(name);
    if (sound != null) {
      sound.stop();
    }
  }

  public boolean isPlaying(final String name) {
    final Sound sound = sounds.get(name);
    if (sound != null) {
      return sound.isPlaying();
    }
    return false;
  }
}
