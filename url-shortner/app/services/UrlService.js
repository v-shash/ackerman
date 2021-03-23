var AWS = require('aws-sdk');
const _ = require("lodash")


const DYNAMO_DB_TABLE_NAME = process.env.DB_TABLE_NAME;

if (_.isEmpty(DYNAMO_DB_TABLE_NAME)) {
    console.log("Invalid DYNAMO_DB_TABLE_NAME. Exiting")
    process.exit(1);
  }


var docClient = new AWS.DynamoDB.DocumentClient();


class UrlService {
    tableName = DYNAMO_DB_TABLE_NAME
    generator = null

    constructor(generator) {
        this.generator = generator
    }

    async getOne(shortenedUrl) {
        const params = {
            TableName: this.tableName,
            Key: {
                "shortenUrl": shortenedUrl
            }
        }

        const urlObjFromDb = await docClient.get(params).promise().catch((error) => {
            console.log("Failed to get Shortened Url object from dynamodb with error", error);
        })

        return urlObjFromDb

    }

    async saveOneIfAbsent(shortUrl, longUrl) {
        let success = false;

        const params = {
            TableName: this.tableName,
            Item: {
                "shortenUrl": shortUrl,
                "url": longUrl
            }
        }

        // check if already exists
        const existingUrlObj = await this.getOne(shortUrl);

        if (_.isEmpty(existingUrlObj)) {
            await docClient.put(params).promise().then(result => {
                success = true
            }).catch((error) => {
                console.log("Failed to put save new Url object to dynamodb error", error);
                success = false
            })

        }

        return success
    }

    async getANewUrl(longUrl) {
        let ret = null
        let newUrlFound = false

        // retry ten times if can't find a unique id
        for (let i = 0; i < 10; i++) {
            let potentialNewUrl = this.generator()

            const success = await this.saveOneIfAbsent(potentialNewUrl, longUrl)


            if (success) {
                newUrlFound = true
                ret = {
                    "shortenUrl": potentialNewUrl,
                    "url": longUrl
                }
            }

            if (newUrlFound) {
                break;
            }
        }

        return ret

    }

}


const nanoid = require("nanoid");
const nanoidDict = require("nanoid-dictionary");

const newUrlGenerator = nanoid.customAlphabet(nanoidDict.alphanumeric, 9);

// singleton
module.exports = new UrlService(newUrlGenerator)