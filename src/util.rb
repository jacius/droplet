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


# Linear interpolation (and, if clamp=false, extrapolation)
# 
# t = current time
# ta = start time
# tb = end time
# va = start value
# vb = end value
# 
def lerp( t, ta, tb, va, vb, clamp=true )
  t  = t.to_f
  ta = ta.to_f
  tb = tb.to_f
  
  blend = (t - ta)/(tb - ta)

  if( clamp )
    return va if blend <= 0.0   # too small
    return vb if blend >= 1.0   # too big
  end

  return (blend * (vb - va) + va)
  
end


def rgb( color )
  Rubygame::Color::ColorRGB.new( color )
end

def hsv( color )
  Rubygame::Color::ColorHSV.new( color )
end

def hsl( color )
  Rubygame::Color::ColorHSL.new( color )
end


class Numeric
  def even?
    return (self % 2 == 0)
  end

  def odd?
    not even?
  end
end
