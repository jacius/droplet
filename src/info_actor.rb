#++
# 
# Droplet (musical toy software)
# Copyright (C) 2009  John Croisant  (jacius@gmail.com)
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA  02110-1301, USA.
# 
#++


class InfoActorView < ActorView

  def setup
    @image = actor.resource_manager.load_image('helpcredits.png')
    @tex = make_gl_texture(@image)
  end

  def draw(target, x_off, y_off)
    if( actor.visible )
      draw_rect( @bgtex, target.screen.size )
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
