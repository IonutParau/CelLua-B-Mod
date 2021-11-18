bigBangID = 0

function DoBingBang(x, y)
  -- for cx=1,width-2 do
  --   for cy=1,height-2 do
  --     cells[cy][cx] = {
  --       ctype = 0,
  --       rot = 0,
  --       lastvars = {
  --         cx,
  --         cy,
  --         0
  --       }
  --     }
  --   end
  -- end

  for i=1, math.floor((width*height)/3) do
    local dir = math.floor(love.math.random(0, 3))
    local randomType = love.math.random(-1, #tex)
    PushCell(x, y, dir, nil, nil, randomType)
  end
  cells[y][x].ctype = 0
end