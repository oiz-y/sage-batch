import subprocess
import uuid
import random

from logs import (
    info_log,
    error_log
)


PRIME_RANGE = 500


def generate_polynomial():
    random_integers = [
        random.randint(-1000000000, 1000000000) for _ in range(22)
    ]
    random_str_intergers = [
        '+ ' + str(n) if n >= 0 else '- ' + str(abs(n)) for n in random_integers
    ]

    polynomial = ''

    for i, str_integer in enumerate(random_str_intergers):
        if str_integer != '+ 0':
            polynomial += ' ' + str_integer + f'x^{i}'

    polynomial += ' + x^23'

    info_log('gerate polynomial', polynomial)

    return polynomial


def batch_calc():
    for i in range(1, 10):
        input_polynomial = generate_polynomial()
        prime_range = PRIME_RANGE
        _id = uuid.uuid4()
        command = [
            'sage', 'polynomial_factorization.sage', input_polynomial, str(prime_range), str(_id)
        ]

        info_log('command', command)

        subprocess.run(command)


if __name__ == '__main__':
    info_log('START', 'batch calc start!')

    batch_calc()

    info_log('END', 'batch calc end!')
