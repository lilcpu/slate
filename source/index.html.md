---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

includes:
  - errors

search: true
---

# Introduction

Welcome to the Lifespan API. You can use our API to access Lifespan API endpoints, which can get information on various subscription services, categories, and tools to analyze transaction statements to identify or recommend services to your users.

The Lifespan API is organized around REST. Our API has predictable resource-oriented URLs, accepts form-encoded request bodies, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs.

You can use the Lifespan API in test mode, which does not affect live data.

## Building User Experience

You will build a consumer facing user experience directly into your web or mobile application. Because you own your application's frontend there are a plethora of implementations that may make sense for your use case. We offer a styleguide with suggestions and examples of how you might build your components and the flows that connect them, but ultimately the choice is in your hands of how to best present data and functionality to your users.

## Security & Privacy

Security is paramount at Lifespan. As such, our data footprint is kept to an absolute minimum. Sensitive data is never stored on Lifespan servers, data is encrypted in transit and any time we need access to sensitive data from your user we __require__ the handshake (and all data to be used on handshake completion) be made explicitly clear to your users. Check out the <a href="#">styleguide</a> for examples of security screens and messages. 

We are acutely aware of common attack vectors that threaten the flow of seensitive data such as "Man in the Middle" attacks and IP Spoofing. We aim to provide confidence in Lifespan as a participant of any data transfer at all times. We only communicate via secure protocols (HTTPS, SSL) and when data is stored on Lifespan servers we take all necessary precautions to ensure that no bad actors have access to personalized data. 


# Authentication

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: {token}"
```

<aside class="notice">
You must replace <code>token</code> with your personal API key.
</aside>

# Financial Wellness

Lifespan offers two APIs intended to allow developers the ability to deliver a data driven client dashboard which informs the user of thier financial wellness as it relates to recurring payments; then take action on that information. The <a href='#recurring-payments'>Recurring Payments API</a> allows developers to find a user's recurring transactions from a full transaction history. It returns a list of all found recurring payments and their prices. This information can be used to provide a breakdown of the user's monthly recurring spending.

The <a href='#cancellations'>Cancellation API</a> can be leveraged in tandem with the results of the <a href='#recurring-payments'>Recurring Payments API</a> to allow users to the ability to cancel any services found directly from your application; rather than from the service merchant's potentially convoluted cancellation flow. Provide a button or a toggle along side each entry in the list returned by the <a href='#recurring-payments'>Recurring Payments API</a> and make a call with the user's email and the merchants name. Lifespan will initiate a cancelation and return an id that can be used to track status. Your user will be updated via email and you may make a call to check for updates on the status of that cancellation. The <a href='#cancellations'>Cancellation API</a> provides a simple interface for you to provide your user with agency over thier recurring payments.

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
transactions <span style="color:#8792a2; font-size:12px;">string</span> | A JSON string containing an array of transactions. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

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

# Commerce

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
gender <span style="color:#8792a2; font-size:12px;">string</span> | User's gender. Value can either be <span style="color:#cd3d64;">`Male`</span> or <span style="color:#cd3d64;">`Female`</span>. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
age <span style="color:#8792a2; font-size:12px;">number</span> | User's age in years. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
zip <span style="color:#8792a2; font-size:12px;">number</span> | Zip code of user's residence. Must be a valid United States code. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>
subscriptions <span style="color:#8792a2; font-size:12px;">array</span> | List of user's current subscription services. <span style="color:#e56f4a; font-size:10px; letter-spacing: .12px; text-transform: uppercase; font-weight: 600;">Required</span>

<aside class="success">
Don't forget your authentication key
</aside>

![alt text](https://i.imgur.com/B2AQGK1.png "Recommendations")


# Memberships

## Get All Memberships in the Lifespan Directory

```shell
curl "https://api.lifespan.co/memberships"
  -H "Authorization: {token}"
