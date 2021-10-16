bullet = Object:extend()

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

function bullet:new(x, y)
    self.bullet_atlas = love.graphics.newImage('spritesheets/laser-bolts.png')
    self.bullet_sprite = love.graphics.newQuad(0, 16, 16, 16, self.bullet_atlas:getDimensions())
    self.x = x
    self.y = y
    self.speed = 400

    self.width = 16
    self.height = 16

    self.type = bullet
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
        yoffset = 24 * framey

        smalloffsetx = 16 * framey
        midoffsetx = 32 * framey

        self.bullet_sprite:setViewport(smalloffsetx, 16, 16, 16)
    end

    self.y = self.y - self.speed * dt
end

function bullet:checkCollision(obj)
    local self_left = self.x
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local window_height = 272

    local obj_left = obj.x or 0
    local obj_right = obj.x + obj.width or 0
    local obj_top = obj.y or 0
    local obj_bottom = obj.y + obj.height or 0

    if self_right > obj_left and
    self_left < obj_right and
    self_bottom > obj_top and
    self_top < obj_bottom then
        self.dead = true
    end
end

function bullet:draw()
    love.graphics.draw(self.bullet_atlas, self.bullet_sprite, self.x, self.y, 0, 1, 1)
end