require "rails_helper"

describe IpCheck do
  subject(:instance) { described_class.new(idfa, ip) }

  let(:idfa) { "111" }
  let(:ip) { "127.0.0.1" }

  context "#valid?" do
    context "with cached response from redis" do
      before do
        allow_any_instance_of(Redis).to receive(:get).with(any_args).and_return(cached_data.to_json)
      end

      context "when user has valid info" do
        let(:cached_data) { {idfa: idfa, rooted_device: false, ip: ip, security: {vpn: false, tor: false}} }

        it { expect(instance.valid?).to be_truthy }
      end

      context "when user has VPN" do
        let(:cached_data) { {idfa: idfa, rooted_device: false, ip: ip, security: {vpn: true, tor: false}} }

        it { expect(instance.valid?).to be_falsey }
      end

      context "when user has Tor" do
        let(:cached_data) { {idfa: idfa, rooted_device: false, ip: ip, security: {vpn: false, tor: true}} }

        it { expect(instance.valid?).to be_falsey }
      end
    end

    context "without cached response from redis" do
      context "when Faraday request to VPNAPI.io return data" do
        before do
          allow(Faraday).to(
            receive(:get)
              .with(any_args)
              .and_return(double(Faraday::Response, body: cached_data.to_json))
          )
        end

        context "when user has valid info" do
          let(:cached_data) { {idfa: idfa, rooted_device: false, ip: ip, security: {vpn: false, tor: false}} }

          it { expect(instance.valid?).to be_truthy }
        end

        context "when user has VPN" do
          let(:cached_data) { {idfa: idfa, rooted_device: false, ip: ip, security: {vpn: true, tor: false}} }

          it { expect(instance.valid?).to be_falsey }
        end

        context "when user has Tor" do
          let(:cached_data) { {idfa: idfa, rooted_device: false, ip: ip, security: {vpn: false, tor: true}} }

          it { expect(instance.valid?).to be_falsey }
        end
      end

      context "when Faraday request to VPNAPI.io failed" do
        before do
          allow(Faraday).to receive(:get).with(any_args).and_raise(StandardError)
        end

        it { expect(instance.valid?).to be_truthy }
      end
    end
  end
end
