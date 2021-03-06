# ror-template
A Ruby on Rails template, which already has a lot of features you do not want to develop over and over again.

##Features

- User registration
- Password forget and reset option
- Facebook login and register
- User login with authentication tokens
- Database scheme for setting up the default database
- Bootstrap **3.1.0** already integrated
- Send email on registration / password forget, etc.
- Basic JSON API setup, user log in and signup
- Basic localisation set up


## Set up
Download the template from Github and adjust the following files:


###Environment config files

```
config/environments/development.rb
config/environments/production.rb
```

These values are dependant on the ```RAILS_ENV``` variable.

```
config.action_mailer.default_options = {from: '< from email address >'}  
config.action_mailer.smtp_settings = { address: '< your smtp server >' }  
config.action_mailer.default_url_options = { :host => 'yoursite.com' }  
config.site_url = 'http://local.yoursite.com:3000'  
config.admin_email = 'info@yoursite.com'  
```
###Security changes

```
config/initializers/devise.rb
```
Change the following variable to a random string to ensure your tokens will be different than the tokens generated by this template.

```
config.secret_key = 'caccdd4fe2d6a7681df843f5d40e4679a3b76f0699128d22cd4e1fa240d2856149a3d2bb7eee89aed2fe7012c279fa6f2b4fc0f65616cd9ceedcc5e2f16f509f'
```

###Settings for Facebook login

```
config/initializers/devise.rb
```

Before you can use Facebook login, you need to create your app ID's on the Facebook developer website.
Go to https://developers.facebook.com/apps/ and create the apps you need. I usually create 2 apps, one for my development environment and one for my production environment.

After you have created those apps, update the following lines


```
if Rails.env.development?
	config.omniauth :facebook, "APP_ID_DEVELOPMENT", "APP_SECRET_DEVELOPMENT"
else
	config.omniauth :facebook, "APP_ID_PRODUCTION", "APP_SECRET_PRODUCTION"
end
```
###Basic JSON API support

**ror-template** also contains a basic setup for a JSON API. Currently it only supports signing in a user, using just a username and password, after which the server sends back an authentication token. 

###Bundle install
Make sure that you run the usual ```bundle install``` and/or ```bundle update```  before trying to run the application.
###Database configuration
**ror-template** relies on a database, I usually use a MySQL database, but you can use whatever database RoR supports.

Make sure you edit the database configuration file: **config/database.yml** before running the following command:

```rake db:schema:load RAILS_ENV=development```

Of course the ```RAILS_ENV``` parameter is dependant of the environment where you are running this.


###Localisation
**ror-template** contains basic localisation. Currently most of the strings are extracted from the views/controllers and are put in the standard localisation file.

```
config/locales/en.yml
```

This file contains all texts used in the template. It could still use some work, to actually set up the right fields for the model attributes, but this will be added later.

##Bootstrap 3.1.0
Bootstrap is integrated, but I did choose not to use a gem for it. I just put the files in the `vendor` folder. This way it can easily be swapped out for your own framework or no framework at all.

##Gem dependencies

For this template we use a couple of additional gems, here's a list:

* "rails", "4.0.0"
* "mysql2"
* "sass-rails", "~> 4.0.0"
* "uglifier", ">= 1.3.0"
* "coffee-rails", "~> 4.0.0"
* "therubyracer", platforms: :ruby
* "jquery-rails"
* "turbolinks"
* "jbuilder", "~> 1.2"
* "bcrypt-ruby", "~> 3.0.0"
* "active_link_to"
* "nav_link_to", "~> 0.0.4"
* "kaminari"
* "kaminari-bootstrap"
* "devise"
* "omniauth"
* "omniauth-facebook"
* "omniauth-twitter"
* "omniauth-google"
* "activerecord-session_store"
* "redactor-rails"

### More coming soon