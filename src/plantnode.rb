
require 'vector2'


class PlantNode

  def initialize( opts={} )
    @color    = opts[:color]    or Rubygame::Color[:white]
    @vector   = opts[:vector]   or Vector2.new(0,0)
    @thick    = opts[:thick]    or 1
    @children = opts[:children] or []
  end

  attr_accessor :color, :vector, :children


  def draw( surf, pos, rot, scale )
    v = @vector.rotate(rot)
    v.magnitude *= scale

    base = pos
    tip = pos+v
    
    surf.draw_line_s( base.to_a, tip.to_a, @color, @thick*scale )

    @children.each { |child|
      child.draw( surf, tip, v.angle, scale )
    }
  end

end
