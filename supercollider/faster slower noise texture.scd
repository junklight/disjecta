

r = p.record(\out, "/Users/markwilliamson/Desktop/proxySpace.aiff");
r.unpause;
r.close;


// setup of proxies
(
Ndef(\controlenv).kr;   // control
Ndef(\reverb).ar;
Ndef(\reverb).play;   // reverb
Ndef(\rotating_noise).ar;  // signal
Ndef(\rotating_noise_signal).ar;  //signal
Ndef(\rotating_noise_signal).fadeTime = 3.0;
Ndef(\rotating_noise).fadeTime = 3.0;
Ndef(\controlenv).fadeTime = 3.0;
// reverb
Ndef(\reverb,  { GVerb.ar(Ndef(\rotating_noise) ,roomsize:40,revtime:5,damping:0.2,mul:0.3) } );
)

// rotating noise - options
Ndef(\rotating_noise_signal, { PinkNoise.ar(); });
Ndef(\rotating_noise_signal, { SinOsc.ar(60 ) + PinkNoise.ar(); });
Ndef(\controlenv , {EnvGen.kr( Env.new( [5, 15 , 5,15],[3,5,1.5] , 'exp' , 2, 0))});
Ndef(\controlenv, {EnvGen.kr( Env.new( [5, 15 , 1,30],[3,15,18] , 'exp' , 2, 0))});
Ndef(\controlenv, { 5 });

// rotating noise speeding up and slowing down
// also with pitch
(
Ndef(\rotating_noise_signal , { SinOsc.ar(60,mul:0.5) + PinkNoise.ar(); });
Ndef(\controlenv , {EnvGen.kr( Env.new( [5, 7 , 5,7],[3,5,1.5] , 'exp' , 2, 0))});
);

// basic rotating noise
(
Ndef(\rotating_noise_signal , { PinkNoise.ar(); });
Ndef(\controlenv ,  { 1 } );
);

// rotating noise
(
Ndef(\rotating_noise ,  {
    var trig = EnvGen.kr(
        Env.new([ 0.001, 1, 0.5, 0 ], [ 0.01, 0.3, 0.1 ], -4, 2, nil),
			        Impulse.kr( Ndef(\controlenv) ) );
	var flt = BMoog.ar( Ndef(\rotating_noise_signal) , 300 + (Ndef(\controlenv) * 500 )  );
	var panenv = EnvGen.kr( Env.new( [-1,1 , -1,1],[3,5,1.5] , 'exp' , 2, 0));
	var sig = trig * flt;
	var panout = Pan2.ar(sig,SinOsc.kr( 0.1));
	panout;
});
);

Ndef(\rotating_noise).release;




