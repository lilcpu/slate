---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='#'>Request a Developer Key</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Lifespan API. You can use our API to access Lifespan API endpoints, which can get information on various subscription services, categories, and tools to analyze transaction statements to identify or recommend services to your users.

The Lifespan API is organized around REST. Our API has predictable resource-oriented URLs, accepts form-encoded request bodies, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs.

You can use the Lifespan API in test mode, which does not affect live data.

# Authentication

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: {token}"
```

<aside class="notice">
You must replace <code>token</code> with your personal API key.
</aside>

# Recurring Payments

## Get All Recurring Payments in a Transaction History

```shell
curl -d '{"transactions":"<transactionHistoryJSONString>"}' 
    -H "Content-Type: application/json"
    -H "Authorization: {token}" 
    -X POST https://api.lifespan.co/services
```

> The above command returns JSON structured like this:

```json
{
  "services" : {
    "RgyPLBjx0qiJ1y5zB0gkc8P3qgE5dPIymdrYB" : [
      {
        "name": "Spotify",
        "price": 1299
      }
    ]
  }
}
```

This endpoint returns a list of all recurring payments found in a given transaction history. They are organized by accountId which is a plaid construct to securley mask sensitive details of an account. The `price` field of the returned services is always in cents.

### HTTP Request

`POST https://api.lifespan.co/services`

### Payload

Parameter | Description
--------- | -----------
transactions <span style="color:#8792a2; font-size:12px;">array</span> | A JSON-stringified array of transactions. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

# Cancellations

## Cancel a Subscription

```shell
curl -d '{"merchantName":"Spotify", "userEmail": "thanos@lifespan.co"}' 
    -H "Content-Type: application/json"
    -H "Authorization: {token}" 
    -X POST https://api.lifespan.co/cancellations
```

> The above command returns JSON structured like this:

```json
{
  "status": "initiated",
  "id": 1234
}
```

This endpoint takes in a merchant name and the email of the user that would like to cancel their subscription. This email __must__ be the email in use at the service in question. The cancellation will be initiated and that user will recieve email updates on the cencellation status as it progresses. Usually no more than 24 hours.

### HTTP Request

`POST https://api.lifespan.co/cancellations`

### Payload

Parameter | Description
--------- | -----------
merchantName <span style="color:#8792a2; font-size:12px;">string</span> | The name of the subscription merchant the user would like to cancel. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
userEmail <span style="color:#8792a2; font-size:12px;">string</span> | The email address of the user that would like to cancel the subscription. This email must be the one associated with the user's account with the merchant. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

![alt text](https://i.imgur.com/FFuV3Rp.png "Cancellations")

## Get the Details of a Specific Cancellation

```shell
curl "https://api.lifespan.co/cancellations/1234"
  -H "Authorization: {token}"
```

> The above command returns JSON structured like this:

```json
{
  "status": "completed",
  "id": 1234
}
```

This endpoint returns the status of a given cancellation id.

### HTTP Request

`GET https://api.lifespan.co/cancellations/<id>`

### Payload

Parameter | Description
--------- | -----------
id <span style="color:#8792a2; font-size:12px;">number</span> | The ID of the cancellation. This is provided in the response to a POST request to <span style="color:#cd3d64;">`/cancellations`</span>. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

# Recommendations

## Get Recommended Services for a User

```shell
curl -d '{"gender": "Female", "age": 30, "zip": 94539, "subscriptions": ["Hulu", "Amazon Prime", "Ipsy", "Lola", "Barkbox"]}' 
    -H "Content-Type: application/json"
    -H "Authorization: {token}" 
    -X GET https://api.lifespan.co/recommendations
```

> The above command returns JSON structured like this:

```json
{
  "recommendations": [
     {
         "service": "New York Times",
         "offer": "30% off first 3 months"
     },
     {
         "service": "Postmates Unlimited",
         "offer": "3 months free"
     },
     {
         "service": "Rent the Runway",
         "offer": "$80 off first 2 months"
     },
     {
         "service": "The Farmer's Dog",
         "offer": "20% off first month"
     },
     {
         "service": "Birchbox",
         "offer": "20% off first 3 months"
     }
}
```

This endpoint takes in a user's gender, age, zip code, and current subscriptions. The response is an array of objects consisting of the name of each recommended service and its corresponding offer. The objects are ranked in order of user conversion probability as scored by our recommendations algorithm, so we encourage you to display the results in the order in which you receive them.

### HTTP Request

`GET https://api.lifespan.co/recommendations`

### Payload

Parameter | Description
--------- | -----------
gender <span style="color:#8792a2; font-size:12px;">string</span> | User's gender. Value can either be <span style="color:#cd3d64;">`Male`</span> or <span style="color:#cd3d64;">`Female`</span>. <span style="color:#8792a2; font-size:12px; font-weight: 500;">optional</span>
age <span style="color:#8792a2; font-size:12px;">number</span> | User's age in years. <span style="color:#8792a2; font-size:12px; font-weight: 500;">optional</span>
zip <span style="color:#8792a2; font-size:12px;">number</span> | Zip code of user's residence. Must be a valid United States code. <span style="color:#8792a2; font-size:12px; font-weight: 500;">optional</span>
subscriptions <span style="color:#8792a2; font-size:12px;">array</span> | List of user's current subscription services. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

![alt text](https://i.imgur.com/B2AQGK1.png "Recommendations")

