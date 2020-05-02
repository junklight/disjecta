

~organelle = Server("organelle",NetAddr("192.168.1.106",57110));
~organelle.boot;

SynthDef("sine", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).send(~organelle);
~organelle.sendMsg("s_new", "sine", n = ~organelle.nextNodeID, 0, 1);
~organelle.sendMsg("/n_free", n);


Server.default = ~organelle;

a = Synth(\sine );
a.free;

