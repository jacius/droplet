require 'actor'
require 'actor_view'

require 'vector2'
require 'plant_types'


class PlantActorView < ActorView

  def draw(target, x_off, y_off)
    offset = Vector2.new(x_off, y_off)
    actor.root.draw( target, actor.pos+offset, actor.angle, 1.0 )
  end

end


class PlantActor < Actor

  def setup
    @pos = Vector2.new( @opts[:x], @opts[:y] )
    @angle = @level.pivot.pos2angle(@pos) + Math::PI
    @type = @opts[:type]
    @root = @type.first_node
  end

  attr_reader :pos, :angle, :type, :root


  def grow( t )
    @root.grow( t )
  end

end
