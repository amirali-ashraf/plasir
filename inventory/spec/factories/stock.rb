FactoryBot.define do
  factory :stock do

    trait :eaton_store do
      store {Store.find_by_name('Eaton') || (create :store, :eaton)}
    end

    trait :auburn_store do
      store {Store.find_by_name('Auburn') || (create :store, :auburn)}
    end

    trait :bozza_shoe_model do
      shoe_model {ShoeModel.find_by_name('BOZZA') || (create :shoe_model, :bozza)}
    end

    trait :rasien_shoe_model do
      shoe_model {ShoeModel.find_by_name('RASIEN') || (create :shoe_model, :rasien)}
    end

    trait :low_item_count do
      item_count {2}
    end

    trait :high_item_count do
      item_count {70}
    end

    trait :mid_item_count do
      item_count {30}
    end
  end
end