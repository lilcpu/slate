---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

includes:
  - errors

search: true
---

# Introduction

<span style="color:#32325D; font-size:28px; font-weight: 400; line-height: 42px;">APIs for <span style="color:#08B7B7; font-weight: 600">driving financial wellness</span> and <span style="color:#08B7B7; font-weight: 600">expanding cards on file</span> in the exploding Subscription Economy</span>

Lifespan is an end-to-end API for subscription management, discovery, and transactions. It's infrastructure that enables your cardholders to view, cancel, and add new subscription services frictionlessly within your web and mobile apps.

The Lifespan API is organized around REST. Our API has predictable resource-oriented URLs, accepts form-encoded request bodies, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs. You can use the Lifespan API in test mode, which does not affect live data.

# Security & Privacy

Security is paramount at Lifespan. As such, our data footprint is kept to an absolute minimum. Sensitive data is never stored on Lifespan servers, data is encrypted in transit and any time we need access to sensitive data from your user we __require__ the handshake (and the actionable result of said handshake) be made explicitly clear to your users. Check out the <a href="#">styleguide</a> for examples of security screens and messages.

We use standard OAuth 2.0 protocol for authentication and authorization. See the <a href="#api-access">API Access</a> below to get keys. Additionaly, our apis only communicate via https to gaurd against man-in-the-middle attacks and other methods of tampering with the communication between your servers and our API.

<<<<<<< HEAD
# Authentication
=======

# API Access
>>>>>>> a4dad04de278d102d5a1b6097b5b01796c34058a

```shell
curl "api.lifespan.co/oauth/token"
  -H "Content-Type: application/x-www-form-urlencoded"
  -d "grant_type=client_credentials&client_id={YOUR_CLIENT_ID}&client_secret={YOUR_CLIENT_SECRET}"
```
> Sample Response

```json
HTTP/1.1 200 OK
Content-Type: application/json
{
  "access_token":"eyJz93a...k4laUWw",
  "token_type":"Bearer",
  "expires_in":86400
}
```
The Lifespan API implements the <a href="https://www.oauth.com/oauth2-servers/access-tokens/client-credentials/">OAuth 2.0 client credentials grant flow.</a> There are a few steps to get set up with keys:

1. Send us an email at __api@lifespan.co__ to request credentials for your organization.
2. We'll send you a `client_id` and a `client_secret`. __Save these somewhere secure. Preferrably in a file or store with limited permissions__.
3. Request an `access_token` (see example)

After you recieve an `access_token` you __must__ include it in the authorization header of each request to the Lifespan API like so: 
`Authorization: Bearer {token}`

<aside class="notice">
You must replace <code>token</code> with your personal API key.
</aside>

# Building User Experience

You will build a consumer facing user experience directly into your web or mobile application. Because you own your application's frontend there are a plethora of implementations that may make sense for your use case. We offer a styleguide with suggestions and examples of how you might build your components and the flows that connect them, but ultimately the choice is in your hands of how to best present data and functionality to your users.

# Financial Wellness

Lifespan offers two APIs intended to allow developers the ability to deliver a data driven client dashboard which informs the user of thier financial wellness as it relates to recurring payments; then take action on that information. The <a href='#recurring-payments'>Recurring Payments API</a> allows developers to find a user's recurring transactions from a full transaction history. It returns a list of all found recurring payments and their prices. This information can be used to provide a breakdown of the user's monthly recurring spending.

The <a href='#cancellations'>Cancellation API</a> can be leveraged in tandem with the results of the Recurring Payments API to allow users to the ability to cancel any services found directly from your application; rather than from the service merchant's potentially convoluted cancellation flow. Provide a button or a toggle along side each entry in the list returned by the Recurring Payments API and make a call with the user's email and the merchants name. Lifespan will initiate a cancelation and return an id that can be used to track status. Your user will be updated via email and you may make a call to check for updates on the status of that cancellation. The Cancellation API provides a simple interface for you to provide your user with agency over thier recurring payments.

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

This endpoint takes in a merchant name and the email of the user that would like to cancel their subscription. This email __must__ be the email in use at the service in question. The cancellation will be initiated and that user will receive email updates on the cancellation status as it progresses. Usually no more than 24 hours.

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
id <span style="color:#8792a2; font-size:12px;">integer</span> | The ID of the cancellation. This is provided in the response to a POST request to <span style="color:#cd3d64;">`/cancellations`</span>. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

# Commerce

# Recommendations

## Get Recommended Services for a User

```shell
curl -X GET https://api.lifespan.co/recommendations
    -H "Authorization: {token}"
    -H "Content-Type: application/json"
    -d '{
         "subscriptions": [
            "Hulu",
            "Amazon Prime",
            "Ipsy",
            "Lola",
            "Barkbox"
         ],
         "gender": "Female",
         "age": 30,
         "zip": 94539
       }' 
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

This endpoint takes in a user's current subscriptions, gender, age, and zip code. The response is an array of objects consisting of the name of each recommended service and its corresponding offer. The objects are ranked in order of user conversion probability as scored by our recommendations algorithm, so we encourage you to display the results in the order in which you receive them.

### HTTP Request

`GET https://api.lifespan.co/recommendations`

### Payload