```

> The above command returns JSON structured like this:

```json
"memberships": [
  {  
   "id":1,
   "name":"Aaptiv",
   "motto":"Workout with an audio-based personal trainer",
   "description":"Aaptiv has popularized the audio-based workout. Expert trainers are in your ear guiding you as you exercise, providing techniques, tips, and encouragement. You’ll also hear fresh music hits and classic tracks paced to your workout. It can help you add structure to your gym sessions and make them more productive than ever.",
   "website":"https://aaptiv.com/",
   "status":"pending",
   "service_medium":"digital",
   "offers_trial":true,
   "info":[  
      ""
   ],
   "how_it_works":[  
      "Enter your goals to find personalized programs and workouts",
      "Choose a workout based on duration, trainer, music, and more",
      "Put on your headphones and Aaptiv's trainers will guide your workout"
   ],
   "brand_color_code":"#0019FF",
   "regions":[  
      "US",
      "Canada",
      "UK",
      ...
   ],
   "plans":[  
      {  
         "name":"Monthly",
         "price":14.99,
         "currency":"USD",
         "includes":[  
            "No free trial option",
            "Automatically renews every month"
         ],
         "interval":"month",
         "description":""
      },
      {  
         "name":"Yearly",
         "price":99.99,
         "currency":"USD",
         "includes":[  
            "Includes a free 7-day trial",
            "45% savings compared to monthly",
            "Automatically renews every year"
         ],
         "interval":"annual",
         "description":""
      }
   ],
   "offers":[  
      {  
         "type":"free",
         "duration":7,
         "for_plan":"Yearly",
         "description":"7 days free"
      }
   ],
   "categories":[  
      "Health & Wellness",
      "Fitness",
      "Health & Wellness",
      "Fitness"
   ]
},
  {
    "id": 2,
    ...
  }
  ....
]
```

This endpoint retrieves all memberships.

### HTTP Request

`GET https://api.lifespan.co/memberships`

### Query Parameters

Parameter | Description
--------- | -----------
service_medium | Value can be either `physical` or `digital` returns memberships of said medium.
offers_trial | Value can be either `true` or `false`. If true, only returns memberships with a trial offer.
region | Ex: 'United States'
summary | If true the memberships will be sent with only id, motto, description and name. Default value is `false`.
categories | If a selection of categories is given, results will be filtered accordingly. Comma separated. Default value is `all`.

<aside class="success">
Don't forget your authentication key
</aside>

## Get a Specific Membership

```shell
curl "https://api.lifespan.co/memberships/1"
  -H "Authorization: {token}"
```

> The above command returns JSON structured like this:

```json
{  
   "id":1,
   "name":"Aaptiv",
   "motto":"Workout with an audio-based personal trainer",
   "description":"Aaptiv has popularized the audio-based workout. Expert trainers are in your ear guiding you as you exercise, providing techniques, tips, and encouragement. You’ll also hear fresh music hits and classic tracks paced to your workout. It can help you add structure to your gym sessions and make them more productive than ever.",
   "website":"https://aaptiv.com/",
   "status":"pending",
   "service_medium":"digital",
   "offers_trial":true,
   "info":[  
      ""
   ],
   "how_it_works":[  
      "Enter your goals to find personalized programs and workouts",
      "Choose a workout based on duration, trainer, music, and more",
      "Put on your headphones and Aaptiv's trainers will guide your workout"
   ],
   "brand_color_code":"#0019FF",
   "regions":[  
      "US",
      "Canada",
      "UK",
      ...
   ],
   "plans":[  
      {  
         "name":"Monthly",
         "price":14.99,
         "currency":"USD",
         "includes":[  
            "No free trial option",
            "Automatically renews every month"
         ],
         "interval":"month",
         "description":""
      },
      {  
         "name":"Yearly",
         "price":99.99,
         "currency":"USD",
         "includes":[  
            "Includes a free 7-day trial",
            "45% savings compared to monthly",
            "Automatically renews every year"
         ],
         "interval":"annual",
         "description":""
      }
   ],
   "offers":[  
      {  
         "type":"free",
         "duration":7,
         "for_plan":"Yearly",
         "description":"7 days free"
      }
   ],
   "categories":[  
      "Health & Wellness",
      "Fitness",
      "Health & Wellness",
      "Fitness"
   ]
}
```

This endpoint retrieves a specific membership.

### HTTP Request

`GET https://api.lifespan.co/memberships/<Name>`

### URL Parameters

Parameter | Description
--------- | -----------
Name | The Name of the membership to retrieve

<aside class="success">
Don't forget your authentication key
</aside>


## Get All Categories

```shell
curl "https://api.lifespan.co/categories"
  -H "Authorization: {token}"
```

> The above command returns JSON structured like this:

```json
{
  "categories":[
    {
      "id":1,
      "description":"Fitness"
    },
    {
      "id":2,
      "description":"Beauty"
    }
    ...
  ]
}
```

This endpoint retrieves a list of all categories.

### HTTP Request

`GET https://api.lifespan.co/categories`

<aside class="success">
Don't forget your authentication key
</aside>