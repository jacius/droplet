
require 'util'
require 'vector2'


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
  end

  attr_accessor :next, :maxchilds, :childsgrow, :spread, :tilt,
                :color1, :color2, :colorgrow, :maxlong, :longgrow,
                :maxthick, :thickgrow


  def childs(age)
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


  def make_child_node( child_num = 0, gen = 0 )
    PlantNode.new( :angle => calc_child_angle( child_num+1 )
                   :gen   => gen+1,
                   :rule => (@next or self) )
  end


  def calc_child_angle( child_num )
    side = (child_num % 2 == 0) ? -1 : 1
    nth_on_this_side = (child_num / 2 + 1).to_f
    return @tilt + (@spread * 0.5 * (nth_on_this_side/@maxchilds))
  end

end



class PlantNode

  def initialize( opts={} )
    @angle    = opts[:angle]    or 0.0
    @rule     = opts[:rule]
    @age      = opts[:age]      or 0.0
    @children = opts[:children] or []
    @parent   = opts[:parent]
    @gen      = opts[:gen]              # generation
  end

  attr_accessor :rule, :age, :children, :parent, :gen


  def draw( surf, pos, rot, scale )
    v = self.vector(rot) * scale

    base = pos
    tip = pos+v
    
    surf.draw_line_s( base.to_a, tip.to_a, @color, @thick*scale )

    @children.each { |child| child.draw( surf, tip, v.angle, scale ) }
  end


  def tick
    @age += 1
    make_child if need_another_child?
    @children.each { |child| child.tick }
  end


  def vector( extra_rot=0 )
    Vector2.new_am( @angle + extra_rot, self.length )
  end

  def color
    rule_color
  end

  def length
    rule_length
  end

  def length
    rule_length
  end


  private  

  def rule_childs
    @rule.childs(@age)
  end

  def rule_color
    @rule.color(@age)
  end

  def rule_length
    @rule.length(@age)
  end

  def rule_thick
    @rule.thick(@age)
  end

  def need_another_child?
    _rule_childs > @children.length
  end

  def make_child
    newchild = @rule.make_child_node( @children.size, @gen )
    @children << newchild
    newchild.parent = self
  end

end
