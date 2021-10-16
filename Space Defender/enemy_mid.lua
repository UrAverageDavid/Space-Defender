enemy_mid = Object:extend()

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

boom = love.audio.newSource('sounds/boom.mp3', 'static')

function enemy_mid:new(x, y)
    self.enemy_mid_atlas = love.graphics.newImage('spritesheets/enemy-medium.png')
    self.enemy_mid_sprite = love.graphics.newQuad(0, 0, 32, 16, self.enemy_mid_atlas:getDimensions())
    self.x = x
    self.y = y
    self.speed = 150
    self.type = enemy

    self.width = 32
    self.height = 16

    self.hp = 4
    self.dead = false
    self.points = 0
    self.pointplus = 3
end 

function enemy_mid:update(dt)
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

        self.enemy_mid_sprite:setViewport(midoffsetx, 0, 32, 16)
    end
    
    if self.hp <= 0 then
        boom:stop()
        boom:play()
        self.dead = true
        self.points = self.points + 3
    end

    self.y = self.y + self.speed * dt
end

function enemy_mid:checkCollision(obj)
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
        obj.dead = true
    end
end

function enemy_mid:draw()
    love.graphics.draw(self.enemy_mid_atlas, self.enemy_mid_sprite, self.x, self.y, 0, 1, 1)
end
