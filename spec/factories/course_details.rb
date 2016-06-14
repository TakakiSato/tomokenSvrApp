require 'faker'
require 'faker/japanese'

FactoryGirl.define do
  factory :course_detail do
    sequence(:course_detail_id) {|n|n}
    sequence(:course_id) {|n|n}
    latitude {Faker::Address.latitude}
    longitude {Faker::Address.longitude}
    #invalid param
    factory :nill_CourseDetail_course_detail_id do
        course_detail_id {""}
    end
    factory :nill_CourseDetail_course_id do
        course_id {""}
    end
    factory :nill_CourseDetail_latitude do
        latitude {""}
    end
    factory :nill_CourseDetail_longitude do
        longitude {""}
    end
    factory :invalid_CourseDetail_course_detail_id do
        course_detail_id {Faker::Japanese::Name.name}
    end
    factory :invalid_CourseDetail_course_id do
        course_id {Faker::Address.latitude}
    end
    factory :invalid_CourseDetail_latitude do
        latitude {Faker::Japanese::Name.name}
    end
    factory :invalid_CourseDetail_longitude do
        longitude {Faker::Japanese::Name.name}
    end
end
end
