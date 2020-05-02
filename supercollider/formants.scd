
// run the top block first
(

// Setup MIDI
MIDIIn.connectAll;
~lc1 = 0.1;
~lc2 =5;
~lc9 = Bus.control(Server.local,1);
~lc10 = Bus.control(Server.local,1);
~lc11 = Bus.control(Server.local,1);
~lc12 = Bus.control(Server.local,1);
~lc13 = Bus.control(Server.local,1);
~lc14 = Bus.control(Server.local,1);
~lc15 = Bus.control(Server.local,1);
~lc16 = Bus.control(Server.local,1);



MIDIFunc.cc({arg value,cc, x,src;  if (value==0) {~lc1 = 0.01 } { ~lc1=value}; },30);
MIDIFunc.cc({arg value,cc, x,src;  if (value==0) {~lc2 = 0.01 } { ~lc2=value}; },31);

~ctrlfn = { arg rc, chan, num, val; [rc,chan,num,val].postln; };
//MIDIIn.addFuncTo(\control,~ctrlfn);
//MIDIIn.removeFuncFrom(\control,~ctrlfn);

MIDIFunc.cc(
	{ arg value,cc, x,src; if (value==0) { value = 0.01 } { ~lc9.set((value/127) * 2000)}; },39);
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

// formant table
// lifted from https://www.classes.cs.uchicago.edu/archive/1999/spring/CS295/Computing_Resources/Csound/CsManual3.48b1.HTML/Appendices/table3.html
//
~formant_table = [
	[800,1150] ,  // soprano a
	[350,2000], // soprano e
	[270,2140], // soprano i
	[450,800], // soprano o
	[325,700], // soprano u
	[800,1150], // alto a
	[400,1600], // alto e
	[350,1700], // alto i
	[450,800], //alto o
	[325,700], // alto u
	[600,1120], // counter a
	[440,1800], // counter e
	[270,1850], // counter i
	[430,820], // counter o
	[370,630], // counter u
	[650,1080], // tenor a
	[400,1700], // tenor e
	[290,1870], // tenor i
	[400,800], // tenor o
	[350,600], // tenor u
	[600,1040], // bass a
	[400,1620], // bass e
	[250,1750], // bass i
	[400,750], // bass o
	[350,600] // bass u
];

// noise Voice synth

SynthDef(\noiseVoice,
	{
	|knd=\white,atk=0.4,sus=8, rel=0.1, frmnt=#[450,800]|
	var e = EnvGen.kr(Env.linen(atk, sus, rel, 0.4, \sqr), doneAction:2);
		var indx = switch (knd,\white,0,\pink,1,0);
	var noise = Select.ar( indx,  [WhiteNoise.ar(0.007) , PinkNoise.ar(0.007)]);
	var o = Klank.ar(`[frmnt, nil, [0.5, 0.5]], noise ) * e;
	var f = LPF.ar(o,2000);
	var pan = Rand(-1.0,1.0);
	Out.ar(0, Pan2.ar(f, pan));
}).add;

// deep dusty drone note & reverb

~reverbBus = Bus.audio(Server.local, 2);

r = { Out.ar(0,  GVerb.ar(In.ar(~reverbBus, 2),105,4)); }.play;

SynthDef(\DroneOne, {
	| freq=55 |
	var env = EnvGen.kr(Env.linen(10, 5, 10, 0.2, \sqr), doneAction:2);
	var pan = Rand(-1.0,1.0);
	x = Mix.ar(
			{SinOsc.ar( Crackle.kr(1.4,rrand(freq-50,freq+50) ,rrand(freq-50,freq+50)) , mul: 0.1 ) }.dup(3)
		) * env;
	Out.ar(~reverbBus, Pan2.ar(x, pan));
	}).add;

// delay for sequencer

~delayB = Buffer.alloc(Server.local,44100 * 1000 ,1);
~delayBus = Bus.audio(Server.local, 2);

~delayer = {
	var feedb = LocalIn.ar() * 0.6;
	var inp = In.ar(~delayBus);
	var d = BufDelayC.ar(~delayB, inp + feedb , 0.3 , 1);
	Out.ar(0,d * 0.3 + inp);
	LocalOut.ar( d * 0.3 + inp);
}.play;

)


// 'voice' notes

(
r = Task({
    var delta,prob;
    loop {
		prob = (~lc1/127.0) * 1.0;
        delta = (~lc2/127.0) * 15;
		if (prob.coin) {
        Synth(\noiseVoice,[\atk,delta,\sus,rrand(0.01,0.1),\rel,delta,\frmnt,[rrand(20,1200),rrand(20,1200)],\knd,\pink]);
		};
		rrand(0.1,1).yield;
    }
});
)

r.play;
r.stop;


// drone

(
t = Task({
    var delta,prob;
    loop {
		prob = 0.3;
		if (prob.coin) {
			Synth(\DroneOne,[\freq,[55,65.4,77.78,98].choose]);
		};
		rrand(1,5).yield;
    }
});
)

t.play;
t.stop;



/// ****SCRATCH BELOW HERE*******

(
SynthDef( \seqVoice, {
	| freq = 320 |
	var e = EnvGen.kr(Env.linen(0.01, 0.09, 0.1, 0.5, \sqr),doneAction: 2);
	var osc = (
		SinOsc.ar( LFPar.kr( 0.4 , rrand(0,1) , add: freq/2.0) , mul: 3)  +
		Saw.ar( LFPar.kr( 0.4 , rrand(0,1) , add: freq) , mul: 3) +
		Pulse.ar( LFPar.kr( 0.2 , rrand(0,1), add: freq) , mul: 4 ) ) * e;
	var filt = RLPF.ar(osc, LFCub.kr(0.2,rrand(0,1) , add: In.kr(~lc9 )) , In.kr(~lc10) , mul: 0.5);
	Out.ar(~delayBus,filt);
}).add;
)

(
Pbind(
	\instrument,\seqVoice,
	\dur, 0.2 ,
	\degree, Pseq( [1,3,5] , 50) - 8
).play;
)

Synth(\seqVoice,[\freq,110]);

(
SynthDef( \pulseVoice, {
	| freq = 320 , atk=1 , sus=3,rel=2 |
	var e = EnvGen.kr(Env.linen(atk, sus, rel, 0.5, \sqr),doneAction: 2);
	var osc = (
		Saw.ar( LFPar.kr( 0.4 , rrand(0,1) , add: freq/2.0) , mul: 3)  +
		Saw.ar( LFPar.kr( 0.4 , rrand(0,1) , add: freq) , mul: 3) +
		Saw.ar( LFPar.kr( 0.2 , rrand(0,1), add: freq) , mul: 4 ) ) * e;
	var filt = RLPF.ar(osc, LFCub.kr(0.2,rrand(0,1) , add: In.kr(~lc9 )) , In.kr(~lc10) , mul: 0.5) * 0.2;
	Out.ar(~reverbBus,filt) ;
}).add;
)

Synth(\pulseVoice,[\freq,120,\atk,0.1,\sus,0.1,\rel,4]);



(
~tmp = {
    var env = Env.circle([0.0, 1, 0.0], [0.01, 0.1, 0.07], \lin);
    var envgen = EnvGen.ar(env,);
	var osc = ( Saw.ar( LFPar.kr( 0.4 , rrand(0,1) , add: 120) , mul: 3)  +
    Saw.ar(
        envgen * 120
	    ) )* envgen;
	var filt = RLPF.ar(osc, LFCub.kr(0.2,rrand(0,1) , add: In.kr(~lc9 )) , 0.0472 , mul: 0.5) * 0.2;
	Out.ar(~reverbBus,filt) ;
}.play
);

~tmp.free;

~lc10.get;

(40..70 ).choose.midicps.round(0.1);

(
~tmpB = {
	var freq = (40..70 ).choose.midicps.round(0.1);
    var env = Env.linen(0.1,0.2,0.3,0.3);
    var envgen = EnvGen.ar(env,doneAction: 2);
	var osc = ( PinkNoise.ar )* envgen;

	var fOsc = BBandPass.ar( osc , 440 , rrand(0.1,1.5) );
	var form = ~formant_table.choose;
	var pan = Rand(-1.0,1.0);
	var fOne,fTwo;
	form[0].postln;
	form[1].postln;
	fOne = Formlet.ar(fOsc,form[0] , 0.05 , 0.2) * 0.2;
	fTwo = Formlet.ar(fOsc,form[1] , 0.05 , 0.2) * 0.1;
	Out.ar(0, Pan2.ar(fOne + fTwo + fOsc , pan));
}.play;
)

(
SynthDef( \noiseVoiceB , {
	| freq , form = #[325,700] |
	var env = Env.linen(0.01,0.1,0.2,0.3);
    var envgen = EnvGen.ar(env,doneAction: 2);
	var osc = ( PinkNoise.ar )* envgen;
	var fOsc = BBandPass.ar( osc , freq , Rand(0.1,1.5) );
	var pan = Rand(-1.0,1.0);
	var fOne,fTwo;
	fOne = Formlet.ar(fOsc,form[0] , 0.05 , 0.2) * 0.2;
	fTwo = Formlet.ar(fOsc,form[1] , 0.05 , 0.2) * 0.1;
	Out.ar(0, Pan2.ar(fOne + fTwo + fOsc , pan));

}).add;
)

(
t = Task({
    var delta,prob,freq,form;
    loop {
		prob = (~lc1/127.0) * 1.0;
		freq = (40..70 ).choose.midicps.round(0.1);
		form = ~formant_table.choose;
		if (prob.coin) {
			Synth(\noiseVoiceB,[\freq,freq,\form,form]);
		};
		rrand(0.01,0.08).yield;
    }
});
)

t.play;
t.stop;

(
~str = Pbind(
	\instrument,\noiseVoiceB,
	\degree, Pseq( [1,3,5] , 50)    ,
	\form,Prand(~formant_table,inf),
	\dur,0.1
).play;
)

~str.free;

~tmpB.free;



// ***************** DEBUG *****************************

// MIDI debug

(
t = Task({
	loop{
		"~lc1: " .post; ~lc1.postln;
		"~lc2: ".post; ~lc2.postln;
		"~lc9: " .post; ~lc9.get.postln;
		"~lc10: ".post; ~lc10.get.postln;
		0.5.wait;
	}
}) .play;
)
t.stop;








