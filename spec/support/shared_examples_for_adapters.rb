RSpec.shared_examples "a feature flag adapter" do
  before do
    adapter.config_clear
  end

  describe "#config" do
    it "it is empty hash by default" do
      expect(adapter.config).to eq({})
    end

    it "returns hash with all configs" do
      adapter.config_set(:foo, :bar)
      adapter.config_set(:fiz, :baz)
      expect(adapter.config).to eq({ "foo" => "bar", "fiz" => "baz" })
    end
  end

  describe "#config_clear" do
    it "deletes everything from config" do
      adapter.config_set(:foo, :bar)
      expect { adapter.config_clear }.to change { adapter.config }.from({ "foo" => "bar" }).to({})
    end
  end

  describe "#config_get" do
    it "gets the value for the key" do
      adapter.config_set("foo", "bar")
      expect(adapter.config_get("foo")).to eq "bar"
    end

    it "returns nil if nothing is yet saved" do
      expect(adapter.config_get("foo")).to eq nil
    end

    it "always gets by key as a string" do
      adapter.config_set(:fiz, "baz")
      adapter.config_set(123, "count")
      adapter.config_set([1, 2, 3], "array")

      expect(adapter.config_get(:fiz)).to eq "baz"
      expect(adapter.config_get("fiz")).to eq "baz"
      expect(adapter.config_get(123)).to eq "count"
      expect(adapter.config_get("123")).to eq "count"
      expect(adapter.config_get([1, 2, 3])).to eq "array"
      expect(adapter.config_get("[1, 2, 3]")).to eq "array"
    end
  end

  describe "#set" do
    it "saves the provided value as a config with the provided key" do
      adapter.config_set("foo", "bar")
      expect(adapter.config_get("foo")).to eq("bar")
    end

    it "saves the provided value always as a string" do
      adapter.config_set("foo", :bar)
      adapter.config_set("count", 123)
      adapter.config_set("array", [1, 2, 3])

      expect(adapter.config_get("foo")).to eq("bar")
      expect(adapter.config_get("count")).to eq("123")
      expect(adapter.config_get("array")).to eq("[1, 2, 3]")
    end

    it "saves the provided key always as a string" do
      adapter.config_set(:foo, :bar)
      adapter.config_set(1234, "count")
      adapter.config_set([1, 2, 3], "array")

      expect(adapter.config.keys).to match_array ["foo", "1234", "[1, 2, 3]"]
    end
  end
end
