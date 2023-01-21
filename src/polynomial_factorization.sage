import sys
import json

from utils import calc_ratio
from logs import (
    info_log,
    error_log
)
from dynamodb_operation import (
    get_group_data,
    put_group_data
)

def _check_irreducible(poly):
    R.<x> = PolynomialRing(QQ)
    try:
        f = R(poly)
    except Exception as e:
        error_log('Exception', e)
        raise Exception(poly)
    return f.is_irreducible()


def _get_poly_degree(poly):
    R.<x> = PolynomialRing(QQ)
    f = R(poly)
    return int(f.degree())


def _check_multiple_root(factor_info):
    for _, power in factor_info:
        if power > 1:
            return True
    return False


def factor_poly(poly):
    factor_types = []
    for p in range(100):
        if not is_prime(p):
            continue

        R.<x> = PolynomialRing(GF(p))
        factor_info = list(R(poly).factor())

        if _check_multiple_root(factor_info):
            continue

        factor_type = ','.join([str(_get_poly_degree(factor)) for factor, _ in factor_info])
        factor_types.append(factor_type)

    return factor_types


def get_target_group(ratios, group_datas):
    factor_types = set(ratios)
    target_group = 'not found'
    min_average = float('inf')

    for group_data in group_datas:
        conjugacy_ratios = json.loads(group_data['conjugacy_rate'])
        conjugacy_types = set(conjugacy_ratios)
        is_continue = false

        for factor_type in factor_types:
            if (
                factor_type not in conjugacy_types and
                factor_type.split(',') == ['1'] * len(factor_type.split(','))
            ):
                continue
            if factor_type not in conjugacy_types:
                is_continue = true

        if is_continue:
            continue

        tmp_average = sum(
            [
                abs(float(ratios[cycle_type]) - float(conjugacy_ratios[cycle_type]))
                for cycle_type in factor_types
            ]
        ) / len(factor_types)

        if tmp_average < min_average:
            target_group = group_data['group_name']
            min_average = tmp_average

    return target_group


def main(event, context):
    polynomial = event['inputPolynomial']

    info_log('input polynomial', polynomial)

    is_irreducible = _check_irreducible(polynomial)

    info_log('is_irreducible', is_irreducible)

    if is_irreducible:
        factor_types = factor_poly(polynomial)
        ratios = calc_ratio(factor_types)
        info_log('factor type ratios', ratios)

        degree = _get_poly_degree(polynomial)
        group_datas = get_group_data(degree)

        target_group = get_target_group(ratios, group_datas)
    else:
        target_group = 'not irreducible'

    info_log('target_group', target_group)

    _id = event['id']

    info_log('id', _id)

    if target_group != 'S23':
        put_group_data(_id, target_group, polynomial)
    else:
        pass


if __name__ == '__main__':
    args = sys.argv

    info_log('args', args)

    event = {
        'inputPolynomial': args[1],
        'primeRange': args[2],
        'id': args[3]
    }

    info_log('event', event)

    main(event, '')
