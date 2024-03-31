require "rails_helper"

describe DeviceStatusCheck do
  subject(:instance) { described_class.new(idfa, rooted_device, user_country, user_ip) }

  let(:idfa) { "111" }
  let(:rooted_device) { false }
  let(:user_country) { "US" }
  let(:user_ip) { "127.0.0.1" }

  context "#valid?" do
    context "with user_country" do
      context "when user_country check valid" do
        before do
          allow_any_instance_of(CountryCheck).to receive(:valid?).and_return(true)
          allow_any_instance_of(IpCheck).to receive(:valid?).and_return(true)
        end

        it { expect(instance.valid?).to be_truthy }
      end

      context "when user_country check invalid" do
        before do
          allow_any_instance_of(CountryCheck).to receive(:valid?).and_return(false)
          allow_any_instance_of(IpCheck).to receive(:valid?).and_return(true)
        end

        it { expect(instance.valid?).to be_falsey }
      end
    end

    context "with rooted_device" do
      context "when rooted_device" do
        let(:rooted_device) { true }

        before do
          allow_any_instance_of(CountryCheck).to receive(:valid?).and_return(true)
          allow_any_instance_of(IpCheck).to receive(:valid?).and_return(true)
        end

        it { expect(instance.valid?).to be_falsey }
      end

      context "when not rooted_device" do
        let(:rooted_device) { false }

        before do
          allow_any_instance_of(CountryCheck).to receive(:valid?).and_return(true)
          allow_any_instance_of(IpCheck).to receive(:valid?).and_return(true)
        end

        it { expect(instance.valid?).to be_truthy }
      end
    end

    context "with user_ip" do
      context "when user_ip check valid" do
        before do
          allow_any_instance_of(CountryCheck).to receive(:valid?).and_return(true)
          allow_any_instance_of(IpCheck).to receive(:valid?).and_return(true)
        end

        it { expect(instance.valid?).to be_truthy }
      end

      context "when user_ip check invalid" do
        before do
          allow_any_instance_of(CountryCheck).to receive(:valid?).and_return(true)
          allow_any_instance_of(IpCheck).to receive(:valid?).and_return(false)
        end

        it { expect(instance.valid?).to be_falsey }
      end
    end
  end
end
