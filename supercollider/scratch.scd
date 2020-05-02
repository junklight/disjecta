s = Task({
    var delta;
    loop {
        delta = rrand(1, 3);
        Synth(\noiseVoice,[\atk,2,\sus,rrand(1,5),\rel,4,\frmnt,~formant_table.choose(),\knd,[\white,\pink].choose()]);
        delta.yield;
    }
});


a = {PMOsc.ar(440,MouseY.kr(1,550),MouseX.kr(1,15))}.play;

a = { Blip.ar(200,Line.kr(1,100,20),0.2) }.scope(1);
a = { RLPF.ar(Pulse.ar([100,250],0.5,0.1), XLine.kr(8000,400,5), 0.05) }.scope(1);
a = { Klang.ar(`[ {exprand(20, 300)}.dup(16), nil, nil ], 1, 0) * 0.04 }.play;
{ Dust.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);
{ Crackle.ar(MouseX.kr(1,2), 0.5) }.scope(1);



// test of noise voice from formants

Synth(\noiseVoice,[\atk,0.1,\sus,rrand(0.1,0.5),\rel,1,\frmnt,~formant_table.choose(),\knd,[\white,\pink].choose()]);

Synth(\noiseVoice,[\atk,2,\sus,rrand(1,5),\rel,4,\frmnt,~formant_table.choose(),\knd,[\white,\pink].choose()]);

// midi control busses




(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    GVerb.ar(x, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4) + x;
}.scope;
)

(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    x = Pan2.ar(x, -0.2);
    x = [x[0], DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate
    FreeVerb.ar(x, 0.75, 0.9, 0.4);
}.scope;
)




(
// choose a random formant from the table
~formant_table.choose();
// test of synth
b= {
	var e = EnvGen.kr(Env.linen(1, 8, 1, 1, 4), doneAction:2);
	Klank.ar(`[~formant_table.choose(), nil, [1, 1]], PinkNoise.ar(0.007)) * e;
}.play;
b.free;

{
	var knd = \pink;
	(case {knd==\white} {0} {knd ==\pink} { 1}).postln();
}.value();
)

