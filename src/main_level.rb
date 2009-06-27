require 'level'
require 'vector2'

require 'plant_types'


class MainLevel < Level
  def setup
    @background = @resource_manager.load_image('background.png')

    c = opts[:pivot][:center]
    r = opts[:pivot][:radius]

    @pivot = create_actor :pivot_actor, :x => c[0], :y => c[1], :radius => r

    @plants = []


    @pivot.input_manager.reg MouseDownEvent, :left do |event|
      p = @pivot.nearest_point( event.pos )
      create_plant SamplePlantType.new, :x => p.x, :y => p.y
    end

  end

  attr_reader :pivot

  def draw(target, x_off, y_off)
    @background.blit(target.screen,[0,0])
  end


  def update( time )
    @plants.each { |plant| plant.grow( time * 0.01 ) }    
  end


  def create_plant( type, opts={} )
    @plants << create_actor( :plant_actor, opts.merge(:type => type) )
  end

end
