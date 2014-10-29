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
	
	@image = nil

	def initialize(game)
		if @image == nil
			@image = Gosu::Image.new(game, "BlueBlock.png", false)
		end
		
		@x = 32
		@y = 0
		@height = @image.height
		@width = @image.width
		@game = game
		@color = 0xffffffff
	end
	
	def draw
		@image.draw(@x, @y, 1, 1, 1, @color)
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
class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "BlueBlock.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= 90
  end

  def turn_right
    @angle += 90
  end

  def accelerate
    @vel_x = Gosu::offset_x(@angle, 32)
    @vel_y = Gosu::offset_y(@angle, 32)
  end
  def iterate
    @y += 32
  end
  def move
    @x += @vel_x
    @y += 32
    @x %= 640
    @y %= 480

  end

  def draw
    @image.draw(@x, @y, 1, 1, 1)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new(self, "triforce.jpg", true)
    @blocks = Block.new(self)
    @player = Player.new(self)
    @player.warp(320, 240)
  end
def olderTime1
olderTime = Time.now
end
  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then

    end
    if ((Time.now- olderTime1) > 1 )
      @player.iterate
      olderTime1 = Time.now
    end
    @player.move
  end

  def draw

    @oldTime =Time.now
    @player.draw
    @blocks.draw
    while((Time.now- @oldTime)< 0.75)

    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
  def Timer
    Time.now
    @time = Time.now
  end
  def drop_box

  end
end
window = GameWindow.new
window.show
