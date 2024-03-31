require "rails_helper"

describe CountryCheck do
  subject(:instance) { described_class.new(country_code) }

  before do
    allow_any_instance_of(Redis).to receive(:smembers).and_return(%w(US CA GB))
  end

  context "#valid?" do
    context "when country exist" do
      let(:country_code) { "US" }

      it { expect(instance.valid?).to be_truthy }
    end

    context "when country does not exist" do
      let(:country_code) { "UA" }

      it { expect(instance.valid?).to be_falsey }
    end
  end
end
