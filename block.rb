  class Block
    @image
    @blockInside
    def initialize(window)
      @blockInside = false
      @image = Gosu::Image.new(window, "BlankBlock.png", false)


      @x = 0
      @y = 0
      @height = @image.height
      @width = @image.width
      @game = window
      @color = 0xffffffff
    end
    attr_accessor :x, :y, :height, :width, :color


    def getX
      return @x
    end

    def getY
      return @y
    end

    def setX(newX)
      @x = newX
    end

    def setY(newY)
      @y = newY
    end

    def draw
      @image.draw(@y, @x, 1, 1, 1)
    end
    def hasBlock
      return @blockInside
    end
    def setHasBlock(bol)
      @blockInside = bol
    end

    def setBlock(window)
      @image = Gosu::Image.new(window, "BlueBlock.png", false)
      @blockInside =true
    end
    def removeBlock
      @image = Gosu::Image.new(window, "BlankBlock.png", false)
      @blockInside =false
    end
    def collide(block)
      return @x == block.x || @y == block.y
    end
  end