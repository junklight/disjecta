
Ndef(\osc).ar;
Ndef(\lfo1).kr;
(
Ndef(\osc , {
	var osc = Pulse.ar( 120 , Ndef(\lfo1) , mul: 0.1);
	var flt = RLPF.ar(osc,480 , 0.7);
	flt;
} );
);

Ndef(\lfo1,{ 0.7; });
Ndef(\lfo1,{ Pulse.kr( 0.2 , add:0.1 , mul: 0.4) + Saw.kr(0.93 , add: 0.1 , mul: 0.7 ); });

Ndef(\osc).play;



{ RLPF.ar(Pulse.ar([100, 120], 0.5, 0.1), XLine.kr(3000, 400, 5), 0.05) }.play;


(
{ var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  MembraneHexagon.ar(excitation, tension, loss);
}.play;
)

(
{ var excitation = EnvGen.kr(Env.perc(0.01,3),
                             timeScale: 0.1, doneAction: 2
                            ) * PinkNoise.ar(0.4);
var tension = 0.037;
var loss=0.999;
  MembraneHexagon.ar(excitation, tension, loss);
}.play;
)

(
{ var excitation = EnvGen.kr(Env.perc(0.01,3),
                             timeScale: 0.1, doneAction: 2
                            ) * PinkNoise.ar(0.4);
var tension = 0.045;
var loss=0.999;
  MembraneHexagon.ar(excitation, tension, loss);
}.play;
)

(
SynthDef(\beat1,
	{ | gate = 1 , tension=0.037 , d = 3 |
		var excitation = EnvGen.kr(Env.perc(0.01,d), gate,
                             timeScale: 0.1, doneAction: 2
                            ) * PinkNoise.ar(0.4);
		 var loss=0.999;
		var o = MembraneHexagon.ar(excitation, tension, loss);
		Out.ar(0,o) * 0.1;
}).add;
)

(
Pbind( \instrument,\beat1,
	\dur,Pseq([Prand(#[0.1,0.3],1),0.2],20),
	\tension,Prand(#[0.037,0.025,0.032],inf),
).play;
)

(
Pbind( \instrument,\beat1,
	\dur,Pseq([Prand([rrand(0.05,0.2),rrand(0.1,0.5)],1),rrand(0.1,0.3)],20),
	\tension,Prand(#[0.037,0.025,0.032],inf),
	\d,Prand(#[2,3],inf),
).play;
)

(
a = Pbind( \instrument,\beat1,
	\dur,Pseq(#[0.14],inf),
	\degree,Pseq(#[1,rest,1,rest,rest,1,1,rest,rest,rest,rest,1,rest,1,rest,1],inf),
	\tension,Prand(#[0.037,0.032],inf),
);

b = Pbind( \instrument,\beat1,
	\dur,Pseq(#[0.14],inf),
	\degree,Pseq(#[1,rest,rest,rest,1,rest,rest,rest,1,rest,rest,rest,1,rest,rest,rest],inf),
	\tension,0.025,
);
Ppar([a,b],inf).play;
)

(
MIDIClient.init;

);

var mport = MIDIOut.newByName("IAC Driver", "Bus 1");

mport;

var ttt = "hello";

(
var mport = MIDIOut.newByName("IAC Driver", "Bus 1");
var clk = TempoClock.new(70/60);
a = Pbind(
	\type,\midi,
	\midicmd,\noteOn,
	\midiout, mport,
	\chan,1,
	\sustain,Prand(#[1.9,2,2.1],inf),
	\delta,Pseq([0.25,3/8,1/8,5/8,Pxrand([2/8,2/8,1/8],3),0.25],inf),
	\degree,Prand(#[1,1,4,1,3],inf) - 12 ,
	\amp,Pseq(#[1,0.8,0.8,0.8],inf),
);
a.play(clk);
)

(
var mport = MIDIOut.newByName("IAC Driver", "Bus 1");
var clk = TempoClock.new(30/60);
a = Pbind(
	\type,\midi,
	\midicmd,\noteOn,
	\midiout, mport,
	\chan,1,
	\sustain,Prand(#[1.9,2,3.1],inf),
	\delta,Pseq([0.25,5/8,1/8,5/8,Pxrand([2/8,5/8,1/8,1],3),0.25],inf),
	\degree,Prand([ Prand(#[1,1,4,1,3,7,9],24) -6 , Prand(#[1,1,4,1,3,7,9],24) -10],inf),
	\amp,Pseq(#[1,0.8,0.8,0.8],inf),
);
b = Pbind(
	\type,\midi,
	\midicmd,\noteOn,
	\midiout, mport,
	\chan,2,
	\delta,Pseq([7/8,Prand([7/8,3/8,5/8],6)],inf),
	\midinote,36,
	\amp,Pseq(#[1,0.8,0.8,0.8],inf),
);
c = Pbind(
	\type,\midi,
	\midicmd,\noteOn,
	\midiout, mport,
	\chan,2,
	\delta,Pseq( [ Prand([2/8,1/8,1/8],24) , Prand([1/16,1/8],8) ,Prand([2/8,1/8,1/8],24) , Prand([1/16,1/8, 1/32],8) ] , inf),
	\midinote,42,
	\amp,Pseq([1,0.6,0.8,Prand([0.4,0.5,0.6],2)],inf),
);
Ppar([a,b,c],inf).play(clk);
)






