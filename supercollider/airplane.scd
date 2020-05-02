(
MIDIClient.init;
MIDIIn.connectAll;
s.options.outDevice_("Loopback Audio 2");
s.options.numOutputBusChannels = 6;
s.boot;
)

(
~rezone = Bus.control();
~rezotwo = Bus.control();
~rezothree = Bus.control();
)

(
SynthDef(\dchord, { | one , two , three , gate = 1, rezone = 0 , reztwo = 0  , rezthree = 0 |
	var env = EnvGen.kr( Env.asr(25,1.0,25) , gate, doneAction: 2 );
	var nse = WhiteNoise.ar();
	var flt0 = RLPFD.ar( nse ,  LFPar.kr( 0.1 , 0.0 , one * 0.1 , one/2 ) , rezone );
	var flt = RLPFD.ar( nse ,  LFPar.kr( 0.1 , 0.0 , one * 0.1 , one ) , rezone );
	var flt2 = RLPFD.ar( nse , LFPar.kr( 0.3 , 0.0 , two * 0.1 , two ) , reztwo );
	var flt3 = RLPFD.ar( nse , LFPar.kr( 0.15 , 0.0 , three * 0.1 , three ) , rezthree );

	Out.ar(0 , Pan2.ar( (flt + flt2 + flt3)  * env , 0.5 ) );
}).add;

SynthDef(\wnoisen, { | freq , vel = 0.5, gate = 1 |
	var env = EnvGen.kr( Env.asr(3,1.0,15) , gate, doneAction: 2 );
	var nse = WhiteNoise.ar();
	var flta = BPF.ar(nse,freq,1.2);
	var fltb = BPF.ar(nse,(freq / 2 ) + 0.3 ,1.2);
	var ss = SinOsc.ar(freq/2) + ( SinOsc.ar(freq) * 0.5) ;
	var flt2 = BPF.ar(flta,freq,0.9);
	var flt3 = BMoog.ar(flt2 + ss + fltb, freq , 0.9, 1.5 );
	Out.ar(2, Pan2.ar( flt3 * env * 0.2 * vel , 0.5 ) );
}).add;
)

(
~lc = MIDIOut.newByName("Launch Control","Launch Control");
~notes.free;
~notes = List.new();
10.do ({
	|i|
	[ 7 , 9 , 10 , 12 , 14 , 15 , 17 ].do({
		|n|
		~notes.add( n + (i * 12) );
});
});
~ccf.free;
~ccf = MIDIFunc.cc( {
	| val, num, chan|
	case
	{ num == 21 } { ~rezone.value = val/127; }
		{ num == 22 } { ~rezotwo.value = val/127; }
		{ num == 23 } { ~rezothree.value = val/127; };
});
~drones.free;
~drones = Dictionary.new();
~pnotes = Dictionary.new();
7.do({ |i|  ~drones[i] = nil; });
~onf.free;
~onf = MIDIFunc.noteOn( {
	| val, num, chan|
	"on ".post; val.post; ", ".post; num.post; ", ".post; chan.postln;
	case
	{ chan == 8 } // launchcontrol
	{
		var id = num - 9;
		if (~drones[id].isNil) {
			~drones[id] = Synth(\dchord ,
			[\one,~notes[(7 + id) + 14].midicps,
			 \two,~notes[(7 + id + 2) + 14].midicps,
			 \three,~notes[(7 + id + 4) + 14].midicps]);
			~drones[id].map(\rezone,~rezone,\reztwo,~rezotwo,\rezthree,~rezothree);
			~lc.noteOn(8,num,40);

		} {
			~drones[id].set(\gate,0);
			~drones[id] = nil;
			~lc.noteOn(8,num,0);
		};
	}
	{ chan == 0 } //xkey
	{
		var id = num;

		~pnotes[id] = Synth(\wnoisen ,
			[\freq, num.midicps,\vel,val/127]);
	};
});
~offf.free;
~offf = MIDIFunc.noteOff( {
	| val, num, chan|
	"off ".post; val.post; ", ".post; num.post; ", ".post; chan.postln;
	case
	{ chan == 8 } // launchcontrol
	{
		// ignoring these
	}
	{ chan == 0 } //xkey
	{
		var id = num;
		~pnotes[id].set(\gate,0);
	};
});
)
MIDIClient





(
~d_one = Synth(\dchord,[\one,~notes[14 + 14].midicps,\two,~notes[16 + 14].midicps,\three,~notes[18+ 7].midicps]);
~d_one.map(\rezone,~rezone,\reztwo,~rezotwo,\rezthree,~rezothree);


~d_two = Synth(\dchord,[\one,~notes[14 + 7].midicps,\two,~notes[16 + 7].midicps,\three,~notes[18+ 7].midicps]);
~d_two.map(\rezone,~rezone,\reztwo,~rezotwo,\rezthree,~rezothree);


)





