import logging


logging.basicConfig(level=logging.INFO)


def info_log(key, value):
    logging.info(f'{key}: {value}')


def error_log(key, value):
    logging.error(f'{key}: {value}')
