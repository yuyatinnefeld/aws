# Mini ETL Process

## Goal
Build a Data transform program with Python Lambda function which reads raw CSV data from S3 Bucket, transform the data with pandas and store the result into S3 Bucket

## Create a S3 Buckets
input: s3://yyawslearning2021/input/
output: s3://yyawslearning2021/output/

## Create a lambda function
- name: s3dataAggregate
- runtime: python3.8

## Code

```python
import json
import urllib.parse
import boto3
import pandas as pd
from io import StringIO

print('Loading function')

    
def read_file(s3, bucket_name, file_name):
    obj = s3.get_object(Bucket=bucket_name, Key=file_name)
    #obj = s3_resource.Object(bucket_name, file_name)
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

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    file_name = 'input/raw-data.csv'
    bucket_name='yyawslearning2021'

    #####
    # TODO: CHANGE CONNECTION ERROR FIX
    raw_data_bytes = read_file(s3, bucket_name, file_name)
    df = convert_bytes_to_df(raw_data_bytes)
    df = clean_data(df)
    avg = df.groupby(['Team']).mean()
    print(avg)
    #####
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

```


## Add a S3 trigger
- select only the bucket name


## Add 2 Layers for pandas
arn:aws:lambda:eu-central-1:770693421928:layer:Klayers-python38-pandas:39
