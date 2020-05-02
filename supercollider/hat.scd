

(
a = {
	var env = EnvGen.kr(Env.perc(0.001,rrand(0.08,0.15)),doneAction:2);
	var sqs = Mix.new( LFPulse.ar( [205.3,369.6,522.7,800,540], rrand(0,1.0), 0 , 0.5) );
	var a1 = BPF.ar(sqs,9000,0.9);
	var a2 = BPF.ar(a1,7100,0.3);
	var a3 = RHPF.ar(a2,rrand(7800,8300),0.1);
	a3 * rrand(3.8,4.2) * env;
}.play
);

(
SynthDef(\closedHat, {
	| decay = 0.01 |
	var dc = (decay/100.0) * 1.0;
	var env = EnvGen.kr(Env.perc(0.001,decay   ),doneAction:2);
	var sqs = Mix.new( LFPulse.ar( [205.3,369.6,522.7,800,540], rrand(0,1.0), 0 , 0.5) );
	var a1 = BPF.ar(sqs,8000,0.9);
	var a2 = BPF.ar(a1,7100,0.3);
	var a3 = RHPF.ar(a2,Rand(8800,9300),0.1);
	Out.ar(0,a3 * Rand(2.5,3.0) * env);
}).add;
);


(
a = {
	var env = EnvGen.kr(Env.perc(0.001,0.4),doneAction:2);
	var a2 = PinkNoise.ar();
	var a3 = RLPF.ar(a2,200 * env ,0.001);
	a3  * 3 * env;
}.play
);


(
a = {
	var env = EnvGen.kr(Env.perc(0.001,0.02));
    var env2 = EnvGen.kr(Env.perc(0.001,0.07),doneAction:2);
	var a2 = PinkNoise.ar();
	var a3 = RLPF.ar(a2,6000 * env ,0.4);
	a3  * 4 * env2;
}.play
);

Synth(\closedHat);

//Use it.
(
Pbind(
	    \instrument, \closedHat,
	    \dur , Pseq( [0.2,0.5,0.3],inf),
	\decay, Pseq([0.1,0.5,0.1],inf),
).play;
)

