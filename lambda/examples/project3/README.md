# Mini ETL Process

## Goal
Build a Data transform program with Python Lambda function which reads raw CSV data from S3 Bucket, transform the data with pandas and store the result into S3 Bucket.

## Example 1
### Create a S3 Bucket
input: s3://yyawslearning2021

### Upload the json file
s3://yyawslearning2021/raw-data.json

### Create a lambda function
- Authoer from scratch
- name: s3-json-transform
- runtime: python3.8

### Code

```python
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
```

### Create a Test Event
name: myTestEvent
```json
{
  "bucket_name": "yyawslearning2021",
  "bucket_key": "raw-data.json",
  "upload_bucket_key": "transformed-data.json"
}
```

### Change the role permission
- Config > General > Edit > Existing role > View the s3-json-transform-role
- Role page > Attach policies
- AmazonS3FullAccess (or only the bucket access)

### Run Test and Verify the S3 object
s3://yyawslearning2021/transformed-data.json

## Example 2
## Upload the csv file
s3://yyawslearning2021/raw-data.csv

### Create a lambda function
- Authoer from scratch
- name: s3-csv-transform
- runtime: python3.8

### Add an ARN Layer for pandas
arn:aws:lambda:eu-central-1:770693421928:layer:Klayers-python38-pandas:39
### Code

```python
import json
import urllib.parse
import boto3
import pandas as pd
from io import StringIO


def read_file(s3_resource, bucket_name, bucket_key):
    obj = s3_resource.Object(bucket_name, bucket_key)
    print(obj)
    body = obj.get()['Body'].read()
    return body

def convert_bytes_to_df(raw_data_bytes:bytes):
    raw_data_string = str(raw_data_bytes,'utf-8')
    data = StringIO(raw_data_string) 
    df=pd.read_csv(data)
    return df

def clean_data(df):
    nan_value = float("NaN")
    df.replace("", nan_value, inplace=True)
    df.dropna(subset = ["Salary"], inplace=True)
    return df
    
def save_to_s3(s3_client, df, bucket_name, upload_bucket_key):
    csv_buffer=StringIO()
    df.to_csv(csv_buffer)
    content = csv_buffer.getvalue()
    s3_client.put_object(Bucket=bucket_name, Body=content, Key=upload_bucket_key)
    

def lambda_handler(event, context):
    s3_resource = boto3.resource('s3')
    s3_client = boto3.client('s3')

    BUCKET_NAME = event['bucket_name'] #'yyawslearning2021'
    BUCKET_KEY = event['bucket_key'] #'raw-data.csv'
    UPLOAD_BUCKET_KEY = event['upload_bucket_key']  #'transformed-data.csv'

    raw_data_bytes = read_file(s3_resource, BUCKET_NAME, BUCKET_KEY)
    df = convert_bytes_to_df(raw_data_bytes)
    print("raw data: ", df)
    df = clean_data(df)
    tranformed_df = df.groupby(['Team']).mean()
    print("transformed data: ", tranformed_df)
    save_to_s3(s3_client, tranformed_df, BUCKET_NAME, UPLOAD_BUCKET_KEY)

```
### Change the default run timt 
3 sec > 6 sec


### Create a Test Event
name: myTestEvent
```json
{
  "bucket_name": "yyawslearning2021",
  "bucket_key": "raw-data.csv",
  "upload_bucket_key": "transformed-data.csv"
}
```

### Change the role permission
- Config > General > Edit > Existing role > View the s3-json-transform-role
- Role page > Attach policies
- AmazonS3FullAccess (or only the bucket access)

### Run Test and Verify the S3 object
s3://yyawslearning2021/transformed-data.csv
