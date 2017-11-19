/*
 * Copyright 2017 Billy Brown
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

interface GameState {
  public void update(final Game game);
  public void update(final char input, final Game game);
  public void draw(final Game game);
  public boolean willTransition();
  public Class<? extends GameState> transition();
  public void resetTransition();
}
