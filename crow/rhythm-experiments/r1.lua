--- Rhythm ONE
-- experimenting with generative rhythm

local tick = 0
local p = { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 }
local probs = { 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 }
local chunksize = {  4 , 8 }

--  grab params 

param = 1
amta = 0 
amtb = 0 

ii.txi.event = function(e,data)
	if e == 'param' then 
			if param == 1 then
				amta = data
			elseif param == 2 then 
				amtb = data
		  end
	end
end

function updateevent()
		if param == 1 then param = 2 else param = 1 end
	  ii.txi.get('param',param)
end

local ticker = metro.init{ event = pulse , time = 0.25 , count = -1 }


-- pattern stuff 

function make_pattern() 
		local size = chunksize[math.random(#chunksize)] 
		local idx = 1
		local cidx = 0
		local copy = false 
		for idx = 1,16 do 
			if not copy then 
				 p[idx] = math.random(2) - 1
				 if idx == size then 
						copy = true
				 end
			else
				p[idx] = p[cidx + 1] 
				cidx = (cidx + 1 ) % size 
		  end 
		end
		for idx = 1,15 do 
			print(idx,p[idx] )
		end
end


function init()
		input[1].mode('none')
		input[2].mode('none')
		make_pattern()
	  tick = 0
		ticker.event = pulse
		ticker.time = 0.25
		ticker:start()
		metro[2].event = updateevent
		metro[2].time = 0.001
		metro[2]:start()
end

local on = false

local pfuns = { 
    [0] = function(tick)  
						outv = 5
						if tick == 1 then 
								outv = 8
						elseif tick % 4 == 0 then 
								outv = 6
						end
						if not on then
										if tick % 8 == 0 then
														dtime = math.random() * 8.0
														ii.ansible.cv(3,dtime)
														on = true
									 end
				    else 
								    ii.ansible.cv(3,0)
										on = false
				    end 
						v = (math.random() * 10.0) - 5.0
						ii.ansible.cv(1,v)
						d = math.random()*0.2
						d2 = math.random()*0.1
						output[2]{ to(outv,0),to(0,d) }
						output[1]{ to(1,0),to(0,d2) }
		 end,
		[1] =  function(tick) 
						outv = 5
						if tick == 1 then 
								outv = 8
						elseif tick % 4 == 0 then 
								outv = 6
						end
						v = (math.random() * 10.0) - 5.0
						ii.ansible.cv(2,v)
						d = math.random()*0.2
						d2 = math.random()*0.1
						output[4]{ to(outv,0),to(0,d) }
						output[3]{ to(1,0),to(0,d2) }
		 end,
		[2] = function(tick)  end 
}

function pulse() 
    tick = (tick + 1) % 16
		if tick  % 4 ==  0 then 
			 ii.ansible.trigger_pulse(1)
			 ii.ansible.trigger_pulse(2)
		end
		if tick % 2 == 0 then
				ii.ansible.trigger_pulse(3)
		end
		ntime = 0.24 + ((input[2].volts/10.0) * 0.5)
		ticker.time = ntime 
		print("time ",ntime," 1 ",input[1].volts/10.0)
		idx = tick + 1 
		if math.random() < (input[1].volts/10.0) then
			pfuns[p[idx]](idx)
		end
end


