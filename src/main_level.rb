#++
# 
# Droplet (musical toy software)
# Copyright (C) 2009  John Croisant  (jacius@gmail.com)
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA  02110-1301, USA.
# 
#++


require 'level'
require 'util'

require 'plant_types'


class MainLevel < Level
  def setup
    @first_draw = true

    @background = @resource_manager.load_image('background.png')

    c = opts[:pivot][:center]
    r = opts[:pivot][:radius]

    @pivot = create_actor :pivot_actor, :x => c[0], :y => c[1], :radius => r
    @pivot.visible = false

    @plants = []


    @pivot.input_manager.reg MouseDownEvent, :left do |event|
      # Ignore clicks while info is open.
      unless @info_open

        dist = @pivot.dist_from_center(event.pos)
        rad = @pivot.radius

        # Ignore clicks that are too far from the outside ring
        if (dist > rad - 50) and (dist < rad + 25)

          retries = 3
          begin
            if( retries > 0 )
              create_random_plant( event )
            end
          rescue Rubygame::SDLError => e
            retries -= 1
            # Try again, different sound maybe?
            retry
          end

        end

      end
    end

    @info = create_actor :info_actor
    @info.close

    @info_open = false


    soundsdir = File.join( File.dirname(__FILE__), "..", "data", "sounds" )

    @sounds = []
    @sounds += Dir.glob( File.join(soundsdir, "*.ogg") )
    @sounds += Dir.glob( File.join(soundsdir, "*.mp3") )
    @sounds += Dir.glob( File.join(soundsdir, "*.wav") )
    @sounds.collect! { |s| File.basename(s) }

  end

  attr_reader :pivot, :info_open

  def draw(target, x_off, y_off)
      set_title( target )

    @background.blit(target.screen,[0,0])
  end


  def update( time )
    @plants.each { |plant| plant.update( time * 0.001 ) }
    @plants.delete_if { |plant| plant.root.health == 0 }
  end


  def create_random_plant( event )
    p = @pivot.nearest_point( event.pos )

    hue1 = rand
    hue2 = (hue1 + 0.2)%1.0
    val1 = 0.3 + rand*0.3
    val2 = val1 - 0.2

    i = rand(3)
    gens = [3,4,5][i]
    maxchilds = [4,3,2][i]

    maxlong = gens * 6 + rand*10
    spread = 0.2 + (6 - gens) * Math::PI * 0.5

    tilt = (rand*2 - 1) * 0.2   # rand between -0.2 and +0.2

    opts = { 
      :hue1 => hue1, :val1 => val1,
      :hue2 => hue2, :val2 => val2,
      :maxlong => maxlong,
      :maxchilds => maxchilds,
      :spread => spread, :tilt => tilt,
      :gens => gens }

    soundname = @sounds[ rand(@sounds.length) ]

    create_plant( SamplePlantType.new(opts),
                  :x => p.x, :y => p.y,
                  :soundname => soundname )
  end


  def create_plant( type, opts={} )
    @plants << create_actor( :plant_actor, opts.merge(:type => type) )
  end


  def set_title( screen )
    screen.title = "Droplet (%d plants)"%@plants.size
  end


  def open_info
    @info_open = true
    @info.open
    @plants.each { |plant| plant.visible = false }
  end

  def close_info
    @info_open = false
    @info.close
    @plants.each { |plant| plant.visible = true }
  end

end
