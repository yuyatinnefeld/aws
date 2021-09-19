# Job Scraper
![GitHub Logo](/images/lambda-slack.png)
## Goal
Build a Web Scraper With Python which scrapes the job offer website and list up the job offers

## Create a lambda function

### Setup
- name: myScrapeFuc
- runtime: python3.8

### Code
```python
import json
import requests
from bs4 import BeautifulSoup

def show_job_details(job_element):
    print("🚀  ##### JOB ##### 🚀 ")
    title_element = job_element.find("h2", class_="title")
    company_element = job_element.find("h3", class_="company")
    location_element = job_element.find("p", class_="location")
    print(title_element.text.strip())
    print(company_element.text.strip())
    print(location_element.text.strip())
    print()
        

def lambda_handler(event, context):
    URL = "https://realpython.github.io/fake-jobs/"

    page = requests.get(URL)
    soup = BeautifulSoup(page.content, "html.parser")
    results = soup.find(id="ResultsContainer")
    job_elements = results.find_all("div", class_="card-content")
    
    [show_job_details(job_element) for job_element in job_elements]


    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('scraper successful executed!')
    }
```

## Add 2 Layers
```bash
arn:aws:lambda:eu-central-1:770693421928:layer:Klayers-python38-beautifulsoup4:11
arn:aws:lambda:eu-central-1:770693421928:layer:Klayers-python38-requests:20
```