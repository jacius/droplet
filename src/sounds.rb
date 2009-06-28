

module Sounds

  Rubygame::Sound.autoload_dirs = \
    [File.join( File.dirname(__FILE__), "..", "data", "sound" )]

  def self.[]( key )
    Rubygame::Sound["#{key}.ogg"].dup
  end

end
