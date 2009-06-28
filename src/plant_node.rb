
require 'util'
require 'vector2'


class PlantNode

  def initialize( opts={} )
    @bangle   = (opts[:angle]    or 0.0 )
    @angle    = @bangle
    @rule     = (opts[:rule]            )
    @age      = (opts[:age]      or 0.0 )
    @children = (opts[:children] or []  )
    @parent   = (opts[:parent]          )
    @gen      = (opts[:gen]      or 0   ) # generation
    @agit     = (opts[:agit]     or 0   ) # agitation
  end

  attr_accessor :rule, :age, :children, :parent, :gen


  def draw( surf, pos, rot, scale )
    v = self.vector(rot) * scale

    base = pos
    tip = pos+v
    
    @children.each { |child| child.draw( surf, tip, v.angle, scale ) }

    if( thick*scale > 0 )
      # surf.draw_line_s( base.to_a, tip.to_a, color, thick * scale )

      pthick = @parent ? @parent.thick : thick
      draw_branch( surf, base, pthick, tip, thick, color )
    end

  end


  def draw_branch( surf, basepos, basethick, tippos,  tipthick, color )
    diff = (tippos - basepos)
    lengthwise = diff.unit
    widthwise  = lengthwise.normal

    points = [ basepos - lengthwise * basethick *0.2, # bottom
               basepos - widthwise  * basethick,      # bottom-left
               tippos  - widthwise  * tipthick,       # top-left
               tippos  + lengthwise * tipthick,       # top
               tippos  + widthwise  * tipthick,       # top-right
               basepos + widthwise  * basethick,      # bottom-right
             ]

    points.collect! { |p| p.to_ary }

    surf.draw_polygon_s( points, color ) # solid
    surf.draw_polygon_a( points, color ) # smooth
  end


  def grow( t )
    @age += t
    @agit *= @rule.agitdec ** t
    @agit = 0.0 if( @agit < 0.05 )

    update
    make_child if need_another_child?
    @children.each { |child| child.grow(t) }
  end

  def agitate( amount )
    @agit += amount
    update
    @children.each { |child| child.agitate( amount ) }
  end

  def update
    @angle = @bangle + @rule.wave(@age, @agit)
  end


  def vector( extra_rot=0 )
    Vector2.new_am( @angle + extra_rot, self.length )
  end


  def color
    @rule.color(@age)
  end

  def length
    @rule.length(@age)
  end

  def thick
    @rule.thick(@age)
  end


  def need_another_child?
    @rule.childs(@age) > @children.length
  end


  def make_child
    return if @rule.next.nil?

    child_num = @children.size
    get = @gen
    extra_opts = {:agit => @agit}

    opts = { :angle => calc_child_angle( child_num+1 ),
      :gen   => gen+1,
      :rule  => @rule.next }

    newchild = PlantNode.new( opts.merge(extra_opts) )

    @children << newchild
    newchild.parent = self
  end


  def calc_child_angle( child_num )
    side = (child_num % 2 == 0) ? -1 : 1
    nth_on_this_side = (child_num / 2 + 1).to_f
    return @rule.tilt + side * (@rule.spread * 0.5 *
                                (nth_on_this_side/@rule.maxchilds))
  end

end