Parameter | Description
--------- | -----------
subscriptions <span style="color:#8792a2; font-size:12px;">array</span> | List of user's current subscription services. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
gender <span style="color:#8792a2; font-size:12px;">string</span> | User's gender. Value can either be <span style="color:#cd3d64;">`Male`</span> or <span style="color:#cd3d64;">`Female`</span>. <span style="color:#8792a2; font-size:12px; font-weight: 500;">optional</span>
age <span style="color:#8792a2; font-size:12px;">integer</span> | User's age in years. <span style="color:#8792a2; font-size:12px; font-weight: 500;">optional</span>
zip <span style="color:#8792a2; font-size:12px;">integer</span> | Zip code of user's residence. Must be a valid United States code. <span style="color:#8792a2; font-size:12px; font-weight: 500;">optional</span>

<aside class="success">
Don't forget your authentication key
</aside>

![alt text](https://i.imgur.com/B2AQGK1.png "Recommendations")

# Merchants

## Upload a SKU

```shell
curl -X POST https://api.lifespan.co/merchants
    -H "Authorization: {token}"
    -H "Content-Type: application/json"
    -d '{
         "name": "YouTubeTV",
         "website": "https://tv.youtube.com"
         "logo": "https://tv.youtube.com/logo",
         "gender": "All",
         "plans": [
            {
               "name": "Standard",
               "price": 40.00,
               "interval": "month",
               "includes": [
                  "DVR with unlimited storage",
                  "Local and national live sports",
                  "6 accounts per household",
                  "3 simultaneous streams"
               ],
               "regions": ["United States"]
            }
         ],
         "offers": [
            {
               "description": "7 days free",
               "qualifiers": null
            },
            {
               "description": "1 month free",
               "qualifiers": ["HBO Now", "Hulu", "Netflix"]
            },
            {
               "description": "2 months free",
               "qualifiers": ["SlingTV", "DirectTV", "DishTV"]
            }
         ]
       }' 
```

> The above command returns JSON structured like this:

```json
   {
      "status": 200,
      "description": "SKU successfully uploaded"
   }
```

This endpoint takes in attributes of a subscription service. It returns an object with a 200 status code if the call succeeded.

### HTTP Request

`POST https://api.lifespan.co/merchants`

### Payload

Parameter | Description
--------- | -----------
name <span style="color:#8792a2; font-size:12px;">string</span> | Name of subscription service. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
website <span style="color:#8792a2; font-size:12px;">string</span> | Website URL. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
logo <span style="color:#8792a2; font-size:12px;">string</span> | URL to hosted logo. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required<span>
gender <span style="color:#8792a2; font-size:12px;">string</span> | The gender of the service's target demographic. Values can be either <span style="color:#cd3d64;">`Male`</span>, <span style="color:#cd3d64;">`Female`</span>, or <span style="color:#cd3d64;">`All`</span>. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
plans <span style="color:#8792a2; font-size:12px;">array</span> | An array of objects, with each object representing a plan. The plan object contains the following required information: the <span style="color:#cd3d64;">`name`</span> <span style="color:#8792a2; font-size:12px;">(string)</span> of the service, its <span style="color:#cd3d64;">`price`</span> <span style="color:#8792a2; font-size:12px;">(integer)</span> in USD, the billing <span style="color:#cd3d64;">`interval`</span> <span style="color:#8792a2; font-size:12px;">(string)</span>, a list of benefits and/or features the service <span style="color:#cd3d64;">`includes`</span> <span style="color:#8792a2; font-size:12px;">(array)</span> and a list of U.S. <span style="color:#cd3d64;">`regions`</span><span style="color:#8792a2; font-size:12px;">(array)</span> - cities or states - that the plan is available in. Send <span style="color:#cd3d64;">`"regions": ["United States"]`</span> if nationwide or <span style="color:#cd3d64;">`["Continental United States"]`</span> if available everywhere but Alaska and Hawaii. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required<span>
offers <span style="color:#8792a2; font-size:12px;">array</span> | An array of objects, with each object representing an offer. The offer object contains 1. a <span style="color:#cd3d64;">`description`</span> <span style="color:#8792a2; font-size:12px;">(string)</span> of the offer. 2. A list of <span style="color:#cd3d64;">`qualifiers`</span> <span style="color:#8792a2; font-size:12px;">(array)</span>. Qualifiers are subscriptions a target user may be engaged with currently which indicate interest in your category or engagement with competing services; thus __qualifying__ them for a specific offer. If the offer is available to anyone regardless of their current subscriptions, send <span style="color:#cd3d64;">`"qualifiers": null`</span> (the default value). <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required<span>

<aside class="success">
Don't forget your authentication key
</aside>

# Transactions (Coming Soon)

Lifespan Transactions API enables frictionless transactions between cardholders and subscription merchants. Banks will be able to rapidly expand cards on file by tapping into one of the fastest growing segments of ecommerce (McKinsey report) via one simple and secure API.

Thus far, the Lifespan API has enabled banks to offer their cardholders two core value propositions: 1) management of current subscriptions and 2) discovery of new, recommended services. Facilitating the actual transaction is the natural next step.

We are making the transaction experience as frictionless as possible, utilizing best in class technology. Consumers will simply push a button to start a new trial or subscription service seamlessly. Merchants will receive the required user and payment information (your card) for a new sign up.

We prioritize security throughout and are excited to integrate management, discovery, and transactions all into one beautiful unified experience.