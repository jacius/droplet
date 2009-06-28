

class InfoActorView < ActorView

  def setup
    @image = actor.resource_manager.load_image('helpcredits.png')
  end

  def draw(target, x_off, y_off)
    if( actor.visible )
      @image.blit( target.screen, [0,0] )
    end
  end

end


class InfoActor < Actor

  def setup
    @open = false
    @visible = false

    # Rect to click to open it.
    @open_rect = Rect.new([0,0,180,50])
    @open_rect.center = [526, 448]

    # Rect to click to close it.
    @close_rect = Rect.new([0,0,30,30])
    @close_rect.center = [556, 52]

    @input_manager.reg MouseDownEvent, :left do |event|

      if( !@closed and @open_rect.collide_point?(*event.pos) )
        @level.open_info
      elsif( @open and @close_rect.collide_point?(*event.pos) )
        @level.close_info
      end

    end
  end


  def open
    @open = true
    @visible = true
  end

  def close
    @open = false
    @visible = false
  end

end
