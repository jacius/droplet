
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

end
