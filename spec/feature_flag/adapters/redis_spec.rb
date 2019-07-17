require "support/shared_examples_for_adapters"

RSpec.describe FeatureFlag::Adapters::Redis do
  let(:redis_url) { ENV["REDIS_URL"] || "redis://127.0.0.1:6379/0" }
  subject(:adapter) { described_class.new( prefix: "some-prefix-", url: redis_url) }

  it_behaves_like "a feature flag adapter"

  it "raises error if prefix is missing on init" do
    expect { described_class.new(url: redis_url) }.to raise_error ArgumentError
    expect { described_class.new(prefix: nil, url: redis_url) }.to raise_error ArgumentError
    expect { described_class.new(prefix: "", url: redis_url) }.to raise_error ArgumentError
    expect { described_class.new(prefix: " ", url: redis_url) }.to raise_error ArgumentError
  end

  it "saves to config key prefixed with provided prefix" do
    adapter.config_set("foo", "bar")
    client = adapter.instance_variable_get(:@client)
    expect(client).to receive(:hgetall).with("some-prefix-config")
    adapter.config
    expect(client).to receive(:hset).with("some-prefix-config", "foo", "bar")
    adapter.config_set("foo", "bar")
    expect(client).to receive(:hget).with("some-prefix-config", "foo")
    adapter.config_get("foo")
  end
end
