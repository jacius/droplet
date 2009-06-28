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


require 'util'
require 'plant_node'


class PlantRule

  def initialize( opts={} )
    @next       = opts[:next]            # Next generation's rules

    @maxchilds  = opts[:maxchilds]       # Max number of children
    @childsgrow = opts[:childsgrow].to_f # Age for maxchild

    @spread     = opts[:spread].to_f     # Variance of angle of children
    @tilt       = opts[:tilt].to_f       # Average angle of children

    @color1     = opts[:color1]          # Young color
    @color2     = opts[:color2]          # Mature color
    @colorgrow  = opts[:colorgrow].to_f  # Age for mature color

    @maxlong    = opts[:maxlong].to_f    # Max length
    @longgrow   = opts[:longgrow].to_f   # Age for maxlong

    @maxthick   = opts[:maxthick].to_f   # Max thickness
    @thickgrow  = opts[:thickgrow].to_f  # Age for maxthick

    @waveamp    = opts[:waveamp].to_f    # Max wave amplitude (radians)
    @wavefreq   = opts[:wavefreq].to_f   # Wave frequency (Hz)
    @waveagit   = opts[:waveagit].to_f   # Agitation level for max waves

    @agitdec    = opts[:agitdec].to_f    # Agitation decay rate
  end

  attr_accessor :next, :maxchilds, :childsgrow, :spread, :tilt,
                :color1, :color2, :colorgrow, :maxlong, :longgrow,
                :maxthick, :thickgrow, :maxwave, :waveagit, :agitdec


  def childs(age)
    return 0 if @next.nil?
    return lerp(age, 0.0, @childsgrow, 0.0, @maxchilds).to_i
  end

  def color(age)
    blend = lerp(age, 0.0, @colorgrow, 0.0, 1.0)
    return @color2.average(@color1, blend)
  end

  def length(age)
    return lerp(age, 0.0, @longgrow, 0.0, @maxlong)
  end

  def thick(age)
    return lerp(age, 0.0, @thickgrow, 0.0, @maxthick)
  end


  def wave(age, agit)
    amp = lerp(agit, 0.0, @waveagit, 0.0, @waveamp)
    return (amp * Math.sin( 2 * Math::PI * @wavefreq * age))
  end

end
