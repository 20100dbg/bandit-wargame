import socket
import ssl

HOST = "127.0.0.1"
PORT = 30001
password15 = open('/etc/bandit_pass/bandit15', 'r').read().strip()
password16 = open('/etc/bandit_pass/bandit16', 'r').read()


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER);
    #context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)

    cipher = 'DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:ECDHE-ECDSA-AES128-GCM-SHA256'
    #context.set_ciphers(cipher)
    context.set_ciphers("@SECLEVEL=1:ALL")

    context.verify_mode = ssl.CERT_NONE #ssl.CERT_OPTIONAL
    context.load_cert_chain('/etc/bandit_scripts/script15.pem', '/etc/bandit_scripts/script15.key');
    context.load_verify_locations('/etc/bandit_scripts/script15.pem')
    
    ss = context.wrap_socket(s,server_side=True);

    ss.bind((HOST, PORT))
    ss.listen()

    while True:
        try:
            conn, addr = ss.accept()
            with conn:
                data = conn.recv(1024).decode().strip()

                if data == password15:
                    conn.send(b'Correct !\n')
                    conn.send(password16.encode() + b'\n')
                else:
                    conn.send(b'Wrong password !\n')
        except Exception as e:
            print('Exception', e)