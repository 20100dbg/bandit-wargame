import random
import socket

pin = open('/etc/bandit_pass/bandit25pin', 'r').read().strip()
password24 = open('/etc/bandit_pass/bandit24', 'r').read().strip()
password25 = open('/etc/bandit_pass/bandit25', 'r').read()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind(("127.0.0.1", 30002))
    s.listen()

    while True:
        try:
            conn, addr = s.accept()
            
            while True:
                data = conn.recv(1024).decode().strip().split()

                if len(data) > 1 and data[0] == password24 and data[1] == pin:
                    conn.send(b'Correct !\n')
                    conn.send(password25.encode() + b'\n')
                else:
                    conn.send(b'Wrong password !\n')
        except Exception as e:
            print('Exception', e)
