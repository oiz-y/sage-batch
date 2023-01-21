import sys
import subprocess
import uuid
import random

from logs import (
    info_log,
    error_log
)


def adjust_except_group(except_group, degree):
    if except_group == 'NotSelected':
        return f'S{degree}'
    else:
        return except_group


def generate_polynomial(degree, coeff_range):
    random_integers = [
        random.randint(-coeff_range, coeff_range) for _ in range(degree - 1)
    ]
    random_str_intergers = [
        '+ ' + str(n) if n >= 0 else '- ' + str(abs(n)) for n in random_integers
    ]

    polynomial = ''

    for i, str_integer in enumerate(random_str_intergers):
        if str_integer != '+ 0':
            polynomial += ' ' + str_integer + f'x^{i}'

    polynomial += f' + x^{degree}'

    info_log('gerate polynomial', polynomial)

    return polynomial


def batch_calc(max_times, degree, prime_range, coeff_range, except_group):
    except_group = adjust_except_group(except_group, degree)

    info_log('adjust except_group', except_group)

    for i in range(0, max_times):
        input_polynomial = generate_polynomial(degree, coeff_range)
        _id = uuid.uuid4()
        command = [
            'sage',
            'polynomial_factorization.sage',
            input_polynomial,
            str(prime_range),
            str(_id),
            except_group
        ]

        info_log('command', command)

        subprocess.run(command)


if __name__ == '__main__':
    info_log('START', 'batch calc start!')

    args = sys.argv

    max_times = int(args[1])
    degree = int(args[2])
    prime_range = int(args[3])
    coeff_range = int(args[4])
    except_group = args[5]

    info_log('max_times', max_times)
    info_log('degree', degree)
    info_log('prime_range', prime_range)
    info_log('coeff_range', coeff_range)
    info_log('except_group', except_group)

    batch_calc(max_times, degree, prime_range, coeff_range, except_group)

    info_log('END', 'batch calc end!')
