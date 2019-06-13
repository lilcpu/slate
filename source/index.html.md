---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:
  - <a href='#'>Request a Developer Key</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Lifespan API! You can use our API to access Lifespan API endpoints, which can get information on various subscription services, categories, and tools to analyze transaction statements to identify or reccomend services to your users.

# Authentication

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: {token}"
```

<aside class="notice">
You must replace <code>token</code> with your personal API key.
</aside>

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

`GET https://api.lifespan.co/memberhsips`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
service_medium | na | Either 'pyshical' or 'digital' returns memberships of said medium
offers_trial | na | Either true or false. If true, filters memberships with a trial offer
region | na | Ex: 'United States'
summary | false | If true the memberships will be sent with only id, motto, description and name
categories | all | If a selection of categories is given, results will be filtered accordingly. Comma seperated. 

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


# Cancellation

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

This endpoint takes in a merchant name and the email of the user that would like to cancel thier subscription. This email __must__ be the email in use at the service in question. The cancellation will be initiated and that user will recieve email updates on the cencellation status as it progresses. Usually no more than 24 hours.

### HTTP Request

`POST https://api.lifespan.co/cancellations`

### Payload

Parameter | Description
--------- | -----------
merchantName | the name of the merchant you wish to cancel a subscription with
userEmail | the email of the user who is cancelling thier subscription (__must__ be the email on the account being cancelled with the merchant)

<aside class="success">
Don't forget your authentication key
</aside>

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
id | the id of the cancellation. This is included in the response to a request to `/cancellations`.

<aside class="success">
Don't forget your authentication key
</aside>

# Recurring Services

## Get All Recurring Services in a Transaction History

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

This endpoint returns a list of all recurring services found in a given transaction history. They are organized by accountId which is a plaid construct to securley mask sensitive details of an account. The `price` field of the returned services is always in cents.

### HTTP Request

`POST https://api.lifespan.co/services`

### Payload

Parameter | Description
--------- | -----------
transactions | a json string containing an array of transactions from plaid. See the [plaid docs](https://plaid.com/docs/#transactions) for info on obtaining transactions.

<aside class="success">
Don't forget your authentication key
</aside>