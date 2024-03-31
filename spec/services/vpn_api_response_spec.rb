require "rails_helper"

describe VpnApiResponse do
  subject(:instance) { described_class.new(idfa, ip_address) }

  let(:idfa) { "111" }
  let(:ip_address) { "127.0.0.1" }

  context "#call" do
    subject(:call) { instance.call }

    before do
      allow_any_instance_of(Redis).to receive(:get).and_return({}.to_json)
    end

    context "when VPNAPI.io return 429 Error" do
      before do
        allow(Faraday).to receive(:get).and_return(double(Faraday::Response, status: 429))
      end

      it { expect(call).to eq({security: {vpn: false, tor: false}}) }
    end

    context "when VPNAPI.io return 500 Error" do
      before do
        allow(Faraday).to receive(:get).and_return(double(Faraday::Response, status: 500))
      end

      it { expect(call).to eq({security: {vpn: false, tor: false}}) }
    end

    context "with redis and VPNAPI.io response bodies" do
      let(:redis_response) { {rooted_device: false} }
      let(:api_response) { {ip: "127.0.0.1"} }
      let(:faraday_response) { double(Faraday::Response, body: api_response.to_json, status: 200) }

      before do
        allow_any_instance_of(Redis).to receive(:get).and_return(redis_response.to_json)
        allow_any_instance_of(Redis).to receive(:set).and_return("OK")
        allow(Faraday).to receive(:get).and_return(faraday_response)
      end

      it { expect(call).to eq(redis_response.merge(api_response)) }
    end
  end
end
