# Lab 06: Solr
This is a demo application for showing how to use the [elasticsearch-rails](https://github.com/elastic/elasticsearch-rails) gem. This app employs a scaffold, a Postgres database, and numerous gems. Follow this [tutorial](https://docs.websolr.com/article/33-sunspot).

## Getting Started
These instructions will get you a copy of the app up and running on your local machine for development and testing purposes.

### Installing
Run the following commands:
```
git clone git@github.com:omc/bonsai-examples.git
cd bonsai-examples
cd rails
bundle install
bundle update
```

If you don't have Yarn installed already, you may have to run:
```
yarn install --check-files
```

### Set up a Postgres Database
Run the following commands to set up a local Postgres DB on your local machine and seed it with 100 randomized users:
```
bundle exec rake db:{create,migrate}
bundle exec rake seed:users
```

### Start Rails app
Run:
```
bundle exec rails s
```
Navigate to http://localhost:3000/users once the Rails server is up and running.

### Running tests
We like using Guard to automatically run the specs against files as they are changed. Open another terminal tab/window and run:
```
bundle exec guard 
```

## Commands and Env Variables (Render Web Service)

### Commands

#### Build Command

```bundle install; bundle exec rake assets:precompile; bundle exec rake assets:clean; bundle exec rake db:{create,migrate}; bundle exec rake seed:users; bundle exec rake sunspot:reindex```

#### Start Command

```bundle exec rails s```

### Env Variables

| Variable | Example Value |
| - | - |
| DATABASE_URL  | postgres://bonsai:dQJcL2d7FU55wasddCKhasdddHF1aYbHz3j@dpg-cl7rrsavokcc73apmn90-a/bonsai_kgje   |
| SECRET_KEY_BASE | teste    |
| WEBSOLR_URL    | https://us-east-1.websolr.com/solr/4bf50c2483e3    |


## Search Result for Bednar

![](imgs/RailsBonsai.png)

## License
This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/omc/bonsai-examples/blob/master/LICENSE) file for details.
