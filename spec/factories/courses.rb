require 'faker'
require 'faker/japanese'

FactoryGirl.define do
  factory :course do
    sequence(:course_id) {|n|n}
    user_id {Faker::Number.number(2)}
    course_name {Faker::Japanese::Name.name}
    #other patten
    factory :other_pattern_course do
        sequence(:course_id) {|n|n}
        user_id {Faker::Number.number(2)}
    end

    #invalid param
    factory :nill_Course_course_id do
        course_id {""}
    end
    factory :nill_Course_user_id do
        user_id {""}
    end
    factory :nill_Course_course_name do
        course_name {""}
    end
    factory :invalid_Course_course_id do
        course_id {Faker::Japanese::Name.name}
    end
    factory :invalid_Course_user_id do
        user_id {Faker::Address.latitude}
    end
end
end
