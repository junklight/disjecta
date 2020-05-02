
s.boot;

s = Server.remote(\realtimepi, NetAddr("192.168.1.130", 57117));

(
SynthDef(\boop , { | freq=440 , index=1.0, strength = 0.1 , vol=1.0|
	var e = EnvGen.ar(Env.perc((1.0 - strength) * 1.0 ,0.8),doneAction:2);
	var mod = SinOsc.ar(
		freq * 0.3,
		0,
		freq * index * LFNoise1.kr(5.reciprocal).abs
	);

	var car = SinOsc.ar(
		(freq * 0.3) + mod,
		0
	);
	var p = Pan2.ar(car * vol,Rand(-1.0,1.0));
	Out.ar(
		0,
		p
	)
}).send(s);
)

(
var nrows = 10;
var ncols = 14;
var col_notes = [ 50,52,53,55,57,58,60,62,64,65,67,69,70,72,74 ];
var spots = Array.fill(ncols + 1,{ arg i; nil});
var getX = { | xys |
	var x =  (xys[0] * ncols).floor;
	x };
var last = nil;
MultiTouchPad.stop;
MultiTouchPad.start;
MultiTouchPad.untouchAction = { |curID, xys| };
MultiTouchPad.setAction = { |curID, xys| };
MultiTouchPad.touchAction = { |curID, xys|
	var gridloc = getX.value(xys);
	if (spots[gridloc].notNil ) {
		var t = Main.elapsedTime - spots[gridloc];
		spots[gridloc] = Main.elapsedTime;
		"second touch: ".post; col_notes[gridloc].midinote.post; " ".post;
		gridloc.post; " ".post; xys[2].post; " ".post; t.postln;
		r = Routine({
			30.do({
				var vol = 1;
				if (100.rand < 80 ) {
					Synth(\boop,[\freq,col_notes[gridloc].midicps * 2 ,
						         \ratio, xys[1] * 24.0 ,
						         \strength, xys[2],
						         \vol,vol
				], s); };
				vol = vol * 0.9;
				t.wait;
			});
		}).play;
	} {
		"first touch ".post; col_notes[gridloc].midinote.post; " ".post; gridloc.postln;
		spots[gridloc] = Main.elapsedTime;
		if (last != gridloc ) {
			if (last.notNil ) {
				spots[last] = nil;
			}
		};
		last = gridloc;
		Synth(\boop,[\freq,col_notes[gridloc].midicps * 2,
			         \ratio, xys[1] * 24.0 ,
			         \strength, xys[2]],s);
	}
};
)

