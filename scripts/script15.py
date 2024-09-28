import socket
import ssl

HOST = "127.0.0.1"
PORT = 30001
password15 = open('/etc/bandit_pass/bandit15', 'r').read().strip()
password16 = open('/etc/bandit_pass/bandit16', 'r').read()


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER);
    context.load_cert_chain('/etc/bandit_scripts/script15.pem', '/etc/bandit_scripts/script15.key');
    ss = context.wrap_socket(s,server_side=True);

    ss.bind((HOST, PORT))
    ss.listen()

    while True:
        conn, addr = ss.accept()
        with conn:
            data = conn.recv(1024).decode().strip()

            if data == password15:
                conn.send(b'Correct !\n')
                conn.send(password16.encode() + b'\n')
            else:
                conn.send(b'Wrong password !\n')
