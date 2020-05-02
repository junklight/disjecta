s;

(
~treed = Buffer.read(s,"/Users/markwilliamson/Dropbox/supercollider/snow/tree drips 2.aiff");
~treedA = Buffer.read(s,"/Users/markwilliamson/Dropbox/supercollider/snow/tree drips.aiff");
~fastFeet = Buffer.read(s,"/Users/markwilliamson/Dropbox/supercollider/snow/fast feet.aiff");
~slowFeet = Buffer.read(s,"/Users/markwilliamson/Dropbox/supercollider/snow/slow feet - mono.aiff");
);

(
~snowbufs = Buffer.loadFolder(Server.local , "/Users/markwilliamson/Dropbox/supercollider/directions/" );
);

~snowbufs.size;
~snowbufs = [];

Platform.userExtensionDir;


(
x = SynthDef(\help_Buffer, { arg out = 0, bufnum;
    Out.ar( out,
        PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum),loop:0)
    )
}).add;
)

Synth(\help_Buffer,[out:0,bufnum: ~snowbufs[rrand(0,~snowbufs.size)]]);

x.free;

b.free;


(
a = {
	 var trate, dur;
	var buf = ~slowFeet;
    trate = MouseY.kr(2,120,1);
    dur = 1.2 / trate;
	    Out.ar(0,TGrains.ar(1, Impulse.ar(trate), buf, (1.2 ** WhiteNoise.kr(3).round(1)), MouseX.kr(0,BufDur.kr(buf)), dur, WhiteNoise.kr(0.6), 0.1) * 3);
}.play;
)

a.free;

{ var b = ~slowFeet; BufRd.ar(1, b, SinOsc.ar(0.05) * BufFrames.ir(b)) }.play;

~hamming = Buffer.sendCollection(s, Signal.hammingWindow(8192));

(
SynthDef(\fileGran,
	{
	|sndbuf, windowbuf, trans=1, beg=0, end=1024, loop=0, pan=0, amp=1|
	var dur = ( abs(end-beg) / BufSampleRate.kr(sndbuf) ) * trans;
	var file = BufRd.ar(1, sndbuf, Line.ar(beg, end, dur, doneAction: 2), loop, 4);
	var windowRate = (BufFrames.kr(windowbuf) / BufSampleRate.kr(windowbuf)) / dur;
	var windowEnd = BufFrames.kr(windowbuf);
	var window = BufRd.ar(1, windowbuf, Line.ar(0, windowEnd, dur, doneAction: 2), loop, 4 );
	var sound  = file*window*amp;
	var flt = BMoog.ar(sound,300,0.4);
	var thePan = Pan2.ar(flt, pan);
	Out.ar(0, thePan);
	}
).add;
);

(
SynthDef(\sGrain,
	{
		| windowbuf,beg = 0 , end = 1024 , amp = 1 , pan=0  , loop =0|
		var osc = SinOsc( rrand(100,500));
		//var dur = rrand( 10000,100000);
		var dur = 20000;
		var windowEnd = BufFrames.kr(windowbuf);
		var window = BufRd.ar(1, windowbuf, Line.ar(0, windowEnd, dur, doneAction: 2), loop, 4 );
		var sound  = osc*window*amp;
		var flt = BMoog.ar(sound,100,0.0);
		var thePan = Pan2.ar(flt, pan);
		Out.ar(0, thePan);
}).add;
);

~slowFeet.numFrames;
~hamming.numFrames;

8192/44100/20000;

/20000;

t.free;

(
Pbind(
	\instrument, \fileGran,
	\sndbuf, ~slowFeet, //sample buffer
	\windowbuf, ~hamming , //window buffer
	\delta, Pwhite(0.1, 0.5,inf), //time between grain beginnings
	\beg, Pwhite(0,1820345,inf), //beginning in frames
	\end, Pkey(\beg) + Pwhite(150000,200000,inf), //end in frames
	\pan, Pwhite(-1,1,inf),
	\trans, 0.01, //playback rate
	\amp,10,
).play;
)

[1..1820345];
range

~slowFeet.numChannels;


(1..10) ;

currentEnvironment.postln;


