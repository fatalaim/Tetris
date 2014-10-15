require 'gosu'

=begin
Shape a: L shape
Shape b: reverse L shape
Shape c: cube shape
Shape d: line shape
Shape e: S shape
Shape f: reverse S shape
Shape g: intersection shape
=end

=begin
The block class will be every block in the playing field. Every shape will be made of blocks.
To find out if a line is complete, a touching check is need to see if a block is adjacent to it.
=end
class Block
	def initialize(game)
		@image = Gosu::Image.new(self, "block_file", true)
	end
	
	def draw
	end
	
	def collide(block)
	end
end

=begin
Each distinct shape will inherit from the base shape class. Each shape will be made of an organization of blocks.
=end
class Shape
	def initialize(game)
		# every shape is 4 blocks
		@blocks = [Block.new(game), Block.new(game), Block.new(game), Block.new(game)]
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


# L shape
class ShapeA < Shape
	def initialize(game)
	end
end

# reverse L shape
class ShapeB < Shape
	def initialize(game)
	end
end

# cube shape
class ShapeC < Shape
	def initialize(game)
	end
end

# line shape
class ShapeD < Shape
	def initialize(game)
	end
end

# S shape
class ShapeE < Shape
	def initialize(game)
	end
end

# reverse S shape
class ShapeF < Shape
	def initialize(game)
	end
end

# intersection shape
class ShapeG < Shape
	def initialize(game)
	end
end

class GameWindow < Gosu::Window
	def initialize
    		super(640, 480, false)
    		self.caption = "Tetris"
    
    		#@background_image = Gosu::Image.new(self, "file", true)
  	end

  	def update
		if (button_down?(Gosu::KbEscape))
			close
		end
  	end

  	def draw
     		@background_image.draw(0, 0, 0)
  	end
  
  	def next_shape
  	end
  
  	def line_finished
  	end
end

window = GameWindow.new
window.show
