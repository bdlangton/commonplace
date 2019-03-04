FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@example.com" }
    password { "123456" }
  end

  factory :highlight do
    highlight { "This is the highlight" }
    note { "This is the note" }
    favorite { false }
    published { true }
    all_tags { "" }
    user
    source
  end

  factory :source do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:author) { |n| "Author #{n}" }
    source_type { "Book" }
    user
  end

  factory :tag do
    sequence(:title) { |n| "Title #{n}" }
    user
  end
end
