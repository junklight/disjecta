(
var winenv;
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\fm_grain_test, { |out, gate = 1, amp = 1, envbuf|
    var rate, env, freqdev;
    // use mouse x to control panning
    rate= MouseX.kr(1, 20);
    // use WhiteNoise and mouse y to control deviation from center pitch
    freqdev = WhiteNoise.kr(MouseY.kr(100, 200));
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
    Out.ar(out,
		        GrainFM.ar(2, Impulse.kr(rate), 10, 120 , freqdev, SinOsc.kr(0.1).range(1, 10),
            0, envbuf) * 0.1 * env)
}).add;

)

// use built-in env
x = Synth(\fm_grain_test, [\envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);