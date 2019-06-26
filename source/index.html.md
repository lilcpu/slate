---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

search: true
---

# Introduction

<span style="color:#32325D; font-size:25px; font-weight: 400; line-height: 40px;">Lifespan offers APIs for <span style="color:#08B7B7; font-weight: 600">driving financial wellness</span> and <span style="color:#08B7B7; font-weight: 600">expanding cards on file</span> in the exploding Subscription Economy.</span>

Lifespan is an end-to-end API for subscription management, discovery, and transactions. It's infrastructure that enables your cardholders to view, cancel, and add new subscription services frictionlessly within your web and mobile apps. You can integrate any feature individually or all together as a bundle.

The Lifespan API is organized around REST. Our API has predictable resource-oriented URLs, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs. You can use the Lifespan API in test mode, which does not affect live data.

![alt text](https://i.imgur.com/oRas4vj.png "Lifespan Layers")

# Security & Privacy

Security is priority number one at Lifespan. Our data footprint is kept to an absolute minimum. Sensitive data is never stored on Lifespan servers. We require explicit user opt-in anytime we need their data to perform a task. None of our APIs require data tied to a human identity; thus, data within Lifespan systems is always anonymized.

To protect data in transit, all communications between you and Lifespan are encrypted via SSL using 2048-bit certificates. We use <a href="https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security" target="_blank">HSTS</a> to ensure requests interact with Lifespan only over HTTPS. At rest, all of the anonymous data is encrypted with AES-256.

We use the standard OAuth 2.0 protocol for authentication and authorization. See <a href="#api-access">API Access</a> below for instructions to get keys.

# API Access

```shell
curl "https://api.lifespan.co/oauth/token"
  -H "Content-Type: application/x-www-form-urlencoded"
  -d "grant_type=client_credentials&client_id={YOUR_CLIENT_ID}&client_secret={YOUR_CLIENT_SECRET}"
```
> Sample Response

```json
HTTP/1.1 200 OK
Content-Type: application/json
{
  "access_token": "eyJz93a...k4laUWw",
  "token_type": "Bearer",
  "expires_in": 86400
}
```
The Lifespan API implements the <a href="https://www.oauth.com/oauth2-servers/access-tokens/client-credentials/" target="_blank">OAuth 2.0 client credentials grant flow.</a> There are a few steps to get set up with keys:

1. Send us an email at __api@lifespan.co__ to request credentials for your organization.
2. We'll send you a `client_id` and a `client_secret`. __Save these somewhere secure.__
3. Request an `access_token` (see example).

After you receive an `access_token` store it in your database for future use. When making requests to the Lifespan API you __must__ include the token in the authorization header like so: `Authorization: Bearer {token}`

<aside class="notice">
You must replace <code>token</code> with your personal API key.
</aside>

# Errors

The Lifespan API uses the following error codes:


Error Code | Meaning
---------- | -------
400 | Bad Request -- Your request is invalid.
401 | Unauthorized -- Your API key is wrong.
403 | Forbidden -- The resource requested is not available to you.
404 | Not Found -- The specified resource could not be found.
405 | Method Not Allowed -- You tried to access a resource with an invalid method.
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.

# Building User Experience

You will build a consumer-facing user experience directly into your web or mobile application. Below are a few suggestions and examples of how you might build your front-end components and the flows that connect them, but ultimately the choice is yours as for how to best present data and functionality to users.

## Displaying Recurring Payments, Cancellation Buttons, and Recommendations

Display the results of a call to the <a href="#recurring-payments">Recurring Payments API</a> in a list. If you're using the <a href="#cancellations">Cancellations API</a>, add a one-way switch or cancel button to each list element. If you're using the <a href="#recommendations">Recommendations API</a>, display the recommendations returned from your call in a module below the user's current recurring payments.

![alt text](https://i.imgur.com/XvHUjmi.png "Displaying Recurring Payments and Recommendations Modules")

## Displaying the Cancellation Modal

Upon clicking or tapping a cancellation button, render a popup modal prompting the user for their email associated with the given service. The modal should appear over the list of recurring services.
 
![alt text](https://i.imgur.com/XAB4vD7.png "Cancellation Modal")

## Visualizing Monthly Payments

Donut charts are a great way to visualize monthly data. Show the total monthly spend in the center. Users should be able to hover over or click each section of your chart to view full details. Consider including a legend for added clarity.

![alt text](https://i.imgur.com/n8FUqnI.png "Pie chart breakdown of a user's monthly spend")
# Financial Wellness

Lifespan offers two APIs that enable cardholders to view and cancel recurring payments.

 The <a href='#recurring-payments'>Recurring Payments API</a> allows developers to find a user's recurring transactions from a full transaction history. It returns a list of all found recurring payments and their prices. This information can be used to provide a breakdown of the user's monthly recurring spend.

The <a href='#cancellations'>Cancellation API</a> can be leveraged in tandem with the results of the Recurring Payments API to enable users to cancel any recurring service from within your application, as opposed to experiencing various merchants' potentially convoluted cancellation processes. Lifespan will contact the merchant to initiate the cancelation and return an ID that can be used to track status. Your user will be updated via email.

# Recurring Payments

## Get All Recurring Payments from a Transaction History

```shell
curl -d '{
    "transactions":[ 
      {
        "amount":12.99,
        "name":"spotify",
        "date":"2019-05-16"
      },
      {
        "amount":15.99,
        "name":"netflix",
        "date":"2019-05-16"
      },
      ...
    ]}' 
    -H "Content-Type: application/json"
    -H "Authorization: {token}" 
    -X POST https://api.lifespan.co/services
```

> The above command returns JSON structured like this:

```json
{
  "requestId":1234,
  "services" : [
      {
        "name": "Spotify",
        "price": 1299
      },
      {
        "name": "Netflix",
        "price": 1599
      },
    ]
}
```

This endpoint returns a <span style="color:#cd3d64;">`requestId`</span> and a list of all recurring payments found in a transaction history for a given card account. Each result will include the merchant <span style="color:#cd3d64;">`name`</span> and the <span style="color:#cd3d64;">`price`</span> of the service. Use negative <span style="color:#cd3d64;">`amount`</span> values for account credits and positive values for charges. The <span style="color:#cd3d64;">`price`</span> field of the returned services is always in cents.

### HTTP Request

`POST https://api.lifespan.co/services`

### Payload

Parameter | Description
--------- | -----------
transactions <span style="color:#8792a2; font-size:12px;">array</span> | A JSON-stringified array of transactions. __Must include amount, date and name fields__ <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

## Get New Recurring Payments from a Transaction History of an Existing User

```shell
curl -d '{
    "requestId": 1234,
    "transactions":[ 
      {
        "amount":12.99,
        "name":"spotify",
        "date":"2019-05-16"
      },
      {
        "amount":15.99,
        "name":"netflix",
        "date":"2019-05-16"
      },
      ...
    ]}' 
    -H "Content-Type: application/json"
    -H "Authorization: {token}" 
    -X POST https://api.lifespan.co/services/updates
```

> The above command returns JSON structured like this:

```json
{
  "services" : [
      {
        "name": "HBO",
        "price": 1499
      },
      {
        "name": "Hulu",
        "price": 1299
      },
    ]
}
```

This endpoint returns a list of all _new_ recurring payments found in a _new_ transaction history for a user who has already been processed in the Recurring Payments API. You should submit new transaction data to this endpoint periodically (preferably monthly) in order to stay up to date with your user's new subscription enrollments.

Each result will include the merchant <span style="color:#cd3d64;">`name`</span> and the <span style="color:#cd3d64;">`price`</span> of the service. Use negative <span style="color:#cd3d64;">`amount`</span> values for account credits and positive values for charges. The <span style="color:#cd3d64;">`price`</span> field of the returned services is always in cents.

### HTTP Request

`POST https://api.lifespan.co/services/updates`

### Payload

Parameter | Description
--------- | -----------
requestId <span style="color:#8792a2; font-size:12px;">integer</span> | the `requestId` returned by the inital call to `/services` for this user <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
transactions <span style="color:#8792a2; font-size:12px;">array</span> | A JSON-stringified array of transactions. __Must include amount, date and name fields__ <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

# Cancellations

## Get Cancellation Information For a Subscription

```shell
curl -d '{
    "merchantName":"Spotify", 
    "merchantState":"NY", 
    "merchantCity":"New York",
    "merchantZip":"90028"}' 
    -H "Content-Type: application/json"
    -H "Authorization: {token}" 
    -X POST https://api.lifespan.co/cancellations
```

> The above command returns JSON structured like this:

```json
{
  "id": 1234,
  "status": "initiated"
}
```

This endpoint takes in a merchant name and merchant address info. Lifespan will identify and return instructions for the cancellation process of the given merchant. This process usually takes no more than 24 hours and in some cases lifespan can return this information instantly. See the example response of <span style="color:#cd3d64;">`/cancellations/id`</span> for an example of the payload returned for a completed cancellation info request.

### HTTP Request

`POST https://api.lifespan.co/cancellations`

### Payload

Parameter | Description
--------- | -----------
merchantName <span style="color:#8792a2; font-size:12px;">string</span> | The name of the subscription merchant the user would like to cancel. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
merchantState <span style="color:#8792a2; font-size:12px;">string</span> | The state of the subscription merchant the user would like to cancel. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
merchantCity <span style="color:#8792a2; font-size:12px;">string</span> | The city of the subscription merchant the user would like to cancel. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
merchantZip <span style="color:#8792a2; font-size:12px;">string</span> | The zip code of the subscription merchant the user would like to cancel. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

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
  "id": 1234,
  "merchantName": "Spotify",
  "merchantState":"NY", 
  "merchantCity":"New York",
  "merchantZip":"90028",
  "status": "completed",
  "type": "phone",
  "contactDetails": "1234567890"
}
```

This endpoint returns the details of a given cancellation id.

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

Giving cardholders the ability to track and cancel recurring payments not only enhances your product experience, it also lays the foundation for monetization. It unlocks an opportunity to recommend new services based on data, with your card automatically going on file upon each conversion. As the subscription economy <a href="https://www.mckinsey.com/industries/high-tech/our-insights/thinking-inside-the-subscription-box-new-research-on-ecommerce-consumers" target="_blank">continues to grow </a>, use our APIs to actively drive increasing and reliable interchange revenue.

# Recommendations

## Get Recommended Services for a User

```shell
curl -X POST https://api.lifespan.co/recommendations
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
         "offer": "30% off first 3 months",
         "offerUrl":"https://nyt.com/code"
     },
     {
         "service": "Postmates Unlimited",
         "offer": "3 months free",
         "offerUrl":"https://postmates.com/code"
     },
     {
         "service": "Rent the Runway",
         "offer": "$80 off first 2 months",
         "offerUrl":"https://renttherunway.com/code"
     },
     {
         "service": "The Farmer's Dog",
         "offer": "20% off first month",
         "offerUrl":"https://thefarmersdog.com/code"
     },
     {
         "service": "Birchbox",
         "offer": "20% off first 3 months",
         "offerUrl":"https://birchbox.com/code"
     }
}
```

This endpoint takes in a user's current <span style="color:#cd3d64;">`subscriptions`</span>, <span style="color:#cd3d64;">`gender`</span>, <span style="color:#cd3d64;">`age`</span>, and <span style="color:#cd3d64;">`zip`</span> code. The response is an array of objects consisting of the name of each recommended service, a description of its corresponding offer, and the affiliate link for your user to claim the offer through. The objects are ranked in order of user conversion probability as scored by our recommendations algorithm, so we encourage you to display the results in the order in which you receive them.

### HTTP Request

`POST https://api.lifespan.co/recommendations`

### Payload

Parameter | Description
--------- | -----------
subscriptions <span style="color:#8792a2; font-size:12px;">array</span> | List of user's current subscription services. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
gender <span style="color:#8792a2; font-size:12px;">string</span> | User's gender. Value can either be <span style="color:#cd3d64;">`Male`</span> or <span style="color:#cd3d64;">`Female`</span>. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
age <span style="color:#8792a2; font-size:12px;">integer</span> | User's age in years. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
zip <span style="color:#8792a2; font-size:12px;">integer</span> | Zip code of user's residence. Must be a valid United States code. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

![alt text](https://i.imgur.com/B2AQGK1.png "Recommendations")

# Transactions
<small><span style="color:#09b7b7; font-size:14px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Coming Winter 2019<span></small>
<br>
<br>

Thus far, the Lifespan API has enabled banks to offer their cardholders two core value propositions:

1. Management of current subscriptions
2. Discovery of new, recommended services

Facilitating the actual transaction is the natural next step.

The Lifespan Transactions API enables consumers to start new services with the push of a button, as well as maintain uninterrupted service with ongoing card-on-file merchants throughout card changes. 

Upon a card change or new transaction event, Lifespan receives an encrypted payload of the user’s payment information from the user’s issuing bank and makes it accessible to merchant(s). As the new transaction occurs successfully, confirmations are sent back to the bank and consumer.

# Merchants

## Upload or Update a SKU

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

This endpoint takes in attributes of a subscription service to upload (POST) or update (PUT). It returns an object with a 200 status code if the call succeeded.

### HTTP Request

`POST https://api.lifespan.co/merchants`

`PUT https://api.lifespan.co/merchants`

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