--[[
    -- Powerup Class --

    Represents a powerup that randomly spawns when the ball hits a brick.

    Spawns at the brick's x,y position and gradually falls towards paddle. 

    If it touches the paddle then a special event is triggered. 
]]

Powerup = Class{}

function Powerup:init(x,y)
    -- powerup's x,y position.
    self.x = x
    self.y = y

    self.dy = 0

    self.inPlay = true

    -- Generate random powerup event
    self.event = math.random(1,3)
end

function Powerup:hit()
    self.inPlay = false
end

function Powerup:update(dt)
    self.dy = 0.25
    self.y = self.y + self.dy
    if self.y > VIRTUAL_HEIGHT then
        self.inPlay = false
    end
end

function Powerup:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][1], self.x, self.y)
    end
end
