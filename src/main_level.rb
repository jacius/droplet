require 'level'
require 'vector2'

require 'plant_types'


class MainLevel < Level
  def setup
    @first_draw = true

    @background = @resource_manager.load_image('background.png')

    c = opts[:pivot][:center]
    r = opts[:pivot][:radius]

    @pivot = create_actor :pivot_actor, :x => c[0], :y => c[1], :radius => r
    @pivot.visible = false

    @plants = []


    @pivot.input_manager.reg MouseDownEvent, :left do |event|
      create_random_plant( event )
    end

  end

  attr_reader :pivot

  def draw(target, x_off, y_off)
      set_title( target )

    @background.blit(target.screen,[0,0])
  end


  def update( time )
    @plants.each { |plant| plant.update( time * 0.001 ) }
    @plants.delete_if { |plant| plant.root.health == 0 }
  end


  def create_random_plant( event )
    p = @pivot.nearest_point( event.pos )

    hue1 = rand
    hue2 = (hue1 + 0.2)%1.0
    val1 = 0.3 + rand*0.3
    val2 = val1 - 0.2
    long = 35 + rand*10

    i = rand(3)
    gens = [3,4,5][i]
    maxchilds = [4,3,2][i]

    opts = { 
      :hue1 => hue1, :val1 => val1,
      :hue2 => hue2, :val2 => val2,
      :maxlong => long,
      :maxchilds => maxchilds,
      :gens => gens }

    sounds = ["chimes_high_loop", "chimes_med_loop", "sheepbells_loop",
              "rain_loop", "thin_ether_c3", "thin_ether_gs3",
              "whispering_ears_e5", "organism_c4",]
    soundname = sounds[ rand(sounds.length) ]

    create_plant( SamplePlantType.new(opts),
                  :x => p.x, :y => p.y,
                  :soundname => soundname )
  end


  def create_plant( type, opts={} )
    @plants << create_actor( :plant_actor, opts.merge(:type => type) )
  end


  def set_title( screen )
    screen.title = "Droplet (%d plants)"%@plants.size
  end

end
