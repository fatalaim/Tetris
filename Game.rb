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
	attr_accessor :x, :y, :height, :width, :color
	
	@@image = nil

	def initialize(game)
		if @@image == nil
			@@image = Gosu::Image.new(self, "block_file", true)
		end
		
		@x = 0
		@y = 0
		@height = @@image.height
		@width = @@image.width
		@game = game
		@color = 0xffffffff
	end
	
	def draw
		@@image.draw(@x, @y, 0, 1, 1, @color)
	end
	
	def collide(block)
		return @x == block.x || @y == block.y
	end
end

=begin
Each distinct shape will inherit from the base shape class. Each shape will be made of an organization of blocks.
=end
class Shape
	def initialize(game)
		@game = game
		# every shape is 4 blocks
		@blocks = [Block.new(game), Block.new(game), Block.new(game), Block.new(game)]
		
		@x = 0
		@y = 0
		
		@rotation = @blocks[1]
	end
	
	def rotation
	end
	
	def draw
		@blocks.each do |block|
			block.draw
		end
	end
	
	def update
		#falling
	end
	
	def collide
		#check collision of each block in the shape
	end
end


# L shape
class ShapeA < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffffff00
		end
	end
end

# reverse L shape
class ShapeB < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffff00ff
		end
	end
end

# cube shape
class ShapeC < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff00ffff
		end
	end
end

# line shape
class ShapeD < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff00ffff
		end
	end
end

# S shape
class ShapeE < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff0000ff
		end
	end
end

# reverse S shape
class ShapeF < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff00ff00
		end
	end
end

# intersection shape
class ShapeG < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff808080
		end
	end
end

class GameWindow < Gosu::Window
	def initialize
    		super(640, 480, false)
    		self.caption = "Tetris"
    		
    		@grid = Array.new(30, Array.new(10,0.0))
    
    		@background_image = Gosu::Image.new(self, "file.png", true)
  	end

  	def update
		if (button_down?(Gosu::KbEscape))
			close
		end
		
		#call next_shape
  	end

  	def draw
     		@background_image.draw(0, 0, 0)
  	end
  
  	def next_shape
  		#creates the shape and adds to playing field
  	end
  
  	def line_finished
  		#call after each shape is finished falling
  	end
end

window = GameWindow.new
window.show
