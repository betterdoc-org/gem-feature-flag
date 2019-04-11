# FeatureFlag

Wrapper around [Flipper](https://github.com/jnunemaker/flipper) whose job is to toggle applications features. And is using Redis as preferred persistence adapter.

## Add to your project

In gemfile add:

    gem "feature_flag", git: "https://github.com/betterdoc-org/gem-feature-flag"

install:

    bundle install


On application start:

    require 'feature_flag'

    # set persistence adapter
    # if test env:
    adapter = FeatureFlag.memory_adapter
    # else use redis and provide redis url:
    adapter = FeatureFlag.redis_adapter(Redis.new(url: ENV.fetch('FLIPPER_REDIS_URL')))

    # set feature key prefix
    prefix = ENV.fetch('FEATURE_FLAGS_PREFIX")

    # init setup
    FeatureFlag.configure(adapter: adapter, prefix: prefix)

Use in your application:

    FeatureFlag.enable('some-feature')

    FeatureFlag.disable('some-feature')

    FeatureFlag.enabled?('some-feature')

    FeatureFlag.disabled?('some-feature')

Development

    bundle install

    rake spec