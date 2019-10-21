# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    name { "My Author" }
    type { "" }
    sources { [] }
    all_tags { "" }
    user
  end

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
    sequence(:authors) { [] }
    source_type { "Book" }
    all_tags { "" }
    user
  end

  factory :tag do
    sequence(:title) { |n| "Title #{n}" }
    user
  end
end
