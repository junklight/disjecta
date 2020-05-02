p = ProxySpace.new(s);    // create a new environment, store it in variable p for now.
p.push;            // push it, so i becomes the current environment.
currentEnvironment.postln;
currentEnvironment === p; // and they are identical.
p.clear;
p;
p.pop();
ProxySpace.pop();

~x;        // accessing creates a NodeProxy (uninitialized) automatically.
~x + ~y;    // this works immediately, because the lookup does not return nil,
        // but a placeholder (proxy) instead

p.postln;    // now there are two empty placeholders in the environment.


// as soon as a sound function (or any compatible input) is assigned to a proxy
// this sound plays on its own private bus (so it is not audible yet.)
(
~x = {
    RLPF.ar(Impulse.ar(4) * 20, [850, 950], 0.2)
}
)

// the proxy has been initialized by its first assignment.
// it plays at audio rate (because we have assigned an audio rate ugen function)
// and it has two channels (because the function has stereo output)

~x.index;    // a nodeproxy owns a private bus, so its signal can be used in diverse ways.
        // what is the proxy bus's index? this posts the index to the postwindow
        // before it was .ir(nil), now it is initialized to .ar(2)

~x.bus // what is the proxy's bus?


~x.play;    // now listen to it. a monitor is created (see Monitor) that plays the signal
        // onto a public bus - by default, this is bus 0, the first audio output bus.
        // This monitoring function is independent of the proxy itself.
        // for further info see: jitlib_basic_concepts_03 (part c)



// the sound function can be changed at any time:
(
~x = {
    RLPF.ar(Impulse.ar([5, 7]) * 5, [1450, 1234], 0.2)
}
)

// You can tune a sound function to your liking very easily
// by replacing it with little (or big) variations:

        // filter freqs higher:
~x = {    RLPF.ar(Impulse.ar([5, 7]) * 5, [1800, 2000], 0.2) }

        // same pulse ratio (5/8), different pulse tempo:
~x = {    RLPF.ar(Impulse.ar([5, 8] * 3.2) * 5, [1800, 2000], 0.2) }

        // different filter:
~x = {    Ringz.ar(Impulse.ar([5, 8] * 3.2), [1800, 2000], 0.05) }

// and if you set the proxy's fadeTime, you can create little
// textures by hand:

~x.fadeTime = 3;
        // different filter freqs every time:
~x = {    Ringz.ar(Impulse.ar([5, 8] * rrand(0.5, 1.5)) * 0.5, ({ exprand(200, 4000) } ! 2), 0.05) }



// here is another proxy:
~y = { Pan2.ar(Dust.ar(20), 0) };

~y.bus; // it has two channels, just as the ~x., but it plays on another (private) bus.

// note that ~y is not audible directly,
// but it can be used like a UGen in any other proxy:
(
~x = {
    RLPF.ar(~y.ar * 8, [1450, 1234], 0.2)
}
)

// when the proxy changes, the result changes dynamically:

~y = { Impulse.ar(MouseX.kr(2, 18, 1)) * [1, 1] };

~y = { PinkNoise.ar(MouseX.kr(0, 0.2) * [1, 1]) };

~y = { Impulse.ar([MouseX.kr(2, 18, 1), MouseY.kr(2, 18, 1)]) };



// stop listening. the proxies run in the background.

~x.stop;

~y.bus; // ~y is playing on a different bus ...
~x.bus; // than ~x.

// we can also listen to ~y directly:
~y.play;

// to remove a proxy source, nil can be used:

~y = nil;

// stop listening
~y.stop;



~z.play; ~y.ar;


// the initial slot (0) is used when assigning directly.
// ~y is still unused, we will add it later.

~z = (~y * pi).sin * 0.1 * { LFSaw.kr(LFNoise1.kr(0.3 ! 3).sum * -18).max(0.2) };


// other slot numbers are accessed by positive integers:

~y[1] = { Saw.ar([400, 401.3], 0.4) };
~y[0] = { Saw.ar([300, 301], 0.4) };



// to remove one of them, nil is used:

~y[0] = nil;

// what is to be found at index 1?
~y.objects[1] // a playing interface
~y.objects[1].source.postcs // the function that was put in.
~y.objects.postcs     // this returns objects in the slots.
~y.source.postcs    // this returns the function in slot 0 only.




~y.play;
~y.stop;
~y = { arg freq=500; SinOsc.ar(freq * [1, 1.1]) * 0.1 };
~y.set(\freq, 440);
~y.set(\freq, 600);
// unlike in synths, this context is kept and applied to every new synth:

~y = { arg freq=500; Formant.ar(50, freq * [1, 1.1], 70) * 0.1 };









