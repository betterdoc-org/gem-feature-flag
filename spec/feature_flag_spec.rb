RSpec.describe FeatureFlag do
  before(:each) do
    FeatureFlag.configure(adapter: FeatureFlag.memory_adapter, prefix: 'some-prefix-')
  end

  it "has a version number" do
    expect(FeatureFlag::VERSION).not_to be nil
  end

  it "is possible to toggle feature flags" do
    key = "some-cool-feature"
    expect(FeatureFlag.enabled?(key)).to eq(false)

    FeatureFlag.enable(key)
    expect(FeatureFlag.enabled?(key)).to eq(true)

    FeatureFlag.disable(key)
    expect(FeatureFlag.enabled?(key)).to eq(false)
  end

  it "raise error if we try to enable blank key" do
    [nil, "     ", ""].each do |key|
      expect { FeatureFlag.enable(key) }.to raise_error ArgumentError
    end
  end

  it "lists all enabled features" do
    expect(FeatureFlag.enabled_feature_keys.count).to eq 0

    FeatureFlag.enable("test-feature-one")
    FeatureFlag.enable("test-feature-two")
    FeatureFlag.enable("test-feature-three")
    expect(FeatureFlag.enabled_feature_keys).to match_array ["test-feature-one", "test-feature-two", "test-feature-three"]

    FeatureFlag.disable("test-feature-three")
    expect(FeatureFlag.enabled_feature_keys).not_to include("test-feature-three")
    expect(FeatureFlag.enabled_feature_keys.count).to eq 2
  end

  it "doesn't list enabled feature keys with prefix" do
    FeatureFlag.enable("test-feature-one")
    expect(FeatureFlag.enabled_feature_keys.first).not_to include(FeatureFlag.prefix)
  end

  it "returns false if error is raised when checking if enabled" do
    FeatureFlag.enable("some-feature")
    allow(Flipper).to receive(:enabled?).and_raise
    expect(FeatureFlag.enabled?("some-feature")).to be_falsy
    expect(FeatureFlag.enabled?("some-unexisting-feature")).to be_falsy
  end

  it "raise error if prefix or adapter are not valid" do
    [nil, "     ", ""].each do |prefix|
      expect { FeatureFlag.configure(adapter: FeatureFlag.memory_adapter, prefix: prefix) }.to raise_error ArgumentError
    end
    expect { FeatureFlag.configure(prefix: 'some-prefix-') }.to raise_error ArgumentError
  end
end
