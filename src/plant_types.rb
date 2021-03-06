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


require 'plant_rule'
require 'util'


class PlantType

  def initialize
    @rules = []
  end

  def append_rule( rule )
    case rule
    when Hash
      rule = PlantRule.new( rule )
    when PlantRule
      rule = rule.dup
    end

    @rules << rule
    prev_rule = @rules[-2]
    prev_rule.next = rule if prev_rule
  end

  def first_node
    PlantNode.new( :rule  =>  @rules[0] )
  end

end


class SamplePlantType < PlantType

  def initialize( opts={} )
    super()

    opts = {
      :hue1 => 0.37, :sat1 => 0.33, :lum1 => 0.38,
      :hue2 => 0.58, :sat2 => 0.79, :lum2 => 0.39,
      :gens => 4,
    }.merge(opts)
      

    main_rule = {:maxchilds  => 3,
                 :childsgrow => 4.5,

                 :spread     => Math::PI * 0.8,
                 :tilt       => 0,

                 :color1     => hsl([opts[:hue1], opts[:sat1], opts[:lum1]]),
                 :color2     => hsl([opts[:hue2], opts[:sat2], opts[:lum2]]),
                 :colorgrow  => 5,

                 :maxlong    => 35,
                 :longgrow   => 10,
                 
                 :maxthick   => 7,
                 :thickgrow  => 15,

                 :waveamp    => Math::PI * 0.03,
                 :wavefreq   => 3,
                 :waveagit   => 25.0,

                 :agitdec    => 0.85 }.merge(opts)

    gens = opts[:gens]

    gens.times{ |i|
      thick = main_rule[:maxthick] * 0.66**i

      c1 = main_rule[:color1]
      c1 = hsl( [(c1.h + 0.05*i)%1.0, c1.s, c1.l * 1.1**i] )

      c2 = main_rule[:color2]
      c2 = hsl( [(c2.h - 0.05*i)%1.0, c2.s*0.75**i, c2.l * 1.1**i] )

      append_rule( main_rule.merge( :maxthick => thick,
                                    :color1   => rgb(c1),
                                    :color2   => rgb(c2) )) 
    }

  end

end
