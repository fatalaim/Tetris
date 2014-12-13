require 'gosu'
include Gosu

#
# Tetris 
#   CS4121 Team project - Ruby
#   11/26/14
#
#next piece

#two player
#-game global variables control size
#-menus
#-implementing two games at once
#-interactions between the two (clearing 2+ lines adds lines to opponents)




#TODO fix hardcoded block/game sizes so that these values can control game setup
$blockSize = 40
$gameWidth = 10
$gameHeight = 16

$delay = 0.5


#################################################
# Block Class
#  -creates a new block at xgridin,ygridin
#  - 7 possible colors, chosen with colorInt
#
#################################################
class Block

  attr_accessor :xgrid
  attr_accessor :ygrid
  def initialize(xgridin,ygridin,colorInt,player)

    @xgrid = xgridin
    @ygrid = ygridin
    @player = player

    @color1 = Color.argb(0xff0000ff)
    @color2 = Color.argb(0xff8888ff)
    if colorInt==2
      @color1 = Color.argb(0xff00aa00)
      @color2 = Color.argb(0xff88ff88)
    elsif colorInt==3
      @color1 = Color.argb(0xffff0000)
      @color2 = Color.argb(0xffff8888)
    elsif colorInt==4
      @color1 = Color.argb(0xff00cccc)
      @color2 = Color.argb(0xff88ffff)
    elsif colorInt==5
      @color1 = Color.argb(0xffff00ff)
      @color2 = Color.argb(0xffff88ff)
    elsif colorInt==6
      @color1 = Color.argb(0xffffbb00)
      @color2 = Color.argb(0xffffff88)
    elsif colorInt==7
      @color1 = Color.argb(0xff444444)
      @color2 = Color.argb(0xffaaaa88)
    end

    @size = $blockSize

  end

  def draw(window)
    if @player == 1
       @x = @xgrid*@size
       @y = @ygrid*@size
    end
    if @player == 2
       @x = @xgrid*@size - @size*36
       @y = @ygrid*@size
    end
    window.draw_quad(@x, 		  @y, 	    @color2,
                     @x+@size,	  @y,	    @color2,
                     @x, 		  @y+@size,   @color2,
                     @x+@size,	  @y+@size,   @color2, 0)
    window.draw_quad(@x+2, 	  @y+2, 	    @color2,
                     @x+@size-2, @y+2,	    @color1,
                     @x+2, 	  @y+@size-2, @color1,
                     @x+@size-2, @y+@size-2, @color1, 0)
  end

  def drawPreview(window)
    if @player == 1
       @x = @xgrid*(@size) - @size*3
       @y = @ygrid*(@size) + @size*6
    end
    if @player == 2
       @x = @xgrid*(@size) + @size*4
       @y = @ygrid*(@size) + @size*6
    end
    window.draw_quad(@x, 		  @y, 	    @color2,
                     @x+@size,	  @y,	    @color2,
                     @x, 		  @y+@size,   @color2,
                     @x+@size,	  @y+@size,   @color2, 0)
    window.draw_quad(@x+2, 	  @y+2, 	    @color2,
                     @x+@size-2, @y+2,	    @color1,
                     @x+2, 	  @y+@size-2, @color1,
                     @x+@size-2, @y+@size-2, @color1, 0)
  end

  def resize(newSize)
    @size = newSize
  end
end


#################################################
# GameGrid Class
#  -Handles main logic/drawing of the game
#  -Handles key press events, which move/rotate the falling shape
#
#################################################  
class GameGrid
  attr_writer :arrow

  def initialize(window,player)
    @menuControl =0
    @window = window
    @player = player
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    reset()
  end

  def menuControler(x)
    @menuControl =x
  end
#Draw the background, current shape, blocks, and score
  def draw()
    if @menuControl ==0

      @font.draw("hit esc to start", 15, 10, 0, 1.2, 1.2, 0xff888888)
    else
      drawBackground()
      drawNextPiece()

      @blocks.each do |b|
        b.draw @window
      end

      @shape.each  do |b|
        b.draw @window
      end

      if @player == 1
         @font.draw("Score: #{Integer(@score)}", 15, 10, 0, 1.2, 1.2, 0xff888888)
         @font.draw("Next: ", 15, 35, 0, 1.2, 1.2, 0xff888888)
      end
      if @player == 2
         @font.draw("Score: #{Integer(@score)}", 575, 10, 0, 1.2, 1.2, 0xff888888)
         @font.draw("Next: ", 575, 35, 0, 1.2, 1.2, 0xff888888)
      end
    end
  end

