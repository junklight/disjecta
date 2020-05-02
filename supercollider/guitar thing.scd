DWGPlucked2


(
SynthDef(\gtrthing, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked.ar(freq, amp, gate,0.1,1,c3,inp);
	var reson = Klank.ar(`[[92.5, 180], nil, [0.8, 0.5]], son);
    DetectSilence.ar(son + reson, 0.001, doneAction:2);
	Out.ar(out, Pan2.ar((son + reson) * 0.1, pan));
}).add;
)

//Use it.
(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

Pbind(
    \instrument, \gtrthing,
    \scale ,Scale.minor,
    \delta , Prand([1,2]*0.15,inf),
    \dur , 2,
    \degree, Prand([1,3,5,7,9] * -2.0,inf),
    \amp , Pwhite(0.2,0.8),
    \c3 , Prand([90],inf),
    \pan , Pwhite(-1,1),
).play;
)