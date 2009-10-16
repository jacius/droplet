class Game

  constructor :wrapped_screen, :input_manager, :sound_manager,
    :mode_manager

  def setup
    w,h = @wrapped_screen.width, @wrapped_screen.height

    glViewport( 0, 0, w, h )
    glShadeModel(GL_FLAT)

    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glOrtho(0, w, h, 0, 0, 100) # upside down to match SDL

    @mode_manager.change_mode_to :default
  end

  def update(time)
    @mode_manager.update time
    draw
  end

  def draw
    glClearColor(0.0, 0.0, 0.0, 1.0)
    glClear(GL_COLOR_BUFFER_BIT)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()

    @mode_manager.draw @wrapped_screen

    glFlush()
    Rubygame::GL.swap_buffers
  end

end
