require "rails_helper"

describe "CheckStatusController" do
  context "#create" do
    let(:headers) { {"HTTP_CF_IPCOUNTRY" => "US"} }
    let(:params) { {idfa: "111", rooted_device: false} }

    context "when user does not exists" do
      before do
        allow_any_instance_of(DeviceStatusCheck).to receive(:valid?).and_return(true)
      end

      it "creates new user" do
        post "/v1/users/check_status", params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ban_status: User::NOT_BANNED}.to_json)
      end
    end

    context "when user exists" do
      let(:cached_data) do
        {
          ip: "127.0.0.1",
          rooted_device: false,
          country: "US",
          security: {
            proxy: false,
            vpn: false
          }
        }
      end

      before do
        allow_any_instance_of(DeviceStatusCheck).to receive(:valid?).and_return(false)
        allow_any_instance_of(Redis).to receive(:get).and_return(cached_data.to_json)
        create(:user)
      end

      it "updates existing user with banned status" do
        post "/v1/users/check_status", params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ban_status: User::BANNED}.to_json)
      end
    end
  end
end
