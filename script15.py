import socket
import ssl

HOST = "127.0.0.1"
PORT = 30001
password15 = open('/etc/bandit_pass/bandit15', 'r').read()
password16 = open('/etc/bandit_pass/bandit16', 'r').read()


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:

	ss = ssl.wrap_socket(s,server_side=True, keyfile='/etc/bandit_scripts/script15.key',certfile='/etc/bandit_scripts/script15.pem',ssl_version=ssl.PROTOCOL_TLSv1_3);

    ss.bind((HOST, PORT))
    ss.listen()

    while True:
	    conn, addr = ss.accept()
	    with conn:
	        while True:
	            data = conn.recv(1024)

	            if data == password15:
	            	conn.sendall('Correct !')
	            	conn.sendall(password16)
	            else:
	            	conn.sendall('Wrong password !')
