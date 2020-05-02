//Define pluck synthdef
(
SynthDef(\help_dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked.ar(freq, amp, gate,0.1,1,c3,inp);
    DetectSilence.ar(son, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)

//Use it.
(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

Pbind(
    \instrument, \help_dwgplucked,
    \scale ,a,
    \delta , Pseq([1,0.5,0.5,0.5,0.5,0.5,0.5,1,0.5,0.5,1,1]*0.5,inf),
	\dur , Prand([1,0.7,2],inf) ,
    \degree, Pseq([1,8,8,8,8,8,8,-6,Prand([9,10,11],1),1,7,8]-8, inf),
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([1400],24),Pseq([300],24)],inf),
    \pan , Pwhite(-1,1),
).play;
)


//Define piano synthdef and soundboard
(
SynthDef(\help_oteypianostring, { |out=0, freq=440,gate=1, amp=0.5,rho=1|
    var son = OteyPianoStrings.ar(freq, amp, rho:rho)*EnvGen.ar(Env.asr(0,1,0.1),gate,doneAction:2);
    Out.ar(out, Pan2.ar(son * 1, LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75)));
}).add;

SynthDef(\piano_soundboard,{
	var rev;
    var audio = In.ar([20, 21], 2);
    audio = OteySoundBoard.ar(audio);
    rev = FreeVerb.ar(audio,mix:0.5,room: 10,damp:0.2,mul:3);
    Out.ar(0,rev * 2.0);
}).add
)

//start soundboard effect
Synth.tail(1,\piano_soundboard);

//Use it.
(
Pbind(
    \instrument, \help_oteypianostring,
	\delta, Prand([1,0.5,3,7,10],inf),
	\dur, 1,
	\degree, Pshuf([1,3,5,7,8,12,15,21], inf),
    \out, 20,
).play;
)

//Define bow synthdef
(
SynthDef(\help_dwgbowed, { |out=0, freq=440, amp=0.5,force=1, gate=1,pos=0.07,c1=0.25,c3=31,pan=0|
	var rev;
    var vib = Gendy1.kr(1,1,1,1,0.1, 4,mul:0.003,add:1);
    var son = DWGBowed.ar(freq*vib, amp,force, gate,pos,3,c1,c3);
    son = DWGSoundBoard.ar(son);
    son = BPF.ar(son,118,1)+son;
    son = BPF.ar(son,430,1)+son;
    son = BPF.ar(son,490,1)+son;
    son = LPF.ar(son,6000);
    Out.ar(out, Pan2.ar(son * 0.01, pan));
}).add;
)

//Use it.
(

Pbind(
    \instrument, \help_dwgbowed,
	    \dur , Prand([3,6,2],inf),
	\delta,Prand([1,3],inf),
    \degree, Prand([1,5,7+3]  , inf),
    \amp , Pseq([0.5,0.4,0.5],inf),
).play;
)


Pbindef


{ Fold.ar(LFTri.ar(440, 0, 0.2), SinOsc.ar(0.17, 0.3, 0.2), SinOsc.ar(0.3, 0, 0.2)) }.play;

{ Fold.ar(SinOsc.ar(440, 0, 0.2), SinOsc.ar(0.07, 0.3, 0.2), SinOsc.ar(0.19, 0, 0.2)) }.play;



