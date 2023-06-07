Objective
Build an online file sharing application using Rails.

commands: 
1. bundle install
2. rails db:create db:migrate
3. rails s

For running test suite: rspec

Refer: https://github.com/browserstack/tech-onboarding/blob/master/rapid-share-without-gems/README.md

User Management
Sign up
As a new user, I should be able to register for a new account. The application should ask for the following details about a new user:

Unique username: The application should provide a warning incase the username is already taken.
Email address
Password: The password should contain -
Greater than 8 characters
Include at least one uppercase letter
Include at least one lowercase letter
Include at least one number

Login
Once an account is created, a user should be able to login to their account.

If the login is successful: They should be taken to their “File Dashboard” which will serve as their homepage and display the various files associated with their account.
If the login is unsuccessful: Then the following message should be displayed - “Couldn’t find that user! Please try again”
