Crone.setEngine("Engine_SScapes");

Crone.reportEngines;

Crone.reportEngines;

Crone.initOscRx;

NetAddr.langPort

n = NetAddr("127.0.0.1", 2222);
OSCFunc.newMatching({|msg, time, addr, recvPort| msg.postln}, '' , nil, 8888 );
OSCFunc.trace(true);

m = NetAddr("127.0.0.1", 57120);
m.sendMsg("/");


Server.local;


