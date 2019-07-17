require "flipper"
require "feature_flag/version"
require "feature_flag/adapters/memory"
require "feature_flag/adapters/redis"
require "feature_flag/config"

module FeatureFlag
  class Error < StandardError; end
  class << self
    attr_accessor :prefix

    def flipper
      Flipper
    end

    def configure(options = {})
      prefix = options[:prefix].to_s
      raise ArgumentError, "adapter must be set" unless options.key?(:adapter)
      raise ArgumentError, "prefix can't be blank" if blank?(prefix)
      FeatureFlag.prefix = prefix
      Flipper.configure do |config|
        config.default do
          Flipper.new(build_adapter(options))
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

    def config
      @config ||= Config.new
    end

    private

    def build_adapter(options = {})
      name = options.delete(:adapter)
      if name == :memory
        FeatureFlag::Adapters::Memory.new(options)
      elsif name == :redis
        FeatureFlag::Adapters::Redis.new(options)
      end
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
