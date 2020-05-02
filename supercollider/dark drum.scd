s.boot;
s.reboot;
(
{ var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  MembraneCircle.ar(excitation, tension, loss);
}.play;
)

(
SynthDef(\drum , { | gate = 1.0 |
	var excitation = EnvGen.kr(Env.perc(0,Rand(0.4,0.5)),gate, doneAction: 0) * PinkNoise.ar(0.4);
	var tension = Rand(0.02,0.023);
	var loss = Rand(0.999,0.9999);
	var op = MembraneCircle.ar(excitation, tension, loss) * 0.2;
	DetectSilence.ar(op,doneAction:2.0);
	Out.ar(0,op);
}).add;
)


(
p = Pbind( *[
	instrument: \drum,
	dur: Prand([0.3,0.45,0.32],inf),

]);
p.play;


)