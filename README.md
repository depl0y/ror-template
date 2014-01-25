# ror-template
-

## Description
A Ruby on Rails project, which is clean and already has a lot of features you do not want to develop over and over again.

This template has the following features:

- User registration
- Password forget
- Facebook login and register
- User login with authentication tokens
- Database scheme for setting up the default database
- Bootstrap **3.0.3** already integrated


## Set up
Download the template from github and adjust the following files:

File | Change
-----|-------|
**config/environments/development.rb**|config.action_mailer.default_options = {from: '< from email address >'}
 	|config.action_mailer.smtp_settings = { address: '< your smtp server >' }
 	|config.action_mailer.default_url_options = { :host => 'yoursite.com' }
 	|config.site_url = 'http://local.yoursite.com:3000'
 	|config.admin_email = 'info@yoursite.com'

### More coming soon