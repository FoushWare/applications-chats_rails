<!-- @format -->

# README

- Installation and setup

  - using Docker composer

  ```
  cd development && docker-compose build && docker-compose up
  ```

- Docker composer will create 6 containers

  - web [Ruby on Rails] Rest API
  - db [mysql] database
  - redis [redis] cache
  - sidekiq [sidekiq] background jobs
  - elasticsearch [elasticsearch] search engine
  - kibana [kibana] search engine dashboard

> Note : i first used sidekiq and redis for background jobs and caching but i found it was not the best solution for this project as i can't render json in background jobs and i can't cache the json response and return [,number ] when create

[workder](ReadMeAssets/sidekiq_01.png)

- chats and messages

> so i decided to use transctions and save the messages in the database and then render the json response

> OR use locks and save the messages in the database and then render the json response

# API documentation

### Application Api

- create Application

```
  Method : POST
  Url    : http://localhost:3000/api/v1/app
  Example:
	Body
	{
		"name" :"test"
	}
	Response:
	{
		token : "da27a6be03637ae2bd7b"
	}

```

### Chat Api

### Chats Api

```

```
