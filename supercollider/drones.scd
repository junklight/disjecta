

// setting up proxies
(
Ndef(\machine).ar;
Ndef(\machine).fadeTime = 5.0;
Ndef(\droneverb).ar;
Ndef(\droneverb).play;
Ndef(\droneverb , { GVerb.ar(Ndef(\machine),roomsize:40,revtime:5,damping:0.9 , mul: 0.5) } );
Ndef(\drone).ar;
Ndef(\drone).fadeTime = 5.0;
Ndef(\drone).play;
Ndef(\otherverb).ar;
Ndef(\otherverb, {GVerb.ar(Ndef(\drone),roomsize:20,revtime:5,damping:0.9 , mul: 0.5) });
Ndef(\otherverb).play;
Ndef(\sineDrone).ar;
Ndef(\sineDrone).play;
Ndef(\pulseDrone).ar;
Ndef(\pulseDrone).play;
Ndef(\sineDroneverb).ar;
Ndef(\sineDroneverb).play;
Ndef(\sineDroneverb , { GVerb.ar(Ndef(\pulseDrone),roomsize:40,revtime:5,damping:0.9 , mul: 0.5) });
);


(
Ndef(\machine, {
	var freq="c1".namecps;
	var x = Mix.ar( [
		Pulse.ar(freq),
		SinOsc.ar( freq , SinOsc.ar(500) , mul: 0.7) ,
		SinOsc.ar( freq /2 , SinOsc.ar(100) , mul: 0.3);]);
	var flt = Friction.ar( x * 0.7 , friction: 0.002, mass: 2.05501 , mul: 0.4  );
	flt * 0.2;
});
)
Ndef(\machine).play;
Ndef(\machine).release;

Ndef(\drone).play;
Ndef(\drone_env).fadeTime = 3.0;
Ndef(\drone_env, { EnvGen.kr(Env.new([50,110,150,130,110],[0.1,0.6,0.4,0.5,0.4],'exp',3,0)) });
Ndef(\drone_env, { 110; });
Ndef(\drone_env, { LFBrownNoise1.kr(0.04,mul: 30 , add: 120); });
(
Ndef(\drone, {
	var osc = [
//		LFTri.ar( LFBrownNoise0.ar(0.1 , mul: 5 , add: 100)),
		SinOsc.ar( LFBrownNoise0.ar(0.03 , mul: 5 , add: 60) ) ,
//		Saw.ar( LFBrownNoise0.ar(0.3 , mul: 5 , add: 65) ) ,
		Saw.ar( LFBrownNoise0.ar(0.01 , mul: 15 , add: 160)),
		Pulse.ar(LFBrownNoise0.ar(1 , mul: 3 , add: 120)) ,
		Pulse.ar(LFBrownNoise0.ar(0.02 , mul: 5 , add: 160))];
	var cmb  = Mix.ar(CombC.ar( osc, 0.01, 0.0005, 0.4));
	var env =Ndef(\drone_env) ;
	var flt = BMoog.ar(cmb,env,0.6);
	var pan = Pan2.ar(flt,LFNoise2.ar(0.1,mul:2,add: -1));
	pan * 0.2;
});
);

(
Ndef(\drone, {
	arg freq=100;
	var osc = [
		WhiteNoise.ar(),
		SinOsc.ar( LFBrownNoise0.ar(0.03 , mul: 5 , add: freq) ) ,
		SinOsc.ar( LFBrownNoise0.ar(0.01 , mul: 5 , add: freq + 10)),
//		SinOsc.ar(LFBrownNoise0.ar(0.2 , mul: 3 , add: freq)) ,
		SinOsc.ar(LFBrownNoise0.ar(0.02 , mul: 5 , add:freq))];
	var cmb  = Mix.ar(osc);
	var env =Ndef(\drone_env );
	var flt = BMoog.ar(cmb,env,1.6);
	var fld = Fold.ar( flt,0.0,1);
	var pan = Pan2.ar(flt,LFNoise2.ar(0.1,mul:2,add: -1));
	pan * 0.1;
});
);
Ndef(\drone).release;


Ndef(\drone).set(\freq,80);
Ndef(\sineDrone_cutoff).fadeTime = 3.0;
Ndef(\sineDrone_cutoff, { LFBrownNoise1.kr(0.1,mul: 30 , add: 120); });
Ndef(\sineDrone_cutoff, { "a3".namecps });


(
Ndef(\sineDrone, {
	var src = Mix.ar( [
		WhiteNoise.ar() * 0.3,
		SinOsc.ar("d1".namecps)
		//,		Saw.ar("g1".namecps + 0.2)
	]);
	var flt = BMoog.ar(src,Ndef(\sineDrone_cutoff),0.3) ;
	var pan = Pan2.ar(flt,0);
	pan * 0.2;
});
);
Ndef(\sineDrone).play;
Ndef(\sineDrone).fadeTime = 10.0;
Ndef(\sineDrone).release;

(
Ndef(\pulseDrone, {
	var src = Mix.ar( [
		Pulse.ar( "g2".namecps , SinOsc.kr(0.1,0.1)),
		Pulse.ar( "g1".namecps , Saw.kr(0.3,0.6))
	]);
	var flt = BMoog.ar(src,Ndef(\sineDrone_cutoff),0.4);
	var pan = Pan2.ar(flt,LFNoise2.ar(0.01,mul:2,add: -1));
	pan * 0.1;
});
);
Ndef(\pulseDrone).play;
Ndef(\pulseDrone).fadeTime = 3.0;
Ndef(\pulseDrone).release;




