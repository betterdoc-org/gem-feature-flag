require "flipper/adapters/memory"

module FeatureFlag
  module Adapters
    class Memory < Flipper::Adapters::Memory
      def initialize(prefix:, source: nil)
        @prefix = prefix.to_s
        super(source)
      end

      def config
        @source[config_key] ||= {}
      end

      def config_clear
        @source[config_key] = {}
      end

      def config_get(key)
        config[key.to_s]
      end

      def config_set(key, value)
        config[key.to_s] = value.to_s
      end

      private

      def config_key
        @config_key ||= [@prefix, "config"].join
      end
    end
  end
end
