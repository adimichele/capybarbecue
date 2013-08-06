# Capybarbecue

_Capybara the way you like it... skinned, butchered, and cooked to perfection._

## What is Capybarbecue?

**Capybarbecue** makes adds reliability and flexibility to your Capybara test suite by silently changing the way
Capybara works. It gives you a shared database connection and allows you to safely write tests that make use of it
while eliminating race conditions.

For example, the following Capybara test only works with a shared database connection and without **Capybarbecue** it
will randomly fail every now and then due to the race condition that your typical shared database connection
introduces:

```ruby
user = User.first
visit edit_user_path(user)
fill_in 'first_name', with: 'Andrew'           # Edit the users name
click_on 'Submit'                              # Triggers POST request
expect(user.reload.first_name).to eq 'Andrew'  # This line will cause you some headaches
```

Now in principle, this isn't the "right" way to perform automated acceptance testing since you would only simulate
actual user behavior which can only occur through a browser, but let's face it: this paradigm doesn't work for all
testing use cases and writing tests like the one above is sometimes just too damn convenient.

### Other benefits

While **Capybarbecue** was originally designed to "fix" shared database connections in Capybara tests, it has
unexpectedly improved performance and improved some reliability issues not related to shared database connections.
Reasons for this are discussed in the 'How It Works' section below.

## Usage

This is so easy... you're gonna love it.

To install **Capybarbecue**, add this line to your `Gemfile` and then `bundle install`

```ruby
gem 'capybarbecue'
```

Then at the bottom of your test set up file (e.g. RSpec's `spec_helper.rb` or Cucumber's `env.rb`) after you've done
your Capybara setup, add this line:

```ruby
Capybarbecue.activate!
```

That's it. Welcome to the BBQ!

## How it works

TBD

## Contributing

TBD

## Why use Capybarbecue?

TBD

## Copyright

Copyright (c) 2013 Andrew DiMichele. See LICENSE.txt for further details.

