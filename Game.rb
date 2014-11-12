require 'gosu'
require_relative 'player'
require './block'
require './block_shape'
=begin
The block class will be every block in the playing field. Every shape will be made of blocks.
To find out if a line is complete, a touching check is need to see if a block is adjacent to it.
=end

=begin
Each distinct shape will inherit from the base shape class. Each shape will be made of an organization of blocks.
=end

class GameWindow < Gosu::Window
  @gameBlocks
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"

    @background_image = Gosu::Image.new(self, "triforce.jpg", true)
    @gameBlocks = Array.new( 20  )
    @xPosition =0
    @yPosition =0
    @oldTime = Time.now
    while((Time.now- @oldTime)< 0.75)

    end
    x=0
  while x < 20
      i = 0
      @gameBlocks[x] = Array.new(10)
      @yPosition =0
      while i < 10  do
        @gameBlocks[x][i] = Block.new(self)
        @gameBlocks[x][i].setX(@xPosition)
        @gameBlocks[x][i].setY(@yPosition)

        i+=1
        @yPosition +=32
      end
      x+=1
      @xPosition = 32 +@xPosition
    end

    @gameBlocks[9][0].setBlock(self)
    @blocks = Block.new(self)
    @player = Player.new(self)
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
    if button_down? Gosu::KbDown or button_down? Gosu::GpButton3 then

      @player.setY(32)
      if(@gameBlocks[@player.getYPosition][0].hasBlock)
        printf("here")
      end
    end
  end

  def draw

    @oldTime =Time.now
    @player.draw
    for x in @gameBlocks
      for y in x
        y.draw
      end
    end
    while((Time.now- @oldTime)< 0.06)

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
