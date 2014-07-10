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

OneSecret will use the `secret_key_base` as a key for encrypting your secrets. To obtain the `secret_key_base`, OneSecret will search in the following order:

  1. `ENV['secret_key_base']` or `ENV['SECRET_KEY_BASE`] (this should match your production machines and will allow Rails to decrypt the values there.
  2. Rails.application.secrets.secret_key_base (this will be available on your development and staging environments)
  3. If it fails finding `secret_key_base` in the previous attempts, it will prompt for it (this will allow you to encrypt production values on your development machines)

## Contributing

1. Fork it ( https://github.com/rauchy/one_secret/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
