

(
SynthDef(\tideDrift , {
	| freq = 440 , gate=1, amp=0.5 , fltfreq = 450 |
	var oenv = EnvGen.kr(Env.perc(releaseTime: 2.0,curve:'lin') );
	var osc = [
		SinOsc.ar(freq/2),
		VarSaw.ar(freq,0,SinOsc.ar(0.01)) * oenv.range(0.5,1.0),
		VarSaw.ar(freq + 0.5,0,SinOsc.ar(0.01)),
		VarSaw.ar(freq * 2,0,SinOsc.ar(0.01)) * oenv.range(0.3,0.8)
	];
	var env = EnvGen.kr(Env.adsr(0.9,0.3,amp/2.0,1.0,peakLevel:amp,curve:'sqr'),gate,doneAction:2);
	var fenv = EnvGen.kr(
		Env.adsr(0.9,0.1,amp/2.0,1.0,peakLevel:amp,curve:'sqr'),gate ,
	);
	var penv = EnvGen.kr(Env.linen(0.1,0.1,5));
	var mx = Mix.ar( osc );
	var flt = BLowPass.ar( mx , fenv.range(freq - 10,freq+fltfreq) , 0.2);
	var pan = Pan2.ar(flt,penv.range(0.7,-0.7));
	Out.ar(0,pan * env);
}).add;
);

(
Pbind(
		\instrument,\tideDrift,
		\freq ,Pseq([
		Pshuf( [
			"c2".namecps ,  "d#2".namecps ,  "g2".namecps,
			"c3".namecps ,  "d#3".namecps ,  "f#3".namecps
		] , 1 ),
		Pshuf( [
			"f2".namecps ,  "ab2".namecps ,  "c2".namecps,
			"f3".namecps ,  "eb2".namecps ,  "c3".namecps
		] , 1 ),
		Pshuf( [
			"ab2".namecps ,  "c2".namecps ,  "eb2".namecps,
			"ab3".namecps ,  "g3".namecps ,  "eb3".namecps
		] , 1 ),
	],5),
	\fltfreq,Pseq([450,450,600,700,800,1000,150,50],inf),
		\dur, Pseq([5],inf),
	    \delta, Pseq([1,0.7,1.2,Rest(1)],inf),
        \amp,  Pseq([0.2],inf),
).play;
);






	