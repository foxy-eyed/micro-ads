# mirco-ads
Microservice for ads management.

## Dependencies
 - Ruby 3.1.0
 - PostgreSQL 9.6+

## Installation
1. Create databases
```
psql >
CREATE DATABASE micro_ads_development;
CREATE DATABASE micro_ads_test;
```
2. Install app dependencies
```
bundle install
```
3. Run DB migrations
```
bundle exec rake db:migrate
```

## To run http app
```
bundle exec rackup apps/http/config.ru
```
The app is running at `http://localhost:9292`

## Endpoints
### Fetch ads
`GET http://localhost:9292?page=1&per_page=10`

### Create ad
`POST http://localhost:9292/ads`

Params (required):
```
{
  user_id: 1,
  title: 'Kittens in good hands',
  city: 'Erevan',
  description: 'Sweet, furry =^.^='
}
```
### To run tests
```
bundle exec rspec
```
