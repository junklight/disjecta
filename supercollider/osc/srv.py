from pythonosc import dispatcher
from pythonosc import osc_server


def dhand(*args):
    print( "message",args[0])
    for arg in args[1:]:
        print("\t",arg)

dispatcher = dispatcher.Dispatcher() 
dispatcher.set_default_handler(dhand)

server = osc_server.ThreadingOSCUDPServer( ("127.0.0.1", 8888), dispatcher)
server.serve_forever()
