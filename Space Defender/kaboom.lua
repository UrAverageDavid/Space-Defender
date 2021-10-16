kaboom = Object:extend()

-- variables needed
local fps = 10
local ani_timer = 1/fps
local frame = 1
local num_frames = 2

local xoffset
local yoffset = 0

local smalloffsetx

local framey = 0
local num_framesy = 1

function kaboom:new(x, y)
    self.kaboom_atlas = love.graphics.newImage('spritesheets/explosion.png')
    self.kaboom_sprite = love.graphics.newQuad(0, 0, 16, 16, self.kaboom_atlas:getDimensions())
    self.x = x
    self.y = y
    self.speed = 50
    self.type = boom

    self.width = 16
    self.height = 16

    self.dead = false
end 

function bullet:update(dt)
    ani_timer = ani_timer - dt
    if ani_timer <= 0 then
        ani_timer = 1/fps
        frame = frame + 1
        framey = framey + 1
        if frame > num_frames then frame = 1 end
        if framey > num_framesy then framey = 0 end
        xoffset = 16 * frame
        yoffset = 16 * framey

        smalloffsetx = 16 * framey
        midoffsetx = 16 * framey

        self.kaboom_sprite:setViewport(smalloffsetx, 0, 16, 16)
    end
end
