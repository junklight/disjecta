

center_freq = 3.0
freq_spread = 0.1

function get_freq(n)
  return ( center_freq - (2 * freq_spread)) + ((n - 1)  * freq_spread)
end

function tap_mysteron()
	ii.ansible.trigger_pulse(4)
	output[4]( to(4,5.0),to(0,5.0) )
end

function tap_dpo()
	l = math.random() * 15.0
	output[3]( to(6,l),to(0,l) )
end

function tap_sinc()
	l = math.random() * 15.0
	output[2]( to(6,l),to(0,l) )
end

function tap_sto()
	l = math.random() * 15.0
	output[1]( to(6,l),to(0,l) )
end

actions = { 
				tap_sinc,
				tap_sto,
				tap_dpo,
				tap_mysteron
}


local chan = 1


function query_txi()
  chan = 1
  for i=1,4 do ii.txi.get('param', i) end
end

local knobs = {0,0,0,0}
ii.txi.event = function( event, data, device_index )
  if event == 'param' then
    knobs[chan] = data
    chan = chan + 1
  end
end

function init()
	input[1]{ 
			mode = 'stream',
			time = 0.2 }
	input[1].stream = function(v) center_freq = v end 
	input[2]{ 
			mode = 'stream',
			time = 0.2 }
	input[2].stream = function(v) 
					freq_spread = v/10.0 
	end 
  metro[1].event = function() 
					n = math.floor((knobs[1]/10.0) * 3.5) + 1
					print("running",n)
					for idx = 1,n do
							if not output[idx].running then
									actions[idx]()
							end
					end
	end
	metro[1].time = 1.0
	metro[1]:start()
  metro[2].event = function() 
					query_txi()
					for idx = 1,4 do
						v = get_freq(idx)
						ii.ansible.cv(idx, v)
					end
	end
	metro[2].time = 0.1
	metro[2]:start()
end
