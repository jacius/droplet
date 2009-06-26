require 'level'
require 'vector2'

class MainLevel < Level
  def setup
    @background = @resource_manager.load_image('background.png')

    # Supposed to be able to do this, but can't?
    # c = opts[:center]
    # r = opts[:radius]

    c = [240, 240]
    r = 206

    create_actor :pivot, :x => c[0], :y => c[1], :radius => r

  end

  def draw(target, x_off, y_off)
    @background.blit(target.screen,[0,0])
  end
end
