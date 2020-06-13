(


SynthDef(\kick,{ | amp = 1.0 |
	var penv = EnvGen.ar(Env.perc(0.01,0.03 + Rand(-0.01, 0.02)),gate: 1.0);
	var osc = SinOsc.ar(Rand(-2,2) + 90 + 40 * penv);
	var venv = EnvGen.ar(Env.perc(0.01,0.05 + Rand(-0.01, 0.02) ),gate: 1.0, doneAction:2);
	var sig = osc * amp * venv;
	var loc = Pan2.ar(sig,0.0);
	Out.ar(0,loc);
}).add;

SynthDef(\kicktwo,{ | amp = 1.0 , freq = 300 |
	var penv = EnvGen.ar(Env.perc(0.01,0.03 + Rand(-0.01, 0.02)),gate: 1.0);
	var osc = SinOsc.ar(Rand(-2,2) + freq + 40 * penv);
	var venv = EnvGen.ar(Env.perc(0.01,0.05 + Rand(-0.01, 0.02) ),gate: 1.0, doneAction:2);
	var sig = osc * amp * venv;
	var loc = Pan2.ar(sig,0.0);
	Out.ar(0,loc);
}).add;

SynthDef(\CHat, { | amp = 2.0 |
	var venv = EnvGen.ar(Env.perc(0.01,0.05 + Rand(-0.01, 0.02) ),gate: 1.0, doneAction:2);
	var osc = Mix.ar(Pulse.ar([205.3,369.6,522.7,800,540]));
	var fone = BBandPass.ar( osc * 0.3 , 3440 + Rand ( -2, 2) , 2.0 );
	var ftwo = BBandPass.ar( osc * 0.3 , 7100 + Rand ( -5, 5), 3.0 );
	var hp = BHiPass4.ar( (( fone * 0.9)  + (ftwo * 0.9)) * venv ,8000,3.0);
	var sig = hp * amp * 5.0;
	var loc = Pan2.ar(sig,0.0);
	Out.ar(0,loc);
}).add;
)

(

t = TempoClock.new(0.7, 1);

c = Routine {
	var tick = 0;
	var getn = Routine({
		loop {
			[3,5,7].do{ arg n; n.yield };
		}
	});
	var geta = Routine({
		loop {
			[1.0,0.6,0.5,0.6].do{ arg n; n.yield };
		};
	});
	var gethatamp = Routine({
		loop {
			[1.0,0.4].do{ arg n; n.yield };
		};
	});
	var ilst = [
		[\kick , { var tick = 0; {
			var amp = geta.next;
			tick = tick + 1;
			if ( tick % 2 == 0 , {
				Synth(\kick,[\amp,amp]); });
		}}.value
		],
		[\kicktwo , {
			var amp = geta.next;
			var f = [200,250,300].choose;
						Synth(\kicktwo,[\amp,amp,\freq,f]); }],
		[\CHat , {
			var amp = gethatamp.next;
						Synth(\CHat,[\amp,amp]); }]
	];
	{
		if (tick % 2 == 0 , {
			if ( 3.rand <= -1 , {
				a.reset.play(t);
			}, {
				var b = Routine {
					var n = (getn.next) * 2;
					var t = 2.0/n;
					var ifn = ilst.choose[1];
					n.postln;
					n.do {
						ifn.();
						t.yield;
					};
				};
				b.reset.play(t);
			});
		});
		tick = tick + 1;
		0.5.yield;
	}.loop;
}.play(t);

)