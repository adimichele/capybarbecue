# Capybarbecue

_Capybara the way you like it... skinned, butchered, and cooked to perfection._

## What is Capybarbecue?

*Capybarbecue* makes adds reliability and flexibility to your Capybara test suite by silently changing the way
Capybara works. It gives you a shared database connection and allows you to safely write tests that make use of it
while eliminating race conditions.

For example, the following Capybara test only works with a shared database connection and without *Capybarbecue* it
will randomly fail every now and then due to the race condition that your typical shared database connection
introduces:

```ruby
user = User.first
visit edit_user_path(user)
fill_in 'first_name', with: 'Andrew'           # Edit the user's name
click_on 'Submit'                              # Triggers POST request
expect(user.reload.first_name).to eq 'Andrew'  # This line will cause you some headaches
```

Now in principle, this isn't the "right" way to perform automated acceptance testing since you would only simulate
actual user behavior which can only occur through a browser, but let's face it: this paradigm doesn't work for all
testing use cases and writing tests like the one above is sometimes just too damn convenient.

## Setup

This is so easy... you're gonna love it.

To install *Capybarbecue*, add this line to your `Gemfile` and then `bundle install`

```ruby
gem 'capybarbecue'
```

Then at the bottom of your test set up file (e.g. RSpec's `spec_helper.rb` or Cucumber's `env.rb`) after you've done
your Capybara setup, add this line:

```ruby
Capybarbecue.activate!
```

That's it. Just continue to write your Capybara tests as you normally would. Welcome to the BBQ!

## Beware Javascript

AJAX and other javascript interactions may cause you problems since Capybara has no way to know when your javascript has
finished executing. To prevent issues with this, make sure you check the state of the page to ensure that your
javascript has finished running.

For example, let's say we have a button with an `onclick` handler that simply visits a new page. Here's the
_wrong_ way to test:

```ruby
visit '/page/1'
click_on 'Go to /page/2'  # Triggers an `onclick` handler
click_on 'Go to /page/3'  # OOPS! No guarantee that /page/2 has been loaded yet!
```

Here's the _right_ way:

```ruby
visit '/page/1'
click_on 'Go to /page/2'           # Triggers an `onclick` handler
page.should have_content 'Page 2'  # GREAT! Capybara will actually wait until this is true (or fail after some timeout)
click_on 'Go to /page/3'           # We know we're on the right page and that this button exists!
```

Note that this only works with Capybara matchers. For example, the following will _not_ work:

```ruby
visit '/page/1'
click_on 'Go to /page/2'                  # Triggers an `onclick` handler
current_path.should start_with '/page/2'  # OOPS! The new page may not have loaded yet!
click_on 'Go to /page/3'                  # We may not even get here
```

## How it works

*Capybarbecue* works by running your tests and handling Rack requests in the same thread. When you make a call to the
Capybara API, your call is delegated to another thread while the main thread is used to handle web requests, which are
themselves queued by third thread which acts as the web server. Once the Capybara matcher returns, control is returned
to your test.

## Copyright

Copyright (c) 2013 Andrew DiMichele. See LICENSE.txt for further details.

