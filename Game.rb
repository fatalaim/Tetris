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
		
		@rotation = @blocks[1];
	end
	
	def rotation
	end
	
	def draw
		@blocks.each do |block|
			block.draw
		end
	end
	
	def update
	end
	
	def collide
	end
end


# L shape
class ShapeA < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffff7f00
		end
	end
end

# reverse L shape
class ShapeB < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff0000ff
		end
	end
end

# cube shape
class ShapeC < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffffff00
		end
	end
end

# line shape
class ShapeD < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffb2ffff
		end
	end
end

# S shape
class ShapeE < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xff00ff00
		end
	end
end

# reverse S shape
class ShapeF < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffff0000
		end
	end
end

# intersection shape
class ShapeG < Shape
	def initialize(game)
		super(game)
		
		@rotation = @blocks[1]
		@blocks.each do |block|
			block.color = 0xffff00ff
		end
	end
end

class GameWindow < Gosu::Window
	def initialize
    		super(640, 480, false)
    		self.caption = "Tetris"
    
    		@background_image = Gosu::Image.new(self, "file", true)
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
