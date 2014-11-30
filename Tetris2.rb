require 'gosu' 
include Gosu

#
# Tetris 
#   CS4121 Team project - Ruby
#   11/26/14
#


#TODO fix hardcoded block/game sizes so that these values can control game setup
$blockSize = 40
$gameWidth = 10
$gameHeight = 16

$delay = 0.5
$score = 0.0

class Block

  attr_accessor :xgrid
  attr_accessor :ygrid
  def initialize(xgridin,ygridin,colorInt)
	
	@xgrid = xgridin
	@ygrid = ygridin
	
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
   @x = @xgrid*@size
   @y = @ygrid*@size
   window.draw_quad(@x, 		  @y, 	    @color2, 
    		   		@x+@size,	  @y,	    @color2, 
    		   		@x, 		  @y+@size,   @color2, 
    		   		@x+@size,	  @y+@size,   @color2, 0)
   window.draw_quad(@x+2, 	  @y+2, 	    @color2, 
    		   		@x+@size-2, @y+2,	    @color1, 
    		   		@x+2, 	  @y+@size-2, @color1, 
    		   		@x+@size-2, @y+@size-2, @color1, 0)
  end  
end
  
  
  
class GameGrid
  attr_writer :arrow
  
  def initialize(window)
    @window = window
    @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
    reset()
  end

#Draw the background, current shape, blocks, and score
  def draw()
    drawBackground()
    
    @blocks.each do |b|
       b.draw @window
    end   
    
    @shape.each  do |b|
       b.draw @window   
    end   
    
    @font.draw("Score: #{Integer($score)}", 20, 20, 0, 1.2, 1.2, 0xff888888)
  end

#Main loop of the game
  def update()
    #only update after time delay (decreases as more lines cleared)
    if (Time.now - @oldTime) > ($delay-($score/100))
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
  	        $score += 1  
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
    @oldTime = Time.now
    $score = 0.0
    newShape()
  end  
  
#create a random new shape of 4 blocks, saved to the @shape array
  def newShape()
    @shapeInt = (1+rand(7))
    @rotation = 0
    if @shapeInt == 1 #Line
      @shape.push(Block.new(5,1,1))
      @shape.push(Block.new(6,1,1))
      @shape.push(Block.new(7,1,1))
      @shape.push(Block.new(8,1,1))
    elsif @shapeInt == 2 #ReverseL
      @shape.push(Block.new(5,0,2))
      @shape.push(Block.new(5,1,2))
      @shape.push(Block.new(6,1,2))
      @shape.push(Block.new(7,1,2)) 
    elsif @shapeInt == 3 #LBlock
      @shape.push(Block.new(8,0,3)) 
      @shape.push(Block.new(8,1,3))
      @shape.push(Block.new(7,1,3))
      @shape.push(Block.new(6,1,3))
    elsif @shapeInt == 4 #Square
      @shape.push(Block.new(6,1,4))
      @shape.push(Block.new(6,0,4))
      @shape.push(Block.new(7,1,4))
      @shape.push(Block.new(7,0,4))
    elsif @shapeInt == 5 #SBlock
      @shape.push(Block.new(5,1,5))
      @shape.push(Block.new(6,1,5))
      @shape.push(Block.new(6,0,5))
      @shape.push(Block.new(7,0,5))
    elsif @shapeInt == 6 #ZBlock
      @shape.push(Block.new(8,1,6))
      @shape.push(Block.new(7,1,6))
      @shape.push(Block.new(7,0,6))
      @shape.push(Block.new(6,0,6))  
    elsif @shapeInt == 7 #TBlock
      @shape.push(Block.new(5,1,7))
      @shape.push(Block.new(6,1,7))
      @shape.push(Block.new(6,0,7))  
      @shape.push(Block.new(7,1,7))
                  
    end
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
      if s.xgrid == 11
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
      if s.xgrid == 2
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
    if rCollision == false
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
    x = $blockSize*2
    y = $blockSize*2
    xSize = $blockSize*$gameWidth
    ySize = $blockSize*$gameHeight

    @window.draw_quad(x, 	 y, 		Color.argb(0x66888888), 
    				  x+xSize, y,  	Color.argb(0x44888888), 
    				  x, 	 y+ySize, Color.argb(0x44888888), 
    			  	  x+xSize, y+ySize, Color.argb(0x22888888), 0)
  end 

end 
  
  
   
class GameWindow < Window
  def initialize
    super $blockSize*($gameWidth+4), $blockSize*($gameHeight+4), false, 100
    self.caption = "Tetris 2"
    @gameGrid = GameGrid.new(self)
  end

  #Called automagically by Gosu whenever needed
  def draw()
	@gameGrid.draw()
  end

  #Called 1/60 times a second, the main logic loop for the game
  def update()
  	@gameGrid.update
  end

  def button_down(key)
    if key == KbDown
      @gameGrid.keyDown()
    elsif key == KbRight
      @gameGrid.keyRight()
    elsif key == KbLeft
      @gameGrid.keyLeft()
    elsif key == KbUp
      @gameGrid.keyUp()      
    end  
  end
end

GameWindow.new.show
    
