devise_cas_authenticatable [![Build Status](https://secure.travis-ci.org/nbudin/devise_cas_authenticatable.png)](http://travis-ci.org/nbudin/devise_cas_authenticatable)
==========================
Modified by Eduard Pauné<br/>
Ignores database: users are NOT stored in database.<br/>

Written by Nat Budin<br/>
Taking a lot of inspiration from [devise_ldap_authenticatable](http://github.com/cschiewek/devise_ldap_authenticatable)

devise_cas_authenticatable is [CAS](http://www.jasig.org/cas) single sign-on support for
[Devise](http://github.com/plataformatec/devise) applications.  It acts as a replacement for
database_authenticatable.  It builds on [rubycas-client](http://github.com/gunark/rubycas-client)
and should support just about any conformant CAS server (although I have personally tested it
using [rubycas-server](http://github.com/gunark/rubycas-server)).

Requirements
------------

- Rails 2.3 or greater (works with 3.x versions as well)
- Devise 1.0 or greater
- rubycas-client

Installation
------------

    gem install --pre devise_cas_authenticatable
    
and in your config/environment.rb (on Rails 2.3):

    config.gem 'devise', :version => '~> 1.0.6'
    config.gem 'devise_cas_authenticatable'

or Gemfile (Rails 3.x):

    gem 'devise'
    gem 'devise_cas_authenticatable'

Setup
-----

Once devise\_cas\_authenticatable is installed, add the following to your user model:

    devise :cas_authenticatable
    
You can also add other modules such as token_authenticatable, trackable, etc.  Please do not
add database_authenticatable as this module is intended to replace it.

You'll also need to set up the database schema for this:

    create_table :users do |t|
      t.cas_authenticatable
    end

and, optionally, indexes:

    add_index :users, :username, :unique => true

Finally, you'll need to add some configuration to your config/initializers/devise.rb in order
to tell your app how to talk to your CAS server:

    Devise.setup do |config|
      ...
      config.cas_base_url = "https://cas.myorganization.com"
      
      # you can override these if you need to, but cas_base_url is usually enough
      # config.cas_login_url = "https://cas.myorganization.com/login"
      # config.cas_logout_url = "https://cas.myorganization.com/logout"
      # config.cas_validate_url = "https://cas.myorganization.com/serviceValidate"
      
      # The CAS specification allows for the passing of a follow URL to be displayed when
      # a user logs out on the CAS server. RubyCAS-Server also supports redirecting to a
      # URL via the destination param. Set either of these urls and specify either nil,
      # 'destination' or 'follow' as the logout_url_param. If the urls are blank but
      # logout_url_param is set, a default will be detected for the service.
      # config.cas_destination_url = 'https://cas.myorganization.com'
      # config.cas_follow_url = 'https://cas.myorganization.com'
      # config.cas_logout_url_param = nil

    end

See also
--------

* [CAS](http://www.jasig.org/cas)
* [rubycas-server](http://github.com/gunark/rubycas-server)
* [rubycas-client](http://github.com/gunark/rubycas-client)
* [Devise](http://github.com/plataformatec/devise)
* [Warden](http://github.com/hassox/warden)

TODO
----

* Test on non-ActiveRecord ORMs
