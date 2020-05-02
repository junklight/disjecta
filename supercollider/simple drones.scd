
Ndef(\osc).ar;
Ndef(\lfo1).kr;
(
Ndef(\osc , {
	var osc = Pulse.ar( 120 , Ndef(\lfo1) , mul: 0.1);
	var flt = RLPF.ar(osc,480 , 0.7);
	flt;
} );
);

Ndef(\lfo1,{ 0.7; });
Ndef(\lfo1,{ Pulse.kr( 0.2 , add:0.1 , mul: 0.4) + Saw.kr(0.93 , add: 0.1 , mul: 0.7 ); });

Ndef(\osc).play;



{ RLPF.ar(Pulse.ar([100, 120], 0.5, 0.1), XLine.kr(3000, 400, 5), 0.05) }.play;