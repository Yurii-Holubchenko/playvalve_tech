FactoryBot.define do
  factory :user do
    idfa { rand(100_000) }
    not_banned

    trait :banned do
      ban_status { "banned" }
    end

    trait :not_banned do
      ban_status { "not_banned" }
    end
  end
end
