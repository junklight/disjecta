


(
SynthDef( \seq, {
	| freq = 120 , dur = 0.1|
	var envA = EnvGen.kr(Env([1.0,0.1,1.0],[0.1,0.08,0.1],\sqr));
	var envB = EnvGen.kr(Env([0.1,1,0.1],[0.001,dur * 0.9, 0.2  ]),doneAction:2) ;
	var osc = SinOsc.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq) ,mul:0.02);
	var f = RLPF.ar(osc,LFPar.kr( 0.41 , rrand(0,1) , add:  envB * freq * 10 *  In.kr(~lc9 )  ),envA,mul:9);
	var pan = Rand(-1.0,1.0);
	var sig = f * envB;
	Out.ar(~delayBus,Pan2.ar(sig,pan) ) ;
    //Out.ar(~delayBus,f*envB);
}).add;

SynthDef( \seqb, {
	| freq = 120 , dur = 0.1|
	var envA = EnvGen.kr(Env([1.0,0.1,1.0],[0.1,0.08,0.1],\sqr));
	var envB = EnvGen.kr(Env([0.1,1,0.1],[0.001,dur * 0.9, 0.2  ]),doneAction:2) ;
	var osc = SinOsc.ar(LFPar.kr( 0.35 , rrand(0,1) , add:    freq) ,mul:0.02);
	var f = RLPF.ar(osc,LFPar.kr( 0.41 , rrand(0,1) , add:  envB * freq * 10 *  In.kr(~lc10 )  ),envA,mul:9);
	var pan = Rand(-1.0,1.0);
	var sig = f * envB;
	Out.ar(~delayBus,Pan2.ar(sig,pan) ) ;
    //Out.ar(~delayBus,f*envB);
}).add;

)

(
a = Pbind(
	\instrument,\seq,
	\midinote, Prand( [48,51,55,50,53,58] , inf)  ,
	\dur,Prand([0.1,0.25,0.2],inf)
);

b = Pbind(
	\instrument,\seqb,
	\midinote, Prand( [48,51,55,50,53,58] , inf) + 12 ,
	\dur,Prand([0.5,0.12,0.1],inf)
);

)

~seqA = a.play;
~seqA.stop;

~seqB = b.play;
~seqB.stop;



(
var notes, on, off;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);    // array has one slot per possible MIDI note

on = MIDIFunc.noteOn({ |veloc, num, chan, src|
    notes[num] = Synth(\test, [\freq, num.midicps,
        \amp, veloc * 0.01]);
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
    notes[num].release;
});

q = { on.free; off.free; };

~lc9 = Bus.control(Server.local,1);
~lc10 = Bus.control(Server.local,1);
~lc11 = Bus.control(Server.local,1);
~lc12 = Bus.control(Server.local,1);
~lc13 = Bus.control(Server.local,1);
~lc14 = Bus.control(Server.local,1);
~lc15 = Bus.control(Server.local,1);
~lc16 = Bus.control(Server.local,1);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc9.set((value/127) * 1)}; },39);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc10.set((value/127) * 1)}; },40);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc11.set((value/127) * 1)}; },41);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc12.set((value/127) * 1)}; },42);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc13.set((value/127) * 1)}; },43);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc14.set((value/127) * 1)}; },44);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc15.set((value/127) * 1)}; },45);
MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc16.set((value/127) * 1)}; },46);

~reverbBus = Bus.audio(Server.local, 2);

r = { Out.ar(0,  GVerb.ar(In.ar(~reverbBus, 2),105,4,mul: 0.4)); }.play;

~grainBus = Bus.audio(Server.local, 2);

~grainer = {
	var inp = In.ar(~grainBus);
	var sig = GrainIn.ar(2 ,  Impulse.kr(100 *In.kr(~lc13 )  ) ,  In.kr(~lc12 ) , inp , Rand(-1.0,1) , -1 , 512 , mul: 0.3 );
		Out.ar(~reverbBus , ( sig * 0.2 ) + inp );
}.play;

~delayL = Buffer.alloc(Server.local,44100 * 1000 ,1);
~delayR = Buffer.alloc(Server.local,44100 * 1000 ,1);
~delayBus = Bus.audio(Server.local, 2);

~delayer = {
	var feedb = LocalIn.ar(2) * K2A.ar(In.kr(~lc16));
	var inp = In.ar(~delayBus);
	var d = BufDelayC.ar([~delayL,~delayR], inp + feedb  ,  Slew.kr( In.kr(~lc15 ) , 2, 2)  , 1);
	Out.ar(~grainBus,d *0.8 + inp);
	LocalOut.ar(d  + inp);
}.play;

SynthDef(\test,{
	| freq=440 , amp=0.1 , gate = 1 |
	var atk = 0.3;
	var dec = 0.2;
	var sus = amp * 1.5 ;
	var rel = 2;
	var sfreq = (freq.cpsmidi - 12 ).midicps;
	var freq2 = (freq.cpsmidi + 4).midicps;
	var e = EnvGen.kr(Env.adsr(atk,dec,sus * 0.8,rel,sus ,\sqr), doneAction:2,gate: gate );
	var noise = SinOsc.ar(LFPar.kr( 0.35 , rrand(0,1) , add: freq) ,mul:0.02)  +
	                   SinOsc.ar(LFPar.kr( 0.39, rrand(0,1) , add: freq2) ,mul:0.01)  + PinkNoise.ar(1);
	var o = (Klank.ar(`[[sfreq,freq,freq2], nil, [0.3, 0.5,0.7]], noise * 0.005 ) + (noise * 0.2)) * e;
	//var o = noise * e;
	var f = RLPF.ar(o,LFPar.kr( 0.41 , rrand(0,1) , add: (freq + 500) *  In.kr(~lc11 )  ),0.2,mul:0.3);
	var pan = 0;
	Out.ar(~reverbBus, Pan2.ar(f, pan));
}).add;


)
