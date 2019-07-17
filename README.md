# FeatureFlag

Wrapper around [Flipper](https://github.com/jnunemaker/flipper) whose job is to toggle applications features. And is using Redis as preferred persistence adapter.

## Installation

Add this line to your application's Gemfile:

    gem "feature_flag", git: "https://github.com/betterdoc-org/gem-feature-flag"

And then execute:

    bundle install

## Usage

Add this to your application

    require 'feature_flag'

    # set feature key prefix
    prefix = ENV.fetch('FEATURE_FLAGS_PREFIX")

    # provide prexix and adapter options
    FeatureFlag.configure(prefix: prefix, adapter: :redis, url: ENV.fetch("FEATURE_FLAGS_REDIS_URL"))

If you are on Rails you can put something like this in `config/initializers/feature_flags.rb`:

    if Rails.env.test?
      FeatureFlag.configure(prefix: "some-prefix-", adapter: :memory)
    else
      FeatureFlag.configure(prefix: "some-prefix-", adapter: :redis, url: ENV.fetch("FEATURE_FLAGS_REDIS_URL"))
    end

### Usage for Feature flags

You can now toggle feature flags in your app super easily:

    FeatureFlag.enable('some-feature')

    FeatureFlag.disable('some-feature')

    FeatureFlag.enabled?('some-feature')

    FeatureFlag.disabled?('some-feature')

### Usage for Runtime configuration

You can store configuration that can be changed at runtime:

    FeatureFlag.config.set("some-config", "foo")
    FeatureFlag.config.set("some-other-config", "bar")

To get the stored config:

    FeatureFlag.config.get("some-config") # => "foo"
    FeatureFlag.config.get("some-other-config") # => "bar"


To get all config as a hash:

    FeatureFlag.config.to_h

Keep in mind that all keys and values are stored as Strings and if you need to store complex config you should serialize/desirialize it:

    FeatureFlag.config.set("days-to-keep-backup", 14)
    FeatureFlag.config.get("days-to-keep-backup") # => "14"
    options = { foo: :bar }
    FeatureFlag.config.set("multiple-config-options", YAML.dump(options))
    str = FeatureFlag.config.get("multiple-config-options") # => "---\n:foo: :bar\n"
    YAML.load(str) # => { foo: :bar }

## Development

Install dependencies:

    bundle install

Run tests:

    rake

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
