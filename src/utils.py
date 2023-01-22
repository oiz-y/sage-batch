def calc_ratio(factor_types):
    type_count = {}
    for factor_type in factor_types:
        if factor_type in type_count:
            type_count[factor_type] += 1
        else:
            type_count[factor_type] = 1

    ratios = {
        factor_type: count / len(factor_types)
        for factor_type, count in type_count.items()
    }

    return ratios


def write_file(file_path, _id, target_group, polynomial):
    with open(file_path, mode='a') as f:
        f.write(
            ','.join([_id, target_group, polynomial]) + '\n'
        )
