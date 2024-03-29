require "rails_helper"

describe "CheckStatusController" do
  context "#create" do
    let(:params) do
      {
        idfa: "111",
        rooted_device: false
      }
    end

    it "creates new user" do
      post "/v1/users/check_status", params: params, headers: headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({ban_status: User::NOT_BANNED}.to_json)
    end
  end
end
