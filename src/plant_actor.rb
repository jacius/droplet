require 'actor'
require 'actor_view'

require 'vector2'
require 'sounds'
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
    @root.agitate(@opts[:agit]) if @opts[:agit]

    @sound = Sounds[@opts[:soundname]] if @opts[:soundname]
    @sound.volume = 0.0
    @sound.play( :repeats => -1 )

    @update_every = 0.1 #secs
    @update_counter = 0.0

    @input_manager.reg MouseMotionEvent do |event|
      mouse_agitate( event )
    end

    # Scale factor for agitation.
    @agit_scale = 0.01

    # Making this up for now.
    @size = 0.0
    @maxsize = 130.0

  end

  attr_reader :pos, :angle, :type, :root


  def update( time )
    grow( time )

    @update_counter += time
    if( @update_counter >= @update_every )

      adjust_volume

      @update_counter -= @update_every
    end
  end


  def grow( t )
    # Making this up for now.
    @size += t*10 if @size < @maxsize
    @root.grow( t )
  end

  def agitate( amount )
    @root.agitate( amount )
  end


  def mouse_agitate( event )
    pos = Vector2.new( *event.pos )

    # We only care about movement inside the droplet.
    if @level.pivot.inside_radius( pos )

      dist_from_me = (pos - @pos).magnitude

      # We also only care about movement near us.
      if( dist_from_me <= @size )

        power = @agit_scale * Vector2.new( *event.rel ).magnitude

        agitate( power * (dist_from_me / @size) )

      end

    end
  end


  def adjust_volume
    force = @root.agit/@root.rule.waveagit
    @sound.volume = force
  end

end
