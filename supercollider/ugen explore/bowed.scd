(

~reverbBus = Bus.audio(Server.local, 2);
~feedBus = Bus.audio(Server.local, 2);



~reverb = SynthDef(\effectd,{
									arg mix=0.5,size=100,time=4;
	var sigodel;
									var sigi = In.ar(~reverbBus,2);
									var revrb = GVerb.ar(sigi,size,time);
									var sigo = ((1 - mix) * sigi) + (mix * revrb);
									sigo = LPF.ar(in: sigo, freq: 14000);
								  sigo = CompanderD.ar(in: sigo,
		thresh: 0.4, slopeBelow: 1,
		slopeAbove: 0.25, clampTime: 0.002, relaxTime: 0.01);
	sigo = tanh(sigo + InFeedback.ar(~feedBus) * 0.5 ).softclip;
                                	sigodel = BufDelayL.ar(~del,sigo,1.5);
	Out.ar(~feedBus,sigodel);

									Out.ar(0, sigo + sigodel);
					}).play;

SynthDef(\help_dwgbowed, { |out=0, freq=440, amp=0.5,force=0, gate=1,pos=0.07,c1=0.25,c3=31,pan=0|
	var env = EnvGen.ar(Env.adsr(0.4,0.2,0.6,1),gate,doneAction:2);
    var vib = Gendy1.kr(1,1,1,1,0.1, 4,mul:0.003,add:1);
    var son = DWGBowedTor.ar(freq*vib, amp,force , gate,pos,0.1,c1,c3);
	var dson = Shaper.ar(
        b,
        son,
		0.5);
    son = DWGSoundBoard.ar( son * 0.2 + dson * 0.8 );
    son = BPF.ar(son,118,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,6000);
    Out.ar(~reverbBus , Pan2.ar(son * 0.05 * env , pan));
}).add;



)

(
c = Bus.control;
d = Bus.control;
//c.set(440);
p = {	Out.kr(c.index,MouseX.kr(0,1));}.play;
q = {	Out.kr(d.index,MouseY.kr(100,600));}.play;
);
(
a = Synth(\help_dwgbowed,["freq",220,\force,0,\amp,0]);
a.map(\force,c.index);
a.map(\amp,c.index);
a.map(\freq,d.index);
);
a.free;

c.set(4300);


(
q = Task({
	loop {
		c.get({ arg val; val.postln; f = val; });
		1.wait }
}).play;
);

//Use it.
(

Pbind(
    \instrument, \help_dwgbowed,
    \dur , 2,
	\delta,10,
	\octave,3,
    \degree, Pseq([1,5,7+3], inf),
    \amp , Pseq([0.9,0.7,0.5],inf),
).play;

);
(
Pbind(
    \instrument, \help_dwgbowed,
    \dur , 2,
	\delta,2,
	\octave,4,
    \degree, Pseq([1,5,7+3], inf),
    \amp , Pseq([0.9,0.7,0.5],inf),
).play;

)


f = Array.fill(15,nil);

f[5].notNil;

78.3.midicps;

(
a = Signal.fill(256, { |i|
    var t = i/255.0;
    t + (0.1 * (max(t, 0.1) - 0.1) * sin(2pi * t * 80 + sin(2pi * 25.6 * t)))
})
);

a.plot;


b = Buffer.alloc(s, 512, 1, {arg buf; buf.chebyMsg([0.25,0.5,0.25], false)});
b.plot;

~del = Buffer.alloc(s,44100*40);





delayN

