require "support/shared_examples_for_adapters"

RSpec.describe FeatureFlag::Adapters::Memory do
  subject(:adapter) { described_class.new(prefix: "some-prefix-") }

  it_behaves_like "a feature flag adapter"

  it "raises error if prefix is missing on init" do
    expect { described_class.new }.to raise_error ArgumentError
  end

  it "saves to config key prefixed with provided prefix" do
    source = {}
    adapter = described_class.new(prefix: "some-prefix-", source: source)

    expect(source).to be_empty
    expect { adapter.config_set("foo", "bar") }.to change { source.keys }.to ["some-prefix-config"]
  end
end
