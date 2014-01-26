# ror-template

## Description
A Ruby on Rails project, which is clean and already has a lot of features you do not want to develop over and over again.

This template has the following features:

- User registration
- Password forget and reset option
- Facebook login and register
- User login with authentication tokens
- Database scheme for setting up the default database
- Bootstrap **3.0.3** already integrated
- Send email on registration / password forget, etc.


## Set up
Download the template from github and adjust the following files:


###Environment config files

* config/environments/development.rb
* config/environments/production.rb

These values are dependant on the ```RAILS_ENV``` variable.

```
config.action_mailer.default_options = {from: '< from email address >'}  
config.action_mailer.smtp_settings = { address: '< your smtp server >' }  
config.action_mailer.default_url_options = { :host => 'yoursite.com' }  
config.site_url = 'http://local.yoursite.com:3000'  
config.admin_email = 'info@yoursite.com'  
```

###Settings for Facebook login

*/config/initializers/devise.rb

Before you can use Facebook login, you need to create your app ID's on the Facebook developer website.
Go to https://developers.facebook.com/apps/ and create the apps you need. I ussualy create 2 apps, one for my development environment and one for my production environment.

After you have created those apps, update the following lines


```
if Rails.env.development?
	config.omniauth :facebook, "APP_ID_DEVELOPMENT", "APP_SECRET_DEVELOPMENT"
else
	config.omniauth :facebook, "APP_ID_PRODUCTION", "APP_SECRET_PRODUCTION"
end
```

-----

### More coming soon