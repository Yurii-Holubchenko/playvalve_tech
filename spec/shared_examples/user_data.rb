require "rails_helper"

shared_examples "user data" do
  context "when user has valid info" do
    let(:cached_data) { {security: {vpn: false, tor: false}} }

    it { expect(instance.valid?).to be_truthy }
  end

  context "when user has VPN" do
    let(:cached_data) { {security: {vpn: true, tor: false}} }

    it { expect(instance.valid?).to be_falsey }
  end

  context "when user has Tor" do
    let(:cached_data) { {security: {vpn: false, tor: true}} }

    it { expect(instance.valid?).to be_falsey }
  end
end
