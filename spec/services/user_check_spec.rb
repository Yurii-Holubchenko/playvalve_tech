require "rails_helper"

describe UserCheck do
  subject(:instance) { described_class.new(idfa, rooted_device, user_country, user_ip) }

  let(:idfa) { "111" }
  let(:rooted_device) { false }
  let(:user_country) { "US" }
  let(:user_ip) { "127.0.0.1" }

  context "#call" do
    subject(:call) { instance.call }

    before do
      allow_any_instance_of(DeviceStatusCheck).to receive(:valid?).and_return(true)
    end

    context "with new user" do
      it { expect { call }.to change(User, :count).by(1) }
      it { expect(call.idfa).to eq(idfa) }
      it { expect(call.ban_status).to eq(User::NOT_BANNED) }

      context "when new user device invalid" do
        before do
          allow_any_instance_of(DeviceStatusCheck).to receive(:valid?).and_return(false)
        end

        it { expect(call.idfa).to eq(idfa) }
        it { expect(call.ban_status).to eq(User::BANNED) }
      end
    end

    context "with existed user" do
      let!(:user) { create(:user) }
      let(:idfa) { user.idfa }

      context "when user not banned" do
        it { expect(call.idfa).to eq(idfa) }
        it { expect(call.ban_status).to eq(User::NOT_BANNED) }
      end

      context "when user banned" do
        before do
          user.update(ban_status: User::BANNED)
          user.reload
        end

        it { expect(call.idfa).to eq(idfa) }
        it { expect(call.ban_status).to eq(User::BANNED) }
      end

      context "when existed user device invalid" do
        before do
          allow_any_instance_of(DeviceStatusCheck).to receive(:valid?).and_return(false)
        end

        it { expect(call.idfa).to eq(idfa) }
        it { expect(call.ban_status).to eq(User::BANNED) }
      end
    end
  end
end
