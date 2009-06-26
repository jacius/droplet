require 'actor'
require 'actor_view'

require 'vector2'

# It's invisible.
class PivotActorView < ActorView
end


# Represents the pivot point in the center of the droplet.
class PivotActor < Actor

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