function randint(min, max)
  return math.floor(love.math.random(min, max))
end

brainID = 0

--- @class Neuron
--- @param maxpointer number
--- @field value number
--- @field pointer number
--- @field type number
--- @field weight number
--- @field mutate function
local function Neuron(maxpointer)
  return {
    value = 0,
    pointer = randint(1, maxpointer),
    type = randint(0, 4),
    weight = love.math.random(),
    mutate = function(self, maxpointer)
      self.pointer = randint(1, maxpointer)
      self.type = randint(0, 4)
      self.weight = self.weight + love.math.random()
    end,
  }
end

local function ProcessNeuron(neuron)
  if neuron.type == 0 then
    neuron.value = neuron.value + neuron.weight
  elseif neuron.type == 1 then
    neuron.value = neuron.value - neuron.weight
  elseif neuron.type == 2 then
    neuron.value = neuron.value * neuron.weight
  elseif neuron.type == 3 then
    neuron.value = neuron.value / neuron.weight
  elseif neuron.type == 4 then
    neuron.value = neuron.value ^ neuron.weight
  end
  
  return neuron.value, neuron.pointer
end

function MutateNN(nn)
  for i=2,#nn do
    for j=1,#(nn[i]) do
      nn[i][j]:mutate(#(nn[i+1] or {}))
    end
  end
end

local function GetRandomNeuralNetwork()
  return {
    {
      Neuron(3),
      Neuron(3),
      Neuron(3),
      Neuron(3),
    },
    {
      Neuron(3),
      Neuron(3),
      Neuron(3),
    },
    {
      Neuron(1),
      Neuron(1),
      Neuron(1),
    },
    {
      Neuron(3),
    }
  }
end

function ResetNLValues(nn)
  for _, layer in ipairs(nn) do
    for _, neuron in ipairs(layer) do
      neuron.value = 0
    end
  end
end

function ExecuteNeuralNetwork(nn, inputs)
  for i=1,#(nn[1]) do
    nn[1][i].value = inputs[1]
  end
  
  for i=1,#nn-1 do
    for j=1,3 do
      local value, pointer = ProcessNeuron(nn[i][j])
      nn[i+1][pointer].value = nn[i+1][pointer].value + value
    end
  end

  return (nn[4][1].value)
end

function GiveNeuralNetwork(x, y)
  cells[y][x].brain_nn = GetRandomNeuralNetwork()
end

function DoBrain(x, y)
  if not cells[y][x].brain_nn then GiveNeuralNetwork(x, y) end

  local inputs = {}
  local offs = {
    {x = 0, y = 1},
    {x = 0, y = -1},
    {x = 1, y = 0},
    {x = -1, y = 0},
  }
  for _, off in ipairs(offs) do
    local cx, cy = x + off.x, y + off.y
    local ctype = cells[cy][cx].ctype
    local input = 1
    if ctype == 0 then input = 0 end
    if ctype == plantID then input = 0.5 end
    table.insert(inputs, input)
  end

  local dir = math.floor(ExecuteNeuralNetwork(cells[y][x].brain_nn, inputs)) % 5 - 1
  ResetNLValues(cells[y][x].brain_nn)

  cells[y][x].testvar = dir

  if dir < 0 then return end

  local cx, cy = x, y
  if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 end
  if dir == 1 then cy = y - 1 elseif dir == 3 then cy = y + 1 end
  local fx, fy = x, y
  if dir == 0 then fx = x + 1 elseif dir == 2 then fx = x - 1 end
  if dir == 1 then fy = y + 1 elseif dir == 3 then fy = y - 1 end
  if cells[fy][fx].ctype == plantID then
    cells[fy][fx] = CopyTable(cells[y][x])
    MutateNN(cells[fy][fx].brain_nn)
    rotateCell(x, y, 2)
    if love.math.random(1, 100) <= 1 then
      cells[fy][fx].ctype = cancerbrainID
    end
  else
    PushCell(cx, cy, dir)
  end
end

function DoBrainCancer(x, y)
  local offs = {
    {x=1,y=0},
    {x=-1,y=0},
    {x=0,y=1},
    {x=0,y=-1},
  }
  for _, off in ipairs(offs) do
    local ox = x + off.x
    local oy = y + off.y
    if cells[oy][ox].ctype == brainID then
      cells[oy][ox].ctype = cancerbrainID
      cells[oy][ox].brain_nn = nil
    end
  end
end