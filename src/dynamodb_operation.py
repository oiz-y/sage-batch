import boto3
from boto3.dynamodb.conditions import Key


dynamodb = boto3.resource('dynamodb', region_name='ap-northeast-1')
conjugacy_rate_table = dynamodb.Table('sage-conjugacy-rate')
write_table = dynamodb.Table('sage-batch-write-table')


def get_group_data(degree):
    response = conjugacy_rate_table.query(
        KeyConditionExpression=Key('degree').eq(degree)
    )
    return response['Items']


def put_group_data(_id, group, polynomial):
    with write_table.batch_writer() as batch:
        batch.put_item(
            Item={
                'group': group,
                'id': _id,
                'polynomial': polynomial
            }
        )
