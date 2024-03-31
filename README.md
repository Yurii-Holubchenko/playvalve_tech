# README

### Pre-installation
You need to have `PostgreSQL` and `Redis` pre-installed.

Run `bundle install` \
Run `rails db:create` \
Run `rails db:migrate`

For the application to work correctly, you need to add a list of allowed countries to Redis. \
To do this you need to run rake task: `rake allowed_countries`. \
If you need more countries, you can add the new countries to the cvs file(`lib/tasks/support/countries.csv`) at any 
time and then re-run rake task from above.

### Task correction
Default URL from the task description was changed from `/v1/user/check_status` to `/v1/users/check_status` because
proposed URL was not RESTful friendly.
