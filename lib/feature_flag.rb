require "feature_flag/version"
require "flipper/adapters/redis"
require "flipper"

module FeatureFlag
  class Error < StandardError; end
  class << self
    attr_accessor :adapter
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

    def configure
      Flipper.configure do |config|
        config.default do
          Flipper.new(FeatureFlag.adapter)
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
      features.select(&:enabled?).map { |f| f.name.gsub(prefix.to_s, '') }
    end

    def full_key(key)
      raise ArgumentError, "Feature flag key can not be blank" if key.blank?
      [prefix, key].join
    end

    def prefix
      FeatureFlag.prefix
    end
  end
end
