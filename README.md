Questionr
=========
A simple tool to empower citizens to ask candidates one question: “What specific reforms will you advance to end the corrupting influence of money in politics?”

Staging Server
--------------
http://questionr.herokuapp.com

3rd-Party Depedencies
---------------------
1. [RVM](http://rvm.io)
1. [postgres](http://www.postgresql.org)
1. [redis](http://redis.io)
1. [Elastic Search](https://www.elastic.co/products/elasticsearch)

Do not proceed until you have all the dependencies installed and running. (On OSX, your best bet is to install postgres, redis and elastic search using [homebrew](http://brew.sh/).)

Local Environment Setup
-----------------------
1. Clone the git repo
1. Install Ruby 2.2.1 on RVM: `rvm install 2.2.1`
1. Select ruby 2.2.1: `rvm use 2.2.1`
1. Install Bundler in the default gemset: `gem install bundler`
1. Create a custom gemset for questionr: `rvm gemset create questionr`
1. Select the gemset and ruby version: `rvm use 2.2.1@questionr`
1. `cd` into your local project directory
1. Run bundler: `bundle install`
1. Set environment variables for foreman by creating a `.env` file in your project directory with these variables (and ask one of us for the missing values so we can get them to you securely):
    ```
    S3_BUCKET=questionr-stage
    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_REGION=us-west-1
    REDISTOGO_URL=redis://127.0.0.1:6379/
    RAILS_RESQUE_REDIS=redis://127.0.0.1:6379/
    RESQUE_ADMIN_PASSWORD=
    SEARCHBOX_URL=http://localhost:9200
    JANRAIN_API_KEY=
    ```
1. Seed the database:
  1. With dev data: `foreman run bundle exec rails db:setup` or
  1. With staging data: `psql questionr_development < db/questionr-db-backup.pgdump`
1. Start the server locally: `foreman run bundle exec rails s`
1. Visit [http://localhost:3000](http://localhost:3000)
1. Create an admin account for yourself by visiting [http://localhost:3000/admin](http://localhost:3000/admin) and logging in with Facebook.
1. Launch a rails console `foreman run bundle exec rails c` and execute this command to admin-ize your user account: `User.last.update_attribute(:admin, true)`

Contributing (using the [fork-and-pull](https://help.github.com/articles/using-pull-requests) model)
----------------------------------------------------------------------------------------------------
1. Fork the repo
1. Create a topic branch `git checkout -b my-new-feature`
1. Implement your feature or bug fix and add tests
1. Ensure that `foreman run bundle exec rake` passes
1. Commit your changes `git commit -am 'Added some feature and some tests'`
1. Push to the branch `git push origin my-new-feature`
1. Create a pull request