#Main loop of the game
  def update()
    #only update after time delay (decreases as more lines cleared)
    if (Time.now - @oldTime) > ($delay-(@score/100))
      collision = false

      #check object below shapes
      @shape.each do |sb|
        ycoord = sb.ygrid
        xcoord = sb.xgrid
        if ycoord == (15+2)
          collision = true
          break
        end
        @blocks.each do |bb|
          if ycoord == (bb.ygrid-1) && xcoord == bb.xgrid
            collision = true
            break
          end
        end
      end
      #remove the shape if collision, otherwise drop piece one row
      if collision == true
        @shape.each do |s|
          @blocks.push(s)
        end
        @shape.clear
        previewToShape()
        newShape()
        #remove completed lines
        @lineCheck = Array.new(19,0)
        @blocks.each do |b|
          @lineCheck[b.ygrid] += 1
        end
        count = 0
        while count < 19
          if @lineCheck[count] >= 10
            @blocks.delete_if{|b| b.ygrid == count}
            @blocks.each do |b|
              if b.ygrid < count
                b.ygrid += 1
              end
            end
            @score += 1
          end
          count += 1
        end

        #check for losing the game
        @blocks.each do |bb|
          if bb.ygrid == 2 && bb.xgrid == 5 || (bb.ygrid) < 2
            reset()
            break
          end
        end


      else
        @shape.each do |s|
          s.ygrid += 1
        end
      end

      @oldTime = Time.now
    end
  end

#reset the game data
  def reset()
    @blocks = Array.new
    @shape = Array.new
    @preview = Array.new
    @oldTime = Time.now
    @score = 0.0
    newShape()
    previewToShape()
    newShape()
  end

#create a random new shape of 4 blocks, saved to the @preview array
  def newShape()
    @preview.clear
    @preShapeInt = (1+rand(7))
    @rotation = 0
    if @player == 1
    if @preShapeInt == 1 #Line
      @preview.push(Block.new(5,1,1,1))
      @preview.push(Block.new(6,1,1,1))
      @preview.push(Block.new(7,1,1,1))
      @preview.push(Block.new(8,1,1,1))
    elsif @preShapeInt == 2 #ReverseL
      @preview.push(Block.new(5,0,2,1))
      @preview.push(Block.new(5,1,2,1))
      @preview.push(Block.new(6,1,2,1))
      @preview.push(Block.new(7,1,2,1))
    elsif @preShapeInt == 3 #LBlock
      @preview.push(Block.new(8,0,3,1))
      @preview.push(Block.new(8,1,3,1))
      @preview.push(Block.new(7,1,3,1))
      @preview.push(Block.new(6,1,3,1))
    elsif @preShapeInt == 4 #Square
      @preview.push(Block.new(6,1,4,1))
      @preview.push(Block.new(6,0,4,1))
      @preview.push(Block.new(7,1,4,1))
      @preview.push(Block.new(7,0,4,1))
    elsif @preShapeInt == 5 #SBlock
      @preview.push(Block.new(5,1,5,1))
      @preview.push(Block.new(6,1,5,1))
      @preview.push(Block.new(6,0,5,1))
      @preview.push(Block.new(7,0,5,1))
    elsif @preShapeInt == 6 #ZBlock
      @preview.push(Block.new(8,1,6,1))
      @preview.push(Block.new(7,1,6,1))
      @preview.push(Block.new(7,0,6,1))
      @preview.push(Block.new(6,0,6,1))
    elsif @preShapeInt == 7 #TBlock
      @preview.push(Block.new(5,1,7,1))
      @preview.push(Block.new(6,1,7,1))
      @preview.push(Block.new(6,0,7,1))
      @preview.push(Block.new(7,1,7,1))
    end
    end

    if @player == 2
    if @preShapeInt == 1 #Line
      @preview.push(Block.new(55,1,1,2))
      @preview.push(Block.new(56,1,1,2))
      @preview.push(Block.new(57,1,1,2))
      @preview.push(Block.new(58,1,1,2))
    elsif @preShapeInt == 2 #ReverseL
      @preview.push(Block.new(55,0,2,2))
      @preview.push(Block.new(55,1,2,2))
      @preview.push(Block.new(56,1,2,2))
      @preview.push(Block.new(57,1,2,2))
    elsif @preShapeInt == 3 #LBlock
      @preview.push(Block.new(58,0,3,2))
      @preview.push(Block.new(58,1,3,2))
      @preview.push(Block.new(57,1,3,2))
      @preview.push(Block.new(56,1,3,2))
    elsif @preShapeInt == 4 #Square
      @preview.push(Block.new(56,1,4,2))
      @preview.push(Block.new(56,0,4,2))
      @preview.push(Block.new(57,1,4,2))
      @preview.push(Block.new(57,0,4,2))
    elsif @preShapeInt == 5 #SBlock
      @preview.push(Block.new(55,1,5,2))
      @preview.push(Block.new(56,1,5,2))
      @preview.push(Block.new(56,0,5,2))
      @preview.push(Block.new(57,0,5,2))
    elsif @preShapeInt == 6 #ZBlock
      @preview.push(Block.new(58,1,6,2))
      @preview.push(Block.new(57,1,6,2))
      @preview.push(Block.new(57,0,6,2))
      @preview.push(Block.new(56,0,6,2))
    elsif @preShapeInt == 7 #TBlock
      @preview.push(Block.new(55,1,7,2))
      @preview.push(Block.new(56,1,7,2))
      @preview.push(Block.new(56,0,7,2))
      @preview.push(Block.new(57,1,7,2))
    end
    end

    #resize the blocks for preview
    @preview.each do |b|
      b.resize($blockSize/4)
    end
  end

  def previewToShape()
    @shapeInt = @preShapeInt
    @preview.each do |b|
      @shape.push(b)
      b.resize($blockSize)
    end
    @preview.clear
  end


