
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
    @side     = (opts[:side]     or 1   )

    @withering   = false
    @wither_rate = 0.3
    @health      = 1.0
  end

  attr_accessor :rule, :age, :children, :parent, :gen, :agit,
                :withering, :health


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

    if @withering 
      if( @health <= 0.01 )
        @health = 0
        @children = []
      else
        @health -= @wither_rate * t
      end
    end

    update
    make_child if need_another_child?
    @children.each { |child| child.grow(t) }
  end


  def agitate( amount )
    @agit = [@agit + amount, @rule.waveagit].min
    update
    @children.each { |child| child.agitate( amount ) }
  end


  def update
    a = @bangle + @rule.wave(@age, @agit)
    @angle = lerp( size, 0.0, 1.0, 0.0, a )
  end


  def wither
    @withering = true
    @children.each { |child| child.wither }
  end


  def vector( extra_rot=0 )
    Vector2.new_am( @angle + extra_rot, self.length )
  end


  def color
    @rule.color(@age)
  end

  def length
    @rule.length(@age) * @health
  end

  def thick
    @rule.thick(@age) * @health
  end

  def size
    self.length / @rule.maxlong
  end


  def need_another_child?
    return false if @withering
    @rule.childs(@age) > @children.length
  end


  def make_child
    return if @rule.next.nil?

    opts = { :angle => calc_child_angle( @children.size ),
             :gen   => @gen+1,
             :rule  => @rule.next,
             :agit  => @agit,
             :side  => calc_child_side( @children.size ) }

    newchild = PlantNode.new( opts )

    @children << newchild
    newchild.parent = self
  end



  def calc_child_side( child_num )
    side = child_num.even? ? -1 : 1
  end


  def calc_child_angle( child_num )
    child_num = child_num.to_i

    spread = @rule.spread
    tilt   = @rule.tilt
    max    = @rule.maxchilds

    if( max.odd? )
      if child_num == 0
        return tilt          # first child goes "straight" (plus tilt)
      else
        child_num -= 1          # Adjust to ignore first child
      end
    end

    side = calc_child_side( child_num )

    nth_on_this_side = (child_num / 2 + 1).to_f
    return @side * (tilt + side * 0.5 * spread * nth_on_this_side / max)

  end

end
