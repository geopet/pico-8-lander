pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  g=0.025         -- gravity
  make_player()
  make_stars()
end

function _update()
  move_player()
end

function _draw()
  cls()
  draw_stars()
  draw_player()
end

function make_player()
  p={}
  p.x=60                   -- position
  p.y=8
  p.dx=0                   -- movement
  p.dy=0
  p.sprite=1
  p.alive=true
  p.thrust=0.075
end

function make_stars()
  s={}
  s.rand=rndb(0,127)
end

function draw_player()
  spr(p.sprite,p.x,p.y)
end

function move_player()
  p.dy+=g                  -- add gravity

  thrust()

  p.x+=p.dx                -- actually move the player
  p.y+=p.dy

  stay_on_screen()
end

function thrust()
  -- add thrust to movement
  if (btn(0)) then
    p.dx-=p.thrust
  end

  if (btn(1)) then
    p.dx+=p.thrust
  end

  if (btn(2)) then
    p.dy-=p.thrust
  end

  -- thrust sound
  if (btn(0) or btn(1) or btn(2)) then
    sfx(0)
  end
end

function stay_on_screen()
  if (p.x<0) then          -- left side
    p.x=0
    p.dx=0
  end
  if (p.x>119) then        -- right side
    p.x=119
    p.dx=0
  end
  if (p.y<0) then          -- top side
    p.y=0
    p.dy=0
  end
end

function rndb(low,high)
  return flr(rnd(high-low+1)+low)
end

function draw_stars()
  srand(s.rand)
  for i=1,50 do
    pset(rndb(0,127),rndb(0,127),rndb(5,7))
  end
end

__gfx__
00000000006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066c76600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070066ccc7660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700066cccc660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000665555660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050550500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000660660660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000465000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
