import random
import sys

if len(sys.argv) != 3:
    exit(1)

size = int(sys.argv[1])
output=sys.argv[2]

with open(output, 'wb') as f:
    for x in range(size):
        i = random.randint(1,255)
        f.write(i.to_bytes(1, 'big'))
        #sys.stdout.buffer.write(i.to_bytes(1, 'big'))
