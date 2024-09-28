import socket

HOST = "127.0.0.1"
PORT = 30000
password14 = open('/etc/bandit_pass/bandit14', 'r').read().strip()
password15 = open('/etc/bandit_pass/bandit15', 'r').read()


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()

    while True:
        conn, addr = s.accept()
        with conn:
            data = conn.recv(1024).decode().strip()

            print(data,password14)

            if data == password14:
                conn.send(b'Correct !\n')
                conn.send(password15.encode() + b'\n')
            else:
                conn.send(b'Wrong password !\n')
