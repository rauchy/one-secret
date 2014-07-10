# OneSecret

If you're storing your application keys, passwords and other secrets apart
from your main git repository and you are working in a team, you
probably know that managing those secrets across the team is a pain in
the ass.

OneSecret aims to remedy that by encrypting all your secrets
inside Rails' secrets.yml and decrypting them on the fly so that they are freely
available to your application.

OneSecret uses Rails' `secret_key_base` as a key for encrypting your
secrets, so the only thing you need to set in your production servers is the `secret_key_base` (you should be doing that even if you don't use OneSecret).

## Installation

Add this line to your application's Gemfile:

    gem 'one_secret'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install one_secret

## Usage

### Setting a new secret

To add a new secret, simply call the `one_secret:set` task:

    $ rake one_secret:set aws_secret_key aba41f7bea276da49ef50aa33474fee4

That's it! This will encrypt the value and keep it inside
`config/secrets.yml`. Feel free to commit that file to your git
repository.

### Accessing secrets

Inside your app, secrets are decrypted, so you can use them freely:

    Rails.application.secrets.aws_secret_key # => aba41f7bea276da49ef50aa33474fee4

Also, all secrets are copied to ENV, so you can also use this:

    ENV['aws_secret_key'] # => aba41f7bea276da49ef50aa33474fee4

If you want to access secrets outside Rails, use the `one_secret:get`
task:

    $ rake one_secret:get aws_secret_key
    > aba41f7bea276da49ef50aa33474fee4
    
### What About Production?

Setting secrets and accessing secrets is easy in Development/Test/Staging environments, where your `secret_key_base` is available inside `config/secrets.yml`. However, on production there is a slightly different flow, since your Production's `secret_key_base` should *never* be commited to git.

So when setting new secrets for the Production environment, you would have to provide the `secret_key_base` to the `one_secret:set` Rake task. This could be done in one of the following ways:

  * Type it in:
  
    $ RAILS_ENV=production rake one_secret:set aws_secret_key aba41f7bea276da49ef50aa33474fee4
    > <OneSecret> Please enter your secret key: <<paste your secret here>>

  * Encrypt it in your server (for Heroku - this will encrypt inside your Heroku instance and store the encrypted result on your dev machine):
  
    $ RAILS_ENV=production rake one_secret:set `heroku run rake one_secret:build aws_secret_key aba41f7bea276da49ef50aa33474fee4`

  * Pass it in (not recommended since your `secret_key_base` will be available in your shell history):

    RAILS_ENV=production SECRET_KEY_BASE=<<your secret>> rake one_secret:set aws_secret_key aba41f7bea276da49ef50aa33474fee4

OneSecret will use the `secret_key_base` as a key for encrypting your secrets. To obtain the `secret_key_base`, OneSecret will search in the following order:

  1. `ENV['secret_key_base']` or `ENV['SECRET_KEY_BASE']` (this should be found on your production machines and will allow Rails to decrypt the values there.
  2. `Rails.application.secrets.secret_key_base` (this will be available on your development and staging environments in your `config/secrets.yml`)
  3. If it fails finding `secret_key_base` in the previous attempts, it will prompt for it (this will allow you to encrypt production values on your development machines)

Bottom line: in development / test / staging - OneSecret will automatically encrypt and decrypt for you. For production - you'll probably want to paste in the `secret_key_base` if you are encrypting on your development box. Decrypting will be done automatically on your production machines.

## Contributing

1. Fork it ( https://github.com/rauchy/one_secret/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
