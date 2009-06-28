
require 'plant_rule'


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

  ColorRGB = Rubygame::Color::ColorRGB

  def initialize
    super()

    main_rule = {:maxchilds  => 3,
                 :childsgrow => 45,

                 :spread     => Math::PI * 0.8,
                 :tilt       => 0,

                 :color1     => ColorRGB.new([0.25, 0.50, 0.30]),
                 :color2     => ColorRGB.new([0.08, 0.40, 0.70]),
                 :colorgrow  => 50,

                 :maxlong    => 35,
                 :longgrow   => 80,
                 
                 :maxthick   => 10,
                 :thickgrow  => 150,

                 :waveamp    => Math::PI * 0.05,
                 :wavefreq   => 1.0,
                 :waveagit   => 15.0,

                 :agitdec    => 0.98 }

    gens = 4

    gens.times{ |i|
      thick = main_rule[:maxthick] * 0.66**i
      append_rule( main_rule.merge( :maxthick => thick ) ) 
    }

  end

end
