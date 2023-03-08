# EmbeddableContent

Embedder functionality has been extracted to this gem to reduce client-app dependencies.

[![Gem Version](https://badge.fury.io/rb/embeddable_content.svg)](https://badge.fury.io/rb/embeddable_content)

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

## Notes

To update a version of this gem:
1. Update version number in `lib/embeddable_content/version.rb`.
2. Run:

``` bash
$ gem build embeddable_content.gemspec
```
3. A new gem file will be created,
   e.g. `embeddable_content-0.2.0.gem`. Run:

``` bash
$ gem push embeddable_content-0.2.0.gem
```

## Versions

| Version | Changes                                                                                                       |
| ---     | ---                                                                                                           |
| 0.3.1   | Meaningless change as I (EDC) experiment with gem host.                                                       |
| 0.2.0   | NIMAS export now using embedder for TeX. However, the embedder is not yet using the full TexExprssions table. |
