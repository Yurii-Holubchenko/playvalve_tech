require "rails_helper"

describe "CheckStatusController" do
  context "#create" do
    let(:params) do
      {
        idfa: "111",
        rooted_device: false
      }
    end
    let(:headers) { {"HTTP_CF_IPCOUNTRY" => "US"} }

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
      before do
        create(:user)
        allow_any_instance_of(DeviceStatusCheck).to receive(:valid?).and_return(false)
      end

      it "updates existing user" do
        post "/v1/users/check_status", params: params, headers: headers

        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ban_status: User::BANNED}.to_json)
      end
    end
  end
end
