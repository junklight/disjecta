
(
SynthDef( \seq, {
	| freq = 120 , dur = 0.1,gate=1|
	var envB = EnvGen.kr(Env.asr(0.01,dur,0.7,1,\sqr),gate:gate,doneAction:2) ;
	var osc = Saw.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq) ,mul:0.02);
	var osc2 = SinOsc.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq + 5) ,mul:0.02);
	var f = BMoog.ar(osc + osc2,LFPar.kr( 0.41 , rrand(0,1) , add:  freq + 50   ),0.8,0,1.0,mul:5);
	var pan = Rand(-1.0,1.0);
	var sig = f * envB;
	Out.ar(0,Pan2.ar(sig,pan) ) ;
}).add;
);


Synth( \seq ,[\freq, 120,\dur,2 ]);


(
Pbind(
	\instrument,\seq,
	\degree,Pseq( [Pseq([1,4,1],3),Pseq([2,6,2],5)],3),
	\dur,Pseq([0.5,0.4,0.7],inf),
	\octave,4
).play;
);


(
SynthDef( \strings, {
	| freq = 120 ,gate=1,out=0|
	var envAmp = EnvGen.ar(Env.asr(2,1,3),gate:gate,doneAction:2) ;
	var osc = Saw.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq) ,mul:0.04);
	var osc2 = Saw.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq + 3) ,mul:0.04);
    var osc3 = Saw.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq - 4) ,mul:0.04);
	var f = BMoog.ar(osc + osc2 + osc3 ,LFPar.kr( 0.41 , rrand(0,1) , add: freq + 40   ) ,0.4,0,1.0,mul:5);
	var pan = Rand(-1.0,1.0);
	var sig = f * envAmp;
	Out.ar(out, sig) ;
}).add;
);

//Define piano synthdef and soundboard
(
SynthDef(\help_oteypianostring, { |out=0, freq=440,gate=1, amp=0.5,rho=1|
    var son = OteyPianoStrings.ar(freq, amp, rho:rho)*EnvGen.ar(Env.asr(0,1,0.1),gate,doneAction:2);
    Out.ar(out, Pan2.ar(son * 1, LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75)));
}).add;

SynthDef(\piano_soundboard,{
	var rev;
    var audio = In.ar([20, 21], 2);
    audio = OteySoundBoard.ar(audio);
    rev = FreeVerb.ar(audio,mix:0.5,room: 10,damp:0.2,mul:3);
    Out.ar(0,rev * 2.0);
}).add
)

//start soundboard effect
Synth.tail(1,\piano_soundboard);

//Use it.
(
Pbind(
    \instrument, \help_oteypianostring,
	\delta, Prand([1,0.5,3,7,10],inf),
	\dur, 1,
	\degree, Pshuf([1,3,5,7,8,12,15,21], inf),
    \out, 20,
).play;

a = Synth(\strings,[\freq,220,\dur,3]);
a.free;

(
Pbind(
	\instrument,\strings,
	\degree, Prand([[1,3,5],[2,4,6],[6,8,10],[5,7,9]],30),
	\ctranspose,0,
	\dur,Pseq([5,6],inf),
	\strum,0.5,
	\delta,Prand([2,4,5,10],inf),
	\out,20,
	\octave,Pseq([Pseq([4],4),Pseq([3],4)],inf)
).play;
);

