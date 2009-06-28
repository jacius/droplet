

module Sounds

  Rubygame::Sound.autoload_dirs = \
    [File.join( File.dirname(__FILE__), "..", "data", "sounds" )]

  def self.[]( key )
    Rubygame::Sound[key].dup
  end

end
