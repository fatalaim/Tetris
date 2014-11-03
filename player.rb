class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "BlueBlock.png", false)
    @x = @y = @vel_x = @vel_y = @angle = 0
    @y =0
    @score = 0
  end


  def turn_left
    @angle -= 90
  end

  def turn_right
    @angle += 90
  end

  def iterate
    @y += 32
  end
  def move
    @x += 0
    @y = 32

  end

  def getXPosition
    return (@x/32)
  end

  def getYPosition
    return (@y/32)
  end
  def setX(newX)
    @x += newX
  end

  def setY(newY)
    @y += newY
  end
  def draw
    @image.draw(0, @y, 3, 1, 1)
  end
end
