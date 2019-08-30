# ChinesePhrases

Converts a csv of Chinese words to a csv of example sentences for use in Anki.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chinese_phrases'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chinese_phrases

## Usage

```
chinese_phrases export input_words.csv
```

Output will be at `output_phrases.csv`.

By default output will be in traditional Chinese.

```
chinese_phrases help export

Usage:
  chinese_phrases export

Options:
  [--output-file=OUTPUT_FILE]
  [--max-len=N]
                               # Default: 15
  [--max-per=N]
                               # Default: 10
  [--page-size=N]
                               # Default: 100
  [--trad], [--no-trad]
                               # Default: true

Output given word csv to phrases csv
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bendangelo/chinese_phrases. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ChinesePhrases project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bendangelo/chinese_phrases/blob/master/CODE_OF_CONDUCT.md).
