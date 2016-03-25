require 'spec_helper'

RSpec.describe Chronolog::Differ do
  describe ".diff" do
    it "indicates no changes if both hashes empty" do
      changes = described_class.diff({}, {})
      expect(changes).to eq({})
    end

    it "indicates no changes if hashes equal" do
      changes = described_class.diff({a: 5}, {a: 5})
      expect(changes).to eq({})
    end

    it "indicates changes if hashes unequal" do
      changes = described_class.diff({a: 5}, {a: 6})
      expect(changes).to eq({ a: [5, 6] })
    end

    it "shows differences between array values" do
      changes = described_class.diff({ a: [1, 2] }, { a: [1, 3] })
      expect(changes).to eq({ a: [[2], [3]] })
    end
  end
end