#handle keypress down (move piece down 1)
  def keyDown
    collision = false
    @shape.each do |s|
      if s.ygrid >= 17
        collision = true
        break
      end
      @blocks.each do |bb|
        if bb.ygrid == s.ygrid+1 && bb.xgrid == s.xgrid
          collision = true
          break
        end
      end
    end
    if collision == false
      @shape.each do |s|
        s.ygrid += 1
      end
    end
  end

#handle keypress right (shift piece right)
  def keyRight
    collision = false
    @shape.each do |s|
      if s.xgrid == 11 || s.xgrid == 61
        collision = true
        break
      end
      @blocks.each do |bb|
        if bb.ygrid == s.ygrid && bb.xgrid == s.xgrid+1
          collision = true
          break
        end
      end
    end
    if collision == false
      @shape.each do |s|
        s.xgrid += 1
      end
    end
  end

#handle keypress left (shift piece left)
  def keyLeft
    collision = false
    @shape.each do |s|
      if s.xgrid == 2 || s.xgrid == 52
        collision = true
        break
      end
      @blocks.each do |bb|
        if bb.ygrid == s.ygrid && bb.xgrid == s.xgrid-1
          collision = true
          break
        end
      end
    end
    if collision == false
      @shape.each do |s|
        s.xgrid -= 1
      end
    end
  end

