
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

    append_rule( :maxchilds  => 3,
                 :childsgrow => 5,

                 :spread     => Math::PI * 0.8,
                 :tilt       => 0,

                 :color1     => ColorRGB.new([61,133,77]),
                 :color2     => ColorRGB.new([21,100,183]),
                 :colorgrow  => 10,

                 :maxlong    => 35,
                 :longgrow   => 24,
                 
                 :maxthick   => 5,
                 :thickgrow  => 29 )

  end

end
