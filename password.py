from subprocess import Popen
import string
import secrets
import re


def empty():
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


def remember():
    set_val('/etc/pam.d/common-password',
            r'(pam_history\.so\s+remember\s*=)\s*\d*',
            '\1 14',
            'pam_history.so remember = 14')


def age():
    fname = '/etc/login.defs'
    set_val(fname, r'(PASS_MIN_DAYS\s*=)\s*\d*', '\1 10', 'PASS_MIN_DAYS = 10')
    set_val(fname, r'(PASS_MAX_DAYS\s*=)\s*\d*', '\1 60', 'PASS_MAX_DAYS = 60')


def set_val(fname, regex, sub, append):
    with open(fname, 'r') as f:
        s = f.read()

    exp: re.Pattern = re.compile(regex)
    if exp.search(s) is not None:
        exp.sub(s, sub)
    else:
        with open(fname, 'a') as f:
            f.write(append)


empty()
remember()
age()
