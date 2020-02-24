# EmbeddableContent

Embedder functionality has been extracted to this gem to reduce client-app dependencies.

## Installation

For IM gems, add this to your application's Gemfile:

``` ruby
git_source(:im) do |repo_name|
  "https://github.com/illustrativemathematics/#{repo_name}.git"
end
```

Then add this line to your application's Gemfile:

```ruby
gem 'embeddable_content', im: 'embeddable_content'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install embeddable_content

## Usage

Ask Eric.

## Development

N.b. (EDC): This bit was auto-generated so it's unclear how relevant it is.

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/illustrativemathematics/embeddable_content.
