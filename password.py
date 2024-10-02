from subprocess import Popen
import string
import secrets

with open('/etc/passwd', 'r') as f:
    passwords = f.read()

alphabet = string.ascii_lowercase+string.ascii_uppercase+string.digits
for line in passwords.split('\n'):
    fields = line.split(':')
    user = fields[0]
    pw = fields[1]
    if pw != 'x':
        proc = Popen(['/usr/bin/sudo', '/usr/bin/passwd', '--stdin', user])
        new_pw = ''.join(secrets.choice(alphabet) for _ in range(20))
        proc.communicate(new_pw)
        proc.wait()
