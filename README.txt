
= DROPLET

== WHAT IS DROPLET?

Droplet is a small musical toy created by John Croisant in
72 hours over the weekend of June 26-28, 2009 for the third
RubyWeekend game creation competition.

The theme of the competition was "A Tiny World". The
inspiration for Droplet comes from photographs that people
have commonly described as "tiny worlds": droplets of water,
and the small plants and fungi that grow underfoot.

Initially, Droplet was going to feature both plants and
creatures interacting in their tiny droplet world, but I
abandoned plans for the creatures due to time constraints.
So, what's left is abstract, rainbow colored plants that
sing when you tickle them!

Enjoy!


== HOW TO PLAY

* Run src/app.rb to start the game.
  (Mac users use "rsdl src/app.rb".)

* Left click anywhere on the edge of the droplet (the large
  circle) to plant a seed. The seed will gradually grow into
  a tree-like plant of a random color.

* Move the mouse cursor around near a grown plant to tickle
  it and make it sing. The faster and longer you tickle, the
  louder it sings. The sound each plant produces is randomly
  chosen from the "data/sounds/" directory.

* Right click the trunk of a plant to remove it.

* Click "Help / Credits" to view controls help and game credits.

* Press Escape to quit the game.


== REQUIREMENTS

* Ruby 1.8.6
* Rubygame 2.5.2 with SDL_gfx, SDL_image, and SDL_mixer
* Gamebox 0.0.4


== COPYRIGHT & LICENSE

Droplet is Copyright (C) 2009  John Croisant  (jacius@gmail.com)

The code for Droplet is licensed under the terms of the GNU
General Public License, version 2 or (at your option) later.
See src/LICENSE.txt for details.

The images for Droplet are licensed under the Creative Commons
Attribution-Share Alike 3.0 Unported License.
See data/graphics/LICENSE.txt for details.

The sounds for Droplet are licensed under the Creative Commons
Sampling Plus 1.0 License. See data/sounds/LICENSE.txt for details.
