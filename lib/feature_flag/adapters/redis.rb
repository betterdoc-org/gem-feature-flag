require "flipper/adapters/redis"

module FeatureFlag
  module Adapters
    class Redis < Flipper::Adapters::Redis
      def initialize(options = {})
        @prefix = options.delete(:prefix).to_s.strip
        raise(ArgumentError, "prefix can't be blank") if @prefix.empty?

        super(::Redis.new(options))
      end

      def config
        @client.hgetall(config_key)
      end

      def config_clear
        @client.del(config_key)
      end

      def config_get(key)
        @client.hget(config_key, key.to_s)
      end

      def config_set(key, value)
        @client.hset(config_key, key.to_s, value.to_s)
      end

      private

      def config_key
        @config_key ||= [@prefix, "config"].join
      end
    end
  end
end
