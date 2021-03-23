# URL shortener service

Bit.ly like service that generates a REST API that handles generate, save, and retrieve urls from dynamodb.

## Deploy

To deploy, please follow instructions in deployment directory.

## Assumptions

General:

1. The service is public. We don't want to associate users with urls.
2. The urls do not expire.
3. The system should be fault tolerant, scalable, and highly available.

## Design

#### # Database Design

As we will be storing billions of record and as we do not need relationships between objects, we will be using a NoSQL database. For scalability purposes and to use a self managed database, we will be using DynamoDB and configure it to autoscale in our deployment.

Our database will use a hash key **shortenUrl** which is the generated random alphanumeric code. We are doing this in order to make reads and querying faster and to make use of consistent hashing on the attribute we care about the most.

DynamoDb is a key value store. Our key is shortenUrl. We will store the long url as a value in the document.

#### # URL Short code generation

Different methods were considered including:

1. Use a bijective function that is one to one and would allow to get the short url from the long url and the long url from the short url. This method was eliminated as it would result in high collision at scale.

2. Generate a random hash from the long url and store it in the database after making sure the hash does not exist already. (having shortenUrl as a primary key makes this process more efficient). This method is the implemented method.

3. Create a service that generates keys offline and stores the generated keys:

   - In memory (generated urls would be lost then but we might be able to allow that at scale)
   - In a cache like redis

   This service would also handle the writes to the database. One thing to note in here is that there can be only one service of this kind in our infrastructure. To make it highly available, we can have an active standby deployment.

#### # Microservices Diagram

The following diagram reflects the implemented system.

![Alt text](doc/url_shortener.png?raw=true "Architecture")

## Limitations

A better design is possible than the one implemented. However, due to time constraints, a simpler design was implemented.

## License

[MIT](https://choosealicense.com/licenses/mit/)
