~opts = ServerOptions();

ServerOptions.devices;

~opts.device = "Loopback Audio";
~opts.numOutputBusChannels = 4;
~opts.sampleRate = 44100;

~srv = Server("blah",NetAddr("192.168.1.148", 8080));
~srv. boot;

Server.default = ~srv;


~srv.quit;

~srv.numAudioBusChannels;



{SinOsc.ar}.play
{SinOsc.ar([220,440])}.play;




~s2 = Server.remote("test",NetAddr("192.168.1.148", 8080));
Server.default = ~s2;


~s2.freeAll;

include("SuperDirt");
