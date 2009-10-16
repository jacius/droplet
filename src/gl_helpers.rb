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


require 'opengl'


# Create an OpenGL texture from a Surface
def make_gl_texture( surf )
  id = glGenTextures(1)[0]

  glEnable(GL_TEXTURE_2D)
  glBindTexture(GL_TEXTURE_2D, id)

  format = if( (surf.flags & Rubygame::SRCALPHA) == Rubygame::SRCALPHA )
             GL_RGBA
           else 
             GL_RGB
           end

  glTexImage2D(GL_TEXTURE_2D, 0, format, surf.w, surf.h,
               0, format, GL_UNSIGNED_BYTE, surf.pixels)
  glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameter(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  return id
end


# Draw a textured OpenGL rectangle
def draw_rect( tex, size, topleft=[0,0] )
  glPushMatrix
    glTranslate( topleft.at(0), topleft.at(1), 0 )
    glScale( size.at(0), size.at(1), 1 )

    glEnable(GL_TEXTURE_2D)
    glBindTexture(GL_TEXTURE_2D, tex)
    glColor( 1,1,1,1 )

    glBegin(GL_TRIANGLE_FAN)
      verts = [[ 0.5, 0.5, 0],
               [ 0.0, 1.0, 0],
               [ 0.0, 0.0, 0],
               [ 1.0, 0.0, 0],
               [ 1.0, 1.0, 0],
               [ 0.0, 1.0, 0]]

      verts.each { |vert|
        glTexCoord( *vert )
        glVertex( *vert )
      }
    glEnd

  glPopMatrix
end
