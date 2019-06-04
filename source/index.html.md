---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - ruby
  - python
  - javascript

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the Lifespan API! You can use our API to access Lifespan API endpoints, which can get information on various cats, kittens, and breeds in our database.

We have language bindings in Shell, Ruby, Python, and JavaScript! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

This example API documentation page was created with [Slate](https://github.com/lord/slate). Feel free to edit it and use it as a base for your own API's documentation.

# Authentication

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# Memberships

## Get All Memberships in the Lifespan Directory

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://api.lifespan.co/memberships"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
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

`GET http://api.lifespan.co/memberhsips`

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

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://api.lifespan.co/memberships/1"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
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

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://api.lifespan.co/memberships/<Name>`

### URL Parameters

Parameter | Description
--------- | -----------
Name | The Name of the membership to retrieve

## Get All Categories

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl "http://api.lifespan.co/categories"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
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

`GET http://api.lifespan.co/categories`

