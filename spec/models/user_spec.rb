require 'rails_helper'

describe User do
  context "with idfa validations" do
    let(:user) { User.create(idfa: idfa) }

    context "when idfa blank" do
      let(:idfa) { "" }

      it { expect(user).not_to be_valid }
    end

    context "when idfa already exists" do
      let(:idfa) { "111" }

      before { create(:user, idfa: idfa) }

      it { expect(user).not_to be_valid }
    end
  end

  context "with ban_status validations" do
    let(:user) { User.create(idfa: "111", ban_status: ban_status) }

    context "without ban_status" do
      let(:user) { User.create(idfa: "111") }

      it { expect(user).to be_valid }
      it { expect(user.ban_status).to eq(User::NOT_BANNED) }
    end

    context "with ban_status banned" do
      let(:ban_status) { User::BANNED }

      it { expect(user).to be_valid }
      it { expect(user.ban_status).to eq(User::BANNED) }
    end

    context "with ban_status not_banned" do
      let(:ban_status) { User::NOT_BANNED }

      it { expect(user).to be_valid }
      it { expect(user.ban_status).to eq(User::NOT_BANNED) }
    end

    context "with not existed ban_status" do
      let(:ban_status) { "wrong_status" }

      it { expect(user).not_to be_valid }
    end
  end
end
