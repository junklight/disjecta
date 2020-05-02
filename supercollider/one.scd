{ [SinOsc.ar(100, 0, 0.2), SinOsc.ar(90, 0, 0.2)] }.play;


{ DynKlank.ar(`[[200, SinOsc.kr(200,0,700,800), 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

b= { DynKlank.ar(`[[SinOsc.kr(0.10,0.3,50,200), 671, SinOsc.kr(0.01,0,700,800), SinOsc.kr(0.03,0,1000,1700)], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;
b.free;

b= { DynKlank.ar(`[[SinOsc.kr(0.10,0.3,50,200), 271, SinOsc.kr(0.01,0,300,100)], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;
b.free;



(
a = {
    var n;
    n = 8; // number of 'voices'
    Mix.ar( // mix all stereo pairs down.
        Pan2.ar( // pan the voice to a stereo position
            CombL.ar( // a comb filter used as a string resonator
                Dust.ar( // random impulses as an excitation function
                    // an array to cause expansion of Dust to n channels
                    // 1 means one impulse per second on average
                    1.dup(n),
                    0.3 // amplitude
				                ),
                0.01, // max delay time in seconds
                // array of different random lengths for each 'string'
                {0.004.rand+0.0003}.dup(n),
                4 // decay time in seconds
            ),
            {1.0.rand2}.dup(n) // give each voice a different pan position
        )
    )
};
)

b = a.play;
b.free;


(
var notes, on, off;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
    notes[num] = Synth(\default, [\freq, num.midicps,
        \amp, veloc * 0.00315]);
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
    notes[num].release;
});

q = { on.free; off.free; };
)

// when done:
q.value;

Quarks.gui;