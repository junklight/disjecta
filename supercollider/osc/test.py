from pythonosc import osc_message_builder
from pythonosc import udp_client


client = udp_client.SimpleUDPClient("127.0.0.1",57120)
#client.send_message("/ready",1)
#client.send_message("/report/engines",1)
#client.send_message("/report/commands",1)
#client.send_message("/engine/load/name","SScapes")
client.send_message("/start",1)





