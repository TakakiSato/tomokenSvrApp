require 'rails_helper'

RSpec.describe Course, :type => :model do
    let(:course){FactoryGirl.build(:course)}
    subject {course}
    context '外部キーのテスト' do
    end
    context 'validationのテスト'do
        context '有効なパラメータでのテスト'do
            context 'course_id,user_id,course_nameが有効な値の場合' do
                it {is_expected.to be_valid}
            end
            context 'user_idがnullの場合' do
                let(:course){FactoryGirl.build(:nill_Course_user_id)}
                it {is_expected.to be_valid}
            end
            context 'course_nameがnullの場合' do
                let(:course){FactoryGirl.build(:nill_Course_course_name)}
                it {is_expected.to be_valid}
            end
        end
        context '無効なパラメータでのテスト'do
            context 'course_idがnullの場合' do
                let(:course){FactoryGirl.build(:nill_Course_course_id)}
                it {is_expected.not_to be_valid}
            end
            context 'course_idが無効な値の場合' do
                let(:course){FactoryGirl.build(:invalid_Course_course_id)}
                it {is_expected.not_to be_valid}
            end
            context 'user_idが無効な値の場合' do
                let(:course){FactoryGirl.build(:invalid_Course_user_id)}
                it {is_expected.not_to be_valid}
            end
        end
    end
    context 'make_sql_by_user_idメソッドのテスト' do
        context '正常系' do
            madeSQLByUserId=Course.make_sql_by_user_id(FactoryGirl.build(:course).user_id)
            it {expect(madeSQLByUserId.class).to eq(Arel::Nodes::Equality)}
        end
        context '異常系' do
            xit
        end
    end
    context 'make_sql_by_course_idメソッドのテスト' do
        context '正常系' do
            madeSQLByCourseId=Course.make_sql_by_course_id(FactoryGirl.build(:course).course_id)
            it {expect(madeSQLByCourseId.class).to eq(Arel::Nodes::In)}
        end
        context '異常系' do
            xit
        end
    end
end
