require "feature_flag/version"
require "flipper/adapters/redis"
require "flipper"

module FeatureFlag
  class Error < StandardError; end
  class << self
    attr_accessor :prefix

    def memory_adapter
      Flipper::Adapters::Memory.new
    end

    def redis_adapter(client)
      Flipper::Adapters::Redis.new(client)
    end

    def flipper
      Flipper
    end

    def configure(adapter: nil, prefix: nil)
      raise ArgumentError, 'adapter must be set' if adapter.nil?
      raise ArgumentError, "prefix can't be blank" if blank?(prefix)
      FeatureFlag.prefix = prefix
      Flipper.configure do |config|
        config.default do
          Flipper.new(adapter)
        end
      end
    end

    def clear
      features.each { |f| flipper.adapter.remove(f) }
    end

    def disable(key)
      flipper.disable(full_key(key))
    end

    def enable(key)
      flipper.enable(full_key(key))
    end

    def enabled?(key)
      flipper.enabled?(full_key(key))
    rescue StandardError => e
      false
    end

    def features
      flipper.features
    end

    def enabled_feature_keys
      features.select(&:enabled?).map { |f| f.name.gsub(FeatureFlag.prefix.to_s, '') }
    end

    def full_key(key)
      raise ArgumentError, "Feature flag key can not be blank" if blank?(key)
      [FeatureFlag.prefix, key].join
    end

    def blank?(test_string)
      test_string.nil? || test_string.empty? || test_string.gsub(' ', '').empty?
    end
  end
end
