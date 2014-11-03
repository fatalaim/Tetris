require "gosu"
=begin
Shape a: L shape
Shape b: reverse L shape
Shape c: cube shape
Shape d: line shape
Shape e: S shape
Shape f: reverse S shape
Shape g: intersection shape
=end

class BlockShape
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

end