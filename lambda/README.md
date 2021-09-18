# AWS Lambda


## About
AWS Lambda is n event-driven serverless compute service that lets you run code without provisioning or managing servers, creating workload-aware cluster scaling logic. 

### Serverless
- No infrastructure provisining, no management
- Automatic scaling and load balancing
- Pay for value
- HA and secure

### Lambda Function
- Node.js
- Python
- Java
- #C
- Go
- Ruby
- Runtime API

### Lambda function components
- Handler function: function to be executed upon invocation
- Event object: data sent during Lambda function invocation
- Context object (meta data): methods available to interact with runtime information (request ID, log group, etc.)

### Cons
- Java and #C are very slow. With both C# and Java, Lambda has to do a lot of extra work during a cold start. The typical finding is that Python, Node.js, and Go, have far superior cold start performances compared to C# and Java. 

- Instance Memory is limited 128MB〜1.5G

### Lambda execution model
- Sync model (push-based)
- Aync model (event-based)
- Streaming model (poll-based)

### Pricing 
charged based on 
- the number of requests for your functions and
- the duration, the time it takes for your code to execute (the most part of cost)
    - !!! be careful to use Lambda for the long time duration program !!!

Duration is calculated from the time your code begins executing until it returns or otherwise terminates, rounded up to the nearest 1ms*. 

- $0.20 per 1M requests
- $0.0000166667 for every GB-second

#### Example A:
- Request = 2,000,000 times
- Memory = 512（MB)
- 2 sec per Execution

Calculation:
- Execution Time = 2,000,000 times * 2 sec = 4,000,000 sec
- Sec * GB = Execution Time * GB = 4,000,000 sec * 512（MB）/ 1024（MB）= 2,000,000（sec・GB)

1. Request Cost = (sec * GB) * ($0.2 / 1,000,000) = 2M * $0,2 = 0,4 USD
2. Duration Cost = 0.0000166667 * (sec * GB) = 0.0000166667 * 2,000,000 = 33,33 USD
3. Total Cost = 0,4 + 33,33 = 33, 74 USD

#### Example B:
- Request = 3,000,000 times
- Memory = 512（MB)
- 1 sec per Execution

Calculation:
- Execution Time = 3,000,000 * 1 sec = 3,000,000 sec
- Sec * GB = 3,000,000 * 512 / 1024 = 1,500,000

1. Request Cost = 1,500,000 * ($0.2 / 1,000,000) = 0,3 USD
2. Duration Cost = 0.0000166667 * 1,500,000 = 25 USD
3. Total Cost = 0,3 + 25 = 25,03 USD