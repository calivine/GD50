--[[
    -- Powerup Class --

    Represents a powerup that randomly spawns when the ball hits a brick.

    Spawns at the brick's x,y position and gradually falls towards paddle. 

    If it touches the paddle then a special event is triggered. 
]]

Powerup = Class{}

function Powerup:init(x, y, containsLocked)
    -- powerup's x,y position.
    self.x = x
    self.y = y

    self.dy = 0

    self.inPlay = true

    -- Generate random powerup event
    if containsLocked then self.power = 10 else self.power = math.random(1,9) end
    -- self.containsLocked = containsLocked

    self.p_tbl =
    {
        [1] = function ()
            Logger('Calling Powerup:redX')
            configs['score'] = configs['score'] - 1000
        end,
        [2] = function ()
            Logger('Calling Powerup:greenX')
            configs['score'] = configs['score'] + 1000
        end,
        [3] = function ()
            Logger('Calling Powerup:extraLife')
            configs['health'] = configs['health'] + 1
        end,
        [4] = function (bricks, balls, configs)
            Logger('Calling Powerup:loseLife')
            gSounds['hurt']:play()
            configs['health'] = configs['health'] - 1
        end,
        [5] = function (bricks, balls, configs)
            Logger('Calling Powerup:speedUp')
            for k, ball in pairs(balls) do
                ball:speedUp()
            end
        end,
        [6] = function (bricks, balls, configs)
            Logger('Calling Powerup:slowDown')
            for k, ball in pairs(balls) do
                ball:slow()
            end
        end,
        [7] = function ()
            Logger('Calling Powerup:decreaseSize')
            -- Shrink effective size of any balls in play
        end,
        [8] = function (bricks, balls, configs)
            -- Grow effective size of any balls in play
            for k, ball in pairs(balls) do
                Logger(ball.skin)
                ball:grow()
            end
        end,
        [9] = function (bricks, balls, configs)
            -- Generate new balls
            for i = 0, 1 do
                new_ball = Ball(1)
                new_ball.x = VIRTUAL_WIDTH / 2 + math.random(100,200)
                new_ball.y = VIRTUAL_HEIGHT / 2
                new_ball.dx = math.random(-200,200)
                new_ball.dy = math.random(-50,50)
                balls[table.getn(balls) + 1] = new_ball
            end
        end,
        [10] = function (bricks, balls, configs)
            for k, brick in pairs(bricks) do
                if brick:isLocked() then
                    -- Unlock the locked brick
                    brick:unlock()
                    -- No more locked bricks in the game
                    configs['containsLocked'] = false
                end
            end
        end
    }
end

function Powerup:hit()
    self.inPlay = false
end

function Powerup:update(dt)
    self.dy = 0.21
    self.y = self.y + self.dy
    if self.y > VIRTUAL_HEIGHT then
        self.inPlay = false
    end
end

function Powerup:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][self.power], self.x, self.y)
    end
end

function Powerup:call(bricks, balls, configs)
    self.p_tbl[self.power](bricks, balls, configs)
end

function Powerup:collide(paddle)
    return self.y + 16 >= paddle.y and self.x >= paddle.x and self.x + 16 <= paddle.x + paddle.width and self.inPlay
end



