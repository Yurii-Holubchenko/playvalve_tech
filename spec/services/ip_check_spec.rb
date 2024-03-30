require "rails_helper"

describe IpCheck do
  subject(:instance) { described_class.new("127.0.0.1") }

  context "#valid?" do
    context "with cached response from redis" do
      before do
        allow_any_instance_of(Redis).to receive(:get).with(any_args).and_return(cached_data.to_json)
      end

      it_behaves_like "user data"
    end

    context "without cached response from redis" do
      before do
        allow_any_instance_of(Redis).to receive(:get).with(any_args).and_return(nil)
        allow_any_instance_of(Redis).to receive(:set).with(any_args).and_return("OK")
      end

      context "when Faraday request to VPNAPI.io return data" do
        before do
          allow(Faraday).to(
            receive(:get)
              .with(any_args)
              .and_return(double(Faraday::Response, body: cached_data.to_json))
          )
        end

        it_behaves_like "user data"
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
