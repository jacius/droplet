
require 'plantnode'


class PlantType

  def initialize
    @rules = []
  end

  def append_rule( rule )
    @rules << rule
    prev_rule = @rules[-2]
    prev_rule.next = rule if prev_rule
  end

end
