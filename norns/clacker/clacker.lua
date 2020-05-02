-- Clacker - Relabi based explorations 

engine.name = 'gtr'

local MusicUtil = require "musicutil"
local esea = require 'gtr/lib/esea'

local g = grid.connect()
local mdi = midi.connect (1)

local screen_framerate = 15
local screen_refresh_metro

local dt = 0.001
local semitone = 1/12
local oct = {}
for idx = 1,12 do 
	oct[idx] = semitone * ( idx - 1)
end

function cv_note(ove,semi)
			if semi < 1 then
					ove = ove - 1
					semi = 13 - semi
			end
			return ove + oct[semi]
end

local thing = {}
thing.phase = { a=0, b=0, c=0 }
thing.freqs = { a=7 , b=0.2, c=1 }
thing.amt = {a = 0.2 ,b=0.1,c=0.1 }
thing.out = {a=0,b=0,c=0}
local amt = 0.1
local probability = 0.5

function thing:process()
	self.phase.a = self.phase.a + dt * self.freqs.a + amt * self.out.c
  if self.phase.a > twopi then 
		self.phase.a = 0
	end
	self.out.a = math.sin(self.phase.a)
	self.phase.b = self.phase.b + dt * self.freqs.b + amt * self.out.a
  if self.phase.b > twopi then 
		self.phase.b = 0
	end
	self.out.b = math.sin(self.phase.b)
	self.phase.c = self.phase.c + dt * self.freqs.c + amt * self.out.b
  if self.phase.c > twopi then 
		self.phase.c = 0
	end
	self.out.c = math.sin(self.phase.c)
end

function thing:start()
	self.metro:start()
end

function thing:stop()
	self.metro:stop()
end

function thing:reset()
				print('reset')
end

thing.metro = metro.init{event = function(c) thing:process() end, count = -1, time = dt}

local cnt = 0
local latch = 0
local notes = { }
for x = 1,12 do 
  notes[x] = 0
end  
local clockdivs = {} 
for x = 1,4 do 
  clockdivs[x] = 1
end

function getrandomnote()
  f = {} 
  for x = 1,12 do 
    if notes[x] == 1 then
      table.insert(f,x)
    end
  end
  if #f > 0 then 
    return f[math.random(1,#f)]
  else
    return -1
  end
end

local param = 0
local decay = { 1, 1}

clockevent = function(c)
		-- do outputs 
		if latch == 0 and thing.out.a > 0.9  then 
		    if math.random() < probability then 
				  step()
				end
				latch = 1
				cnt = 0
		elseif latch == 1 and thing.out.a < 0.89 then
				latch = 0
				cnt = cnt + 1
		end
end
clockMetro = metro.init{event = clockevent, count = -1, time = 0.001}

function uiupdate()
  gridredraw()
end


uimetro = metro.init{event = uiupdate, count = -1, time=1/15}

local cur_note = { -1, -1 }
local stepcnt = 0
local nchan = {2,4}
local echan = {1,3}

function step()
  stepcnt = stepcnt + 1
  for con = 1,2 do
    x = getrandomnote()
    if x ~= -1 then
      if clockdivs[con] > 1 and stepcnt % (clockdivs[con] - 1 ) == 0 then 
        m = cv_note(0, x )
        crow.output[nchan[con]].action="{ to(" .. m .. ") }"
      	crow.output[nchan[con]]()
      	crow.output[echan[con]].action="{ to(5),to(0," .. ( decay[con] / 8 ) * 2.0 .. ") } "
      	crow.output[echan[con]]()
      end
    end
  end
  for moff = 1,2 do 
    if cur_note[moff] ~= -1 then 
    	  mdi:note_off(cur_note[moff],0,moff)
    	  cur_note[moff] = -1
    end
  end
  for mon = 1,2 do 
    x = getrandomnote()
    if x ~= -1 then
    	mnote = 59 +  x
    	if clockdivs[2 + mon] > 1 and stepcnt % (clockdivs[2 + mon] - 1 ) == 0 then 
    	  cur_note[mon] = mnote 
    	  mdi:note_on(mnote,math.random(60,100),mon)
    	end
    end
  end
end


twopi = math.pi * 2.0

function init()
  -- cs_VOLUME = controlspec.new(0,1,'lin',0,0.2,'')
  -- params:add{type="control",id="volume",controlspec=cs_VOLUME,
  --   action=function(x) worlds[current_world].volume(x) end}
  params:add_number("probability","probability",0,100,50)
  params:set_action("probability", function(x) probability = x/100 end)
  params:add_number("amt","amt",0,100,10)
  params:set_action("amt" ,function(x) amt = 0.3 * (x/100) end) 
  params:bang()
  print("here")
  -- crow.input[1].mode('change', 1,0.1,'rising')
	thing:start()
	clockMetro:start()
	uimetro:start()
	-- notesmetro:start()
	print('test loaded')
end

function g.key(x, y, z)
  print("key",x,y,z)
  if y == 1 and x < 13 and z == 1 then 
    if notes[x] == 1 then
      notes[x] = 0
    else 
      notes[x] = 1
    end
  end
  if y >= 4 and x <= 10 and z == 1 then 
    clk = y - 3
    clockdivs[clk] = x
  end
  if x >= 14 and x <= 15 and z == 1 then 
    decay[x - 13] = y
  end
end

function gridredraw()
  for x = 1,12 do
    if notes[x] == 1 then
      g:led(x,1,10)
    else 
      g:led(x,1,2)
    end
  end
  for y = 4,7 do 
    for x = 1,10 do
      if clockdivs[y - 3] == x then 
        g:led(x,y,10)
      else 
        g:led(x,y,2)
      end
    end  
  end
  for y = 1,8 do 
    for x = 1,2 do 
      if decay[x] == y then 
        g:led(13 + x,y,10)
      else
        g:led(13 + x,y,2)
      end
    end
  end
  g:refresh()
end

function enc(n,delta)
  if n == 1 then
    mix:delta("output", delta)
  elseif n == 2 then 
    params:delta( "probability" , delta)
    redraw()
  elseif n == 3 then 
    params:delta( "amt" , delta)
    redraw()
  end
end

function key(n,z)
  
end

function redraw()
  screen.clear()
  screen.aa(0)
  screen.line_width(1)
	screen.move(45,30)
  screen.text("clacker")
  screen.move(15,45)
  screen.text("probability: " .. params:get("probability") .. " amt: " .. params:get("amt") )
  screen.update()
end







function cleanup()
	print("Done")
end
