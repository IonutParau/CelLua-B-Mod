Fireballs = {}

local FireballToFire = {}

function AddFireBalls()
  Fireballs.smol = addCell("BM fireball", "bmod/fireball/textures/normal.png", Options.mover)
  Fireballs.stronk = addCell("BM fireball-stronk", "bmod/fireball/textures/strong.png", Options.mover)
  Fireballs.stronker = addCell("BM fireball-stronker", "bmod/fireball/textures/stronger.png", Options.mover)
  Fireballs.stronkest = addCell("BM fireball-stronkest", "bmod/fireball/textures/strongest.png", Options.mover)

  FireballToFire[Fireballs.smol] = fireID
  FireballToFire[Fireballs.stronk] = strongfireID
  FireballToFire[Fireballs.stronker] = strongerfireID
  FireballToFire[Fireballs.stronkest] = strongestfireID

  BMod.bindUpdate(Fireballs.smol, DoFireBall)
  BMod.bindUpdate(Fireballs.stronk, DoFireBall)
  BMod.bindUpdate(Fireballs.stronker, DoFireBall)
  BMod.bindUpdate(Fireballs.stronkest, DoFireBall)
end

function DoFireBall(x, y, dir)
  local fx, fy = x, y

  if dir == 0 then fx = x + 1 elseif dir == 2 then fx = x - 1 end
  if dir == 1 then fy = y + 1 elseif dir == 3 then fy = y - 1 end

  if cells[fy][fx].ctype == 0 then
    DoMover(x, y, dir)
  else
    cells[y][x].ctype = FireballToFire[cells[y][x].ctype]
    DoModded(x, y, dir)
  end
end