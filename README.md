# OneSecret

If you're storing your application keys, passwords and other secrets apart
from your main git repository and you are working in a team, you
probably know that managing those secrets across the team is a pain in
the ass.

OneSecret aims to remedy that by encrypting all your secrets
inside Rails' secrets.yml and decrypting them on the fly so that they are freely
available to your application.

OneSecret uses Rails' `secret_key_base` as a key for encrypting your
secrets, so the only thing you need to set in your Production servers is the `secret_key_base` (you should be doing that even if you don't use OneSecret).

## Installation

Add this line to your application's Gemfile:

    gem 'one_secret'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install one_secret

## Usage

### Setting a new secret

To set a new secret, simply call the `one_secret:set` task:

    $ rake one_secret:set aws_secret_key aba41f7bea276da49ef50aa33474fee4

That's it! This will encrypt the value and keep it inside
`config/secrets.yml`. Feel free to commit that file to your git
repository.

### Accessing secrets

Inside your app, secrets are decrypted automatically, so you can use them freely:

    Rails.application.secrets.aws_secret_key # => aba41f7bea276da49ef50aa33474fee4

Also, all secrets are copied to `ENV`, so you can also use this:

    ENV['aws_secret_key'] # => aba41f7bea276da49ef50aa33474fee4

If you want to access secrets outside Rails, use the `one_secret:get`
task:

    $ rake one_secret:get aws_secret_key
    > aba41f7bea276da49ef50aa33474fee4
    
### Setting secrets for the Production environment

Since the Production `secret_key_base` is only available in your Production servers, you should provide the `secret_key_base` to the `one_secret:set` Rake task when setting Production secrets. This could be done in one of the following ways:

#### Pass `secret_key_base` In

If your app is on Heroku, you can wire `heroku config:get`:

    $ RAILS_ENV=production SECRET_KEY_BASE=`heroku config:get SECRET_KEY_BASE` rake one_secret:set aws_secret_key 

If you're not on Heroku, you can pass your Production `secret_key_base` to Rake:

    $  RAILS_ENV=production SECRET_KEY_BASE=<your production secret> rake one_secret:set aws_secret_key aba41f7bea276da49ef50aa33474fee4
    
*Important* - make sure you prefix your command with an extra space so it doesn't get saved in your shell history.

#### Type `secret_key_base` In

If your running environment doesn't have a `secret_key_base`, OneSecret will simply prompt for it.

    $ RAILS_ENV=production rake one_secret:set aws_secret_key aba41f7bea276da49ef50aa33474fee4
    > <OneSecret> Please enter your secret key: <paste your production secret here>

Accessing secrets is the same for Production, as your Production machines would typically have `ENV['secret_key_base']` present.

## Contributing

1. Fork it ( https://github.com/rauchy/one_secret/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
