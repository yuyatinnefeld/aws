# Slack Notification
![GitHub Logo](/images/lambda-slack.png)
## Goal
Create a Lambda Application to send a notification to Slack

## Info
- https://qiita.com/ichi_zamurai/items/5758161f4d2523eabf2f

## Create Lambda Function

- name: myLambdaFunc
- runtime: python 3.8
- update code

```python
import json
import os
import requests

def lambda_handler(event, context):

    WEBHOOK_URL = os.environ['WEBHOOK_URL']
    WEBHOOK_NAME = os.environ['WEBHOOK_NAME']
    CHANNEL_NAME = os.environ['CHANNEL_NAME']

    data = {
            'username': WEBHOOK_NAME,
            'channel': CHANNEL_NAME,
            'attachments': [{
                'title': 'myLambdaFunc',
                "color": 'danger',
                'text': 'myLambdaFunc API was successful!!'
            }]
    }
    requests.post(WEBHOOK_URL, json.dumps(data))

    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }
```


## Create a slack API and activate the webhooks

https://api.slack.com/apps/

## Create 3 variables
- Function >  Configuration > Environment variables

```bash
CHANNEL_NAME: learning
WEBHOOK_NAME:lambda
WEBHOOK_URL:
https://hooks.slack.com/services/xxxxx
```

## Upload request Layer into Lambda (It didn't work > officail Arns Layer)
reason: to avoid getting the import requests error

1. create a requests library layer (local)

```bash
mkdir requests-layer
cd requests-layer
pip install requests -t . 
cd ../ && zip -r Layer.zip requests-layer/
```

2. Create a layer and Upload the Layzer.zip
- Lambda Menu > Layers > Create Layer
- name: myRequestsLayer
- description: requests library
- upload the zip file
- runtime: python3.8


## Use the offical ARN Layer for the requests package

- List:
https://github.com/keithrozario/Klayers/blob/master/deployments/python3.8/arns/eu-central-1.csv


## Add the layer in the function
- Function > Layers > Add a layer
- Specify an ARN layer
- arn:aws:lambda:eu-central-1:770693421928:layer:Klayers-python38-requests:20

## Run lambda test

## Create a Gateway API
- HTTP API > Build
- API Name: myLambdaFunc-API

## Lambda Trigger add
- API: myLambdaFunc-API
- Deployment stage: default
- security: open

## Open the Endpoint:
https://xxxxx.execute-api.eu-central-1.amazonaws.com/myLambdaFunc
