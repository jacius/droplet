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


require 'actor'
require 'actor_view'

require 'util'


class PivotActorView < ActorView

  def draw(target, x_offset, y_offset)
    if actor.visible
      pos = actor.center + Vector2.new(x_offset, y_offset)

      rect = Rubygame::Rect.new([0,0,4,4])
      rect.center = pos.to_ary

      target.fill(:white, rect)
    end
  end

end


# Represents the pivot point in the center of the droplet.
class PivotActor < Actor

  attr_reader :center, :radius

  def setup
    @center = Vector2.new(@opts[:x], @opts[:y])
    @radius = @opts[:radius]
  end

  def angle2pos( angle )
    return (@center + Vector2.new_am(angle, @radius))
  end

  def pos2angle( pos )
    pos = _make_vector2(pos)
    return (pos - @center).angle
  end

  # Get the point on the circle nearest the cursor.
  def nearest_point( pos )
    pos = _make_vector2(pos)
    diff = pos - @center
    diff.magnitude = @radius
    return (@center + diff)
  end

  def dist_from_center( pos )
    pos = _make_vector2(pos)
    return (pos - @center).magnitude
  end

  def inside_radius( pos )
    pos = _make_vector2(pos)
    return (dist_from_center(pos) <= @radius)
  end


  private

  # Takes something that's supposed to be like a Vector2,
  # and make sure it really *is* a Vector2
  def _make_vector2( arg )
    case arg
    when Array, Rubygame::Ftor, Ftor
      return Vector2.new( arg[0], arg[1] )
    else
      raise TypeError, "Couldn't turn #{arg} into a Vector2!"
    end
  end

end
