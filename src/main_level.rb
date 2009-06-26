require 'level'
require 'ftor'

class MainLevel < Level
  def setup
    @background = @resource_manager.load_image('background.png')
  end

  def draw(target, x_off, y_off)
    @background.blit(target.screen,[0,0])
  end
end
