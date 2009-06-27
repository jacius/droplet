
require 'util'
require 'vector2'


class PlantNode

  def initialize( opts={} )
    @angle    = (opts[:angle]    or 0.0 )
    @rule     = (opts[:rule]            )
    @age      = (opts[:age]      or 0.0 )
    @children = (opts[:children] or []  )
    @parent   = (opts[:parent]          )
    @gen      = (opts[:gen]      or 0   ) # generation
  end

  attr_accessor :rule, :age, :children, :parent, :gen


  def draw( surf, pos, rot, scale )
    v = self.vector(rot) * scale

    base = pos
    tip = pos+v
    
    if( thick*scale > 0 )
      surf.draw_line_s( base.to_a, tip.to_a, color, thick * scale )
    end

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

  def thick
    rule_thick
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
    rule_childs > @children.length
  end

  def make_child
    newchild = @rule.make_child_node( @children.size, @gen )
    @children << newchild
    newchild.parent = self
  end

end
