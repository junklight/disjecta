

s = Server.remote(\realtimepi, NetAddr("192.168.1.130", 57117));
s.serverRunning;
s.boot;
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play(s);

s.freeAll();