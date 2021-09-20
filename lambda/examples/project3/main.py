import boto3
import json
from collections import OrderedDict

def lambda_handler(event, context):
    BUCKET_NAME = event['bucket_name'] #'yyawslearning2021'
    BUCKET_KEY = event['bucket_key'] #'raw-data.json'
    UPLOAD_BUCKET_KEY = event['upload_bucket_key']  #'transformed-data.json'

    s3_client = boto3.client('s3')
    obj = s3_client.get_object(Bucket=BUCKET_NAME, Key=BUCKET_KEY)
    input_data = json.loads(obj['Body'].read().decode('utf-8'))
    print(f'{BUCKET_NAME}: {input_data}')

    s3_resource = boto3.resource('s3')
    obj_output = s3_resource.Bucket(BUCKET_NAME).Object(UPLOAD_BUCKET_KEY)
    output_data = OrderedDict(file_name=UPLOAD_BUCKET_KEY, book_name="Hobbit", author=input_data['author'], year=(input_data['year'] + 1), genre="Juvenile fantasy")

    res = obj_output.put(Body=json.dumps(output_data))
    if res['ResponseMetadata']['HTTPStatusCode'] == 200:
        print(f'[SUCCESS] upload {UPLOAD_BUCKET_KEY}')
