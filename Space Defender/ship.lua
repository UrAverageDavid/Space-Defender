ship = Object:extend()

local WINDOW_WIDTH = 768
local WINDOW_HEIGHT = 816
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

local Stimer = 2

function ship:new()
    self.ship_atlas = love.graphics.newImage('spritesheets/ship.png')
    self.ship_sprite = love.graphics.newQuad(32, 24, 16, 24, self.ship_atlas:getDimensions())
    self.x = 120
    self.y = 200
    self.speed = 500
    self.dead = false

    self.width = 16
    self.height = 24
end 

function ship:update(dt)
    ani_timer = ani_timer - dt

    if ani_timer <= 0 then
        ani_timer = 1/fps
        frame = frame + 1
        framey = framey + 1
        if frame > num_frames then frame = 1 end
        if framey > num_framesy then framey = 0 end
        xoffset = 16 * frame
        yoffset = 24 * framey

        if love.keyboard.isDown('a') then
            self.ship_sprite:setViewport(xoffset, yoffset, 16, 24)
        elseif love.keyboard.isDown('d') then
            self.ship_sprite:setViewport(xoffset, yoffset, 16, 24)
        elseif love.keyboard.isDown('w') then
            self.ship_sprite:setViewport(32, yoffset, 16, 24)
        elseif love.keyboard.isDown('s') then
            self.ship_sprite:setViewport(32, yoffset, 16, 24)
        else
            self.ship_sprite:setViewport(32, yoffset, 16, 24)
        end
    end
end

function ship:draw()
    love.graphics.draw(self.ship_atlas, self.ship_sprite, self.x, self.y, 0, 1, 1)
end 

