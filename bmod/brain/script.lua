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
local function Neuron(maxpointer)
  return {
    value = 0,
    pointer = randint(1, maxpointer),
    type = randint(0, 4),
    weight = love.math.random(),
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

local function ResetNLValues(nn)
  for _, layer in ipairs(nn) do
    for _, neuron in ipairs(layer) do
      neuron.value = 0
    end
  end
end

local function ExecuteNeuralNetwork(nn, inputs)
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

  local dir = math.floor(ExecuteNeuralNetwork(cells[y][x].brain_nn, inputs)) % 4
  ResetNLValues(cells[y][x].brain_nn)

  cells[y][x].testvar = dir

  local cx, cy = x, y
  if dir == 0 then cx = x - 1 elseif dir == 2 then cx = x + 1 end
  if dir == 0 then cy = y - 1 elseif dir == 2 then cy = y + 1 end
  if cells[cy][cx].ctype == plantID then
    cells[cy][cx] = CopyTable(cells[y][x])
  else
    PushCell(x, y, dir)
  end
end