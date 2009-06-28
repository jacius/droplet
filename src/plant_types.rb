
require 'plant_rule'
require 'util'


class PlantType

  def initialize
    @rules = []
  end

  def append_rule( rule )
    case rule
    when Hash
      rule = PlantRule.new( rule )
    when PlantRule
      rule = rule.dup
    end

    @rules << rule
    prev_rule = @rules[-2]
    prev_rule.next = rule if prev_rule
  end

  def first_node
    PlantNode.new( :rule  =>  @rules[0] )
  end

end


class SamplePlantType < PlantType

  def initialize( opts={} )
    super()

    opts = {
      :hue1 => 0.37, :sat1 => 0.33, :lum1 => 0.38,
      :hue2 => 0.58, :sat2 => 0.79, :lum2 => 0.39,
    }.merge(opts)
      

    main_rule = {:maxchilds  => 3,
                 :childsgrow => 45,

                 :spread     => Math::PI * 0.8,
                 :tilt       => 0,

                 :color1     => hsl([opts[:hue1], opts[:sat1], opts[:lum1]]),
                 :color2     => hsl([opts[:hue2], opts[:sat2], opts[:lum2]]),
                 :colorgrow  => 50,

                 :maxlong    => 35,
                 :longgrow   => 80,
                 
                 :maxthick   => 10,
                 :thickgrow  => 150,

                 :waveamp    => Math::PI * 0.05,
                 :wavefreq   => 0.4,
                 :waveagit   => 15.0,

                 :agitdec    => 0.98 }.merge(opts)

    gens = 4

    gens.times{ |i|
      thick = main_rule[:maxthick] * 0.66**i

      c1 = main_rule[:color1]
      c1 = hsl( [(c1.h + 0.05*i)%1.0, c1.s, c1.l * 1.1**i] )

      c2 = main_rule[:color2]
      c2 = hsl( [(c2.h - 0.12*i)%1.0, c2.s*0.75**i, c2.l * 1.1**i] )

      append_rule( main_rule.merge( :maxthick => thick,
                                    :color1   => rgb(c1),
                                    :color2   => rgb(c2) )) 
    }

  end

end
