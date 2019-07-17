RSpec.describe FeatureFlag::Config do
  subject(:config) { FeatureFlag::Config.new }

  before(:each) do
    FeatureFlag.configure(adapter: :memory, prefix: 'some-prefix-')
    FeatureFlag.config.clear
  end

  describe "#set" do
    it "saves the provided value as a config with the provided key" do
      config.set("foo", "bar")
      expect(config.get("foo")).to eq("bar")
    end

    it "saves the provided value always as a string" do
      config.set("foo", :bar)
      config.set("count", 123)
      config.set("array", [1, 2, 3])

      expect(config.get("foo")).to eq("bar")
      expect(config.get("count")).to eq("123")
      expect(config.get("array")).to eq("[1, 2, 3]")
    end

    it "saves the provided key always as a string" do
      config.set(:foo, :bar)
      config.set(1234, "count")
      config.set([1, 2, 3], "array")

      expect(config.to_h.keys).to match_array ["foo", "1234", "[1, 2, 3]"]
    end
  end

  describe "#get" do
    it "gest the value for the saved key" do
      config.set("foo", "bar")
      expect(config.get("foo")).to eq "bar"
    end

    it "returns nil if value is not yet saved" do
      expect(config.get("foo")).to eq nil
    end

    it "always gets by key as a string" do
      config.set(:fiz, "baz")
      config.set(123, "count")
      config.set([1, 2, 3], "array")

      expect(config.get(:fiz)).to eq "baz"
      expect(config.get("fiz")).to eq "baz"
      expect(config.get(123)).to eq "count"
      expect(config.get("123")).to eq "count"
      expect(config.get([1, 2, 3])).to eq "array"
      expect(config.get("[1, 2, 3]")).to eq "array"
    end
  end

  describe "#to_h" do
    it "it is empty hash by default" do
      expect(config.to_h).to eq({})
    end

    it "returns hash with all configs" do
      config.set(:foo, :bar)
      config.set(:fiz, :baz)
      expect(config.to_h).to eq({ "foo" => "bar", "fiz" => "baz" })
    end
  end
end