#handle keypress up (rotate piece clockwise)
  def keyUp

    rCollision = false
    #temp array to check for collisions in the potential rotation
    rotateArray = Array.new(4, [0,0])
    count = 0
    #set temp array to current shape location
    while count < 4
      rotateArray[count] = [@shape[count].xgrid, @shape[count].ygrid]
      count += 1
    end

    #rotate temp array for each shape in each of its four potential positions
    #pivot clockwise around the second block in the shape
    if @shapeInt == 1 #Line
      if @rotation == 0
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]+2]
      elsif @rotation == 1
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]-2]
      elsif @rotation == 2
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]-2]
      elsif @rotation == 3
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]+2]
      end

    elsif @shapeInt == 2 #ReverseL
      if @rotation == 0
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]+2]
      elsif @rotation == 1
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]-2]
      elsif @rotation == 2
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]-2]
      elsif @rotation == 3
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]+2]
      end

    elsif @shapeInt == 3 #LBlock
      if @rotation == 0
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]-2]
      elsif @rotation == 1
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]+2]
      elsif @rotation == 2
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]+2]
      elsif @rotation == 3
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]-2]
      end
    elsif @shapeInt == 4 #Square (no rotation or collision check needed)
      rCollision = true
    elsif @shapeInt == 5 #SBlock
      if @rotation == 0
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]+0, rotateArray[3][1]+2]
      elsif @rotation == 1
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]+0]
      elsif @rotation == 2
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+0, rotateArray[3][1]-2]
      elsif @rotation == 3
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]+0]
      end
    elsif @shapeInt == 6 #ZBlock
      if @rotation == 0
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]+2, rotateArray[3][1]+0]
      elsif @rotation == 1
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]+0, rotateArray[3][1]+2]
      elsif @rotation == 2
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]-2, rotateArray[3][1]+0]
      elsif @rotation == 3
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+0, rotateArray[3][1]-2]
      end
    elsif @shapeInt == 7 #TBlock
      if @rotation == 0
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]-1, rotateArray[3][1]+1]
      elsif @rotation == 1
        rotateArray[0] = [rotateArray[0][0]+1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]+1]
        rotateArray[3] = [rotateArray[3][0]-1, rotateArray[3][1]-1]
      elsif @rotation == 2
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]+1]
        rotateArray[2] = [rotateArray[2][0]-1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+1, rotateArray[3][1]-1]
      elsif @rotation == 3
        rotateArray[0] = [rotateArray[0][0]-1, rotateArray[0][1]-1]
        rotateArray[2] = [rotateArray[2][0]+1, rotateArray[2][1]-1]
        rotateArray[3] = [rotateArray[3][0]+1, rotateArray[3][1]+1]
      end
    end

    #check for rotation collisions
    if rCollision == false && @player == 1
      count = 0
      while count < 4
        if rotateArray[count][0] < 2 || rotateArray[count][0] > 11 || rotateArray[count][1] > 18
          rCollision = true
          break
        end
        @blocks.each do |b|
          if rotateArray[count][0] == b.xgrid && rotateArray[count][1] == b.ygrid
            rCollision = true
            break
          end
        end
        count += 1
      end
    end

    if rCollision == false && @player == 2
      count = 0
      while count < 4
        if rotateArray[count][0] < 52 || rotateArray[count][0] > 61 || rotateArray[count][1] > 18
          rCollision = true
          break
        end
        @blocks.each do |b|
          if rotateArray[count][0] == b.xgrid && rotateArray[count][1] == b.ygrid
            rCollision = true
            break
          end
        end
        count += 1
      end
    end


    #apply the rotation if there are no collisions
    if rCollision == false
      count = 0
      while count < 4
        @shape[count].xgrid = rotateArray[count][0]
        @shape[count].ygrid = rotateArray[count][1]
        count += 1
      end
      @rotation = (@rotation+1)%4
    end
  end

#draw the game background based on global game width, height, and block size
  def drawBackground()
    if @player == 1
       x = $blockSize*2 #80
       y = $blockSize*2 #80
    end
    if @player == 2
       x = ($blockSize*2)+($blockSize*($gameWidth+4)) #640
       y = $blockSize*2
    end
    xSize = $blockSize*$gameWidth
    ySize = $blockSize*$gameHeight

    @window.draw_quad(x, 	 y, 		Color.argb(0x66888888),
                      x+xSize, y,  	Color.argb(0x44888888),
                      x, 	 y+ySize, Color.argb(0x44888888),
                      x+xSize, y+ySize, Color.argb(0x22888888), 0)
  end

  def drawNextPiece()
    @preview.each do |b|
      b.drawPreview @window
    end
  end

end


#################################################
# GameWindow Class
#  -Creates the game window
#  -Contains the entry points for draw() and update()
#
#################################################   
class GameWindow < Window
  @menuControl =0
  def initialize
    super $blockSize*(($gameWidth+4)*2), $blockSize*($gameHeight+4), false, 100 #1120x800
    self.caption = "Tetris"
    @gameGrid = GameGrid.new(self,1)
    @gameGrid2 = GameGrid.new(self,2)
  end

  #Called automagically by Gosu whenever needed
  def draw()
    @gameGrid.draw()
    @gameGrid2.draw()
  end

  #Called 1/60 times a second, the main logic loop for the game
  def update()
    if @menuControl == 1
      @gameGrid.update
      @gameGrid2.update
    end
  end

  def button_down(key)

    if key == KbEscape
      @menuControl =1
      @gameGrid.menuControler(1)
      @gameGrid2.menuControler(1)
    end
    if key == KbDown
      @gameGrid.keyDown()
    elsif key == KbRight
      @gameGrid.keyRight()
    elsif key == KbLeft
      @gameGrid.keyLeft()
    elsif key == KbUp
      @gameGrid.keyUp()
    elsif key == KbW
      @gameGrid2.keyUp()
    elsif key == KbA
      @gameGrid2.keyLeft()
    elsif key == KbS
      @gameGrid2.keyDown()
    elsif key == KbD
      @gameGrid2.keyRight()
    end
  end
end



GameWindow.new.show
    
