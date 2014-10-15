require 'gosu'

class Block
	def initialize
	end
	
	def draw
	end
	
	def collide(block)
	end
end

class Shape
	def initialize
	end
	
	def rotation
	end
	
	def draw
	end
	
	def update
	end
	
	def collide
	end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Tetris"
  end

  def update
	if (button_down?(Gosu::KbEscape))
		close
	end
  end

  def draw
  end
  
  def next_shape
  end
  
  def line_finished
  end
end

window = GameWindow.new
window.show
