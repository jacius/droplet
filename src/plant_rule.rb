require 'util'
require 'plant_node'


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

    @waveamp    = opts[:waveamp].to_f    # Max wave amplitude (radians)
    @wavefreq   = opts[:wavefreq].to_f   # Max wave frequency (Hz)
    @waveagit   = opts[:waveagit].to_f   # Agitation level for max waves

  end

  attr_accessor :next, :maxchilds, :childsgrow, :spread, :tilt,
                :color1, :color2, :colorgrow, :maxlong, :longgrow,
                :maxthick, :thickgrow, :maxwave, :waveagit


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


  def wave(age, agit)
    amp = lerp(agit, 0.0, @waveagit, 0.0, @waveamp)
    frq = lerp(agit, 0.0, @waveagit, 0.0, @wavefreq)
 
    return (amp * Math.sin( 2 * Math::PI * frq * age))
  end


  def make_child_node( child_num = 0, gen = 0 )
    PlantNode.new( :angle => calc_child_angle( child_num+1 ),
                   :gen   => gen+1,
                   :rule => (@next or self) )
  end


  def calc_child_angle( child_num )
    side = (child_num % 2 == 0) ? -1 : 1
    nth_on_this_side = (child_num / 2 + 1).to_f
    return @tilt + side*(@spread * 0.5 * (nth_on_this_side/@maxchilds))
  end

end
