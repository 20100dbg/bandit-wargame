import random
import socket
import ssl
import threading

def start_server(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, port))
        s.listen()

        while True:
            conn, addr = s.accept()
            
            while True:
                conn.send(conn.recv(1024))


HOST="127.0.0.1"
used_ports = []

while len(used_ports) < 5:
    port = random.randint(31000,32000)

    if port not in used_ports:
        used_ports.append(port)
        w = threading.Thread(target=start_server, args=[port])
        w.start()


while True:
    port = random.randint(31000,32000)
    if port not in used_ports:
        break


password16 = open('/etc/bandit_pass/bandit16', 'r').read().strip()
password17 = open('/etc/bandit_scripts/sshkey17.private', 'r').read()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER);

    cipher = 'DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-GCM-SHA256'
    #context.set_ciphers(cipher)
    context.set_ciphers("@SECLEVEL=1:ALL")

    context.verify_mode = ssl.CERT_NONE #ssl.CERT_OPTIONAL
    context.load_cert_chain('/etc/bandit_scripts/script15.pem', '/etc/bandit_scripts/script15.key');
    context.load_verify_locations('/etc/bandit_scripts/script15.pem')
    
    ss = context.wrap_socket(s,server_side=True);
    ss.bind((HOST, port))
    ss.listen()

    while True:
        try:
            conn, addr = ss.accept()
            while True:
                data = conn.recv(1024).decode().strip()

                if data == password16:
                    conn.send(b'Correct !\n')
                    conn.send(password17.encode() + b'\n')
                else:
                    conn.send(b'Wrong password !\n')
        except Exception as e:
            print('Exception', e)
