(
SynthDef(\drum2 , { | gate = 1 , n = 50 , pit = 220|
	var e = EnvGen.kr(Env.perc(0,0.7), doneAction:2);
	var pev = EnvGen.kr(Env.perc(0,0.5), doneAction:2);
	var so = SinOsc.ar(500);
	var v =  VOSIM.ar(Impulse.ar(n), 100, n ,5);
	var f = Fold.ar( v * 0.3 , -0.1, 0.1);
	var p = Pan2.ar(v * 0.01 , 0.5 );
	Out.ar(0,p*e);
}).add;

)

Synth(\drum2,[\gate,1,\n,50, \pit,100]);


