

(
// read direction words into array of buffers (uses a self added extenstion)
~direction_words = Buffer.loadFolder(Server.local , "/Users/markwilliamson/Dropbox/supercollider/directions/" );
// simple buffer playback synthdef
SynthDef(\playBuffer, { arg out = 0, bufnum;
    Out.ar( out,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum),loop:0)
    )
}).add;
Ndef(\pb,\playBuffer);
// set up our proxy nodes and a reverb
Ndef(\wordp).ar;
Ndef(\wordp).fadeTime = 0;
Ndef(\wordp).play;
Ndef(\wordreverb, { GVerb.ar(Ndef(\pb) * 0.1,roomsize:10,revtime:5,damping:0.8,mul:0.3) });
Ndef(\wordreverb, { FreeVerb.ar(Ndef(\pb) * 0.1,room:1.0,mix:0.3,damp:0.2,mul:0.5) });
Ndef(\wordreverb).play;
);

// playing random words
(
Tdef(\wordplay , {
	inf.do {
		Ndef(\pb).spawn([\bufnum:~direction_words[rrand(0,~direction_words.size)]]);
	[3,6].choose.wait;
	}
});
);

Tdef(\wordplay).play;
Tdef(\wordplay).stop;

(
// release - only fade out at release time
Ndef(\wordp).fadeTime = 3.0;
Ndef(\wordp).release;
);

[3,6].choose;

