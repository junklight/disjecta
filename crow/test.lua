dt = 0.001
semitone = 1/12
oct = {}
for idx = 1,12 do 
	oct[idx] = semitone * ( idx - 1)
end

function note(ove,semi)
			if semi < 1 then
					ove = ove - 1
					semi = 13 - semi
			end
			return ove + oct[semi]
end

thing = {}
thing.phase = { a=0, b=0, c=0 }
thing.freqs = { a=7 , b=0.2, c=1 }
thing.amt = {a = 0.2 ,b=0.1,c=0.1 }
thing.out = {a=0,b=0,c=0}
amt = 0.1

twopi = math.pi * 2.0

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
local notes = { 1, 4,6 }
local param = 0
local decay = 0.1

updateEvent = function(c)
		param = 1
	  ii.txi.get('param',1)
		param = 2
	  ii.txi.get('param',2)
		-- do outputs 
		if latch == 0 and thing.out.a > 0.9  then 
				m = note(0, notes[math.random(1,3)])
				output[2]{ to( m + semitone),to(m,0.1) }
				output[1]{ to(5),to(0,decay) } 
				latch = 1
				cnt = 0
		elseif latch == 1 and thing.out.a < 0.89 then
				latch = 0
				cnt = cnt + 1
		end
end

ii.txi.event = function(e,data)
	if e == 'param' then 
			if param == 1 then
				if data > 0 then
					amt = 0.3/data
				 end
			elseif param == 2 then 
			  if data > 0 then 
          decay = (data/10) * 2.0  
				end 
		  end
	end
end

AttractorsMetro = metro.init{event = updateEvent, count = -1, time =0.001}

function init()
	input[1].mode('change', 1,0.1,'rising')
	thing:start()
	AttractorsMetro:start()
	-- notesmetro:start()
	print('test loaded')
end
