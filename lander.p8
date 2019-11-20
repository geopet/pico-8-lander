pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  game_over=false
  win=false
  g=0.025         -- gravity
  make_stars()
  make_ground()
  make_player()
end

function _update()
  if (not game_over) then
    move_player()
    check_land()
  end
end

function _draw()
  cls()
  draw_stars()
  draw_ground()
  draw_player()

  print("dx:"..p.dx,2,2,7)
  print("dy:"..p.dy,2,8,7)
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
  if (game_over and win) then
    spr(4,p.x,p.y-8)       -- flag
  elseif (game_over) then
    spr(5,p.x,p.y)         -- explosion
  end
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

function make_ground()
  -- create the ground
  gnd={}
  local top=96             -- highest point
  local btm=120            -- lowest point

  -- set up the landing pad
  pad={}
  pad.width=15
  pad.x=rndb(0,126-pad.width)
  pad.y=rndb(top,btm)
  pad.sprite=2

  -- create ground at pad
  for i=pad.x,pad.x+pad.width do
    gnd[i]=pad.y
  end

  -- create ground right of pad
  for i=pad.x+pad.width+1,127 do
    local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
    gnd[i]=mid(top,h,btm)
  end

  -- create ground left of pad
  for i=pad.x-1,0,-1 do
    local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
    gnd[i]=mid(top,h,btm)
  end
end

function draw_ground()
  for i=0,127 do
    line(i,gnd[i],i,127,5)
  end
  spr(pad.sprite,pad.x,pad.y,2,1)
end

function check_land()
  l_x=flr(p.x)             -- left side of lander
  r_x=flr(p.x+7)           -- right side of lander
  b_y=flr(p.y+7)           -- bottom of lander

  over_pad=l_x>=pad.x and r_x<=pad.x+pad.width
  on_pad=b_y>=pad.y-1
  slow=p.dy<1

  if (over_pad and on_pad and slow) then
    end_game(true)
  elseif (over_pad and on_pad) then
    end_game(false)
  else
    for i=l_x,r_x do
      if (gnd[i]<=b_y) then
        end_game(false)
      end
    end
  end
end

function end_game(won)
  game_over=true
  win=won

  if (win) then
    sfx(1)
  else
    sfx(2)
  end
end

__gfx__
000000000066660076edddddedddd766000000000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066c7660766666366ee66363000000000899998000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070066ccc766007636666e66360000000000899aa99800000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700066cccc6600088888e8888300000b600089aaaa9800000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700066555566000cce88ee8d330000bb600089aaaa9800000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000666666000000dce888000000bbb6000899aa99800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050550500000000cce300000000060000899998000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000660660660000000033300000000060000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000465000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
000c0000180701803013070130300e0700e0301a0701a03000000130701a0701a0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400003d670356602f65028640226401b6301663013630106200c62009620056200461001610006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
