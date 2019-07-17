module FeatureFlag
  class Config
    def clear
      adapter.config_clear
    end

    def get(key)
      adapter.config_get(key)
    end

    def set(key, value)
      adapter.config_set(key, value)
    end

    def to_h
      adapter.config
    end

    private

    def adapter
      FeatureFlag.flipper.adapter.adapter
    end
  end
end
