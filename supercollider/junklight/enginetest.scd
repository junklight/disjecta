









(
a = SynthDef.new(\mjwtest , {
	arg gate=1,hz=220,detune=0,rel=4,fold=0.0,amp=0.1,cut=100;
	var osc,osc2,env,fld,flt;

	fold = Lag.kr(in: fold, lagTime: 0.2);


	osc = Saw.ar( LFPar.kr( 0.4 , rrand(0,1) , add: hz) , mul: 0.5);
	osc2 = Saw.ar( LFPar.kr( 0.4 , rrand(0,1) , add: hz + detune) ,  mul: 0.4);
	fld=Fold.ar(in: tanh(osc  + osc2) + (1 + (fold *2)),lo:-0.5,hi:0.5);
	flt = BMoog.ar(fld,cut);
	env = EnvGen.ar(
		Env.asr(0.002,amp,rel) ,
		gate,
		doneAction:2);
	Out.ar(0,flt*env);
}).add;

);

b = Bus.control;
b.set (1800);

g = Group.new;

(
x = Synth(\mjwtest,["hz",120],g);
x.map(\cut,b);
);
x.set("gate",0);
x.set(\detune,3);

x.set("fold",0.034);

(
y = Synth(\mjwtest,["hz",220],g);
y.map(\cut,b);
);

y.set("gate",0);
y.set(\cut,1900);
y.set("fold",0.2);

g.set("fold",0.06);
g.set("cut",500);
g.set("gate",0);


\hello1

("hello" ++ 1).asSymbol == \hello1


a.allControlNames.do{ arg ctl; ctl.name.postln; };


