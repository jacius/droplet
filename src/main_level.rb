require 'level'
require 'vector2'

class MainLevel < Level
  def setup
    @background = @resource_manager.load_image('background.png')

    c = opts[:center]
    r = opts[:radius]

    @pivot = create_actor :pivot_actor, :x => c[0], :y => c[1], :radius => r

  end

  attr_reader :pivot

  def draw(target, x_off, y_off)
    @background.blit(target.screen,[0,0])
  end
end
