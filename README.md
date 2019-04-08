# FeatureFlag

Wrapper around Flipper whose job is to toggle applications features. And is using Redis as preferred persistence adapter.

## Installation

    bundle install

## Usage

On application start:

    require 'feature_flag'

    # set persistence adapter
    # if test env:
    FeatureFlag.adapter = FeatureFlag.memory_adapter
    # else use redis and provide redis url:
    FeatureFlag.adapter = FeatureFlag.redis_adapter(Redis.new(url: ENV.fetch('FLIPPER_REDIS_URL')))

    # set feature name prefix
    FeatureFlag.prefix = ENV.fetch('FEATURE_FLAGS_PREFIX")

    # init setup
    FeatureFlag.configure

Use in your application

    FeatureFlag.enabled?('some-feature')
