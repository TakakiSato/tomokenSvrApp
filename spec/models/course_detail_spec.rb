require 'rails_helper'

RSpec.describe CourseDetail, :type => :model do
    let(:course_detail){FactoryGirl.build(:course_detail)}
    subject {course_detail}
    context 'make_search_conditionメソッドのテスト' do
        context '外部キーのテスト' do
            xit {}
        end
        context '有効なパラメータでのテスト'do
            context 'course_detail_id,course_id,latitude,longitudeが有効な値の場合' do
                it {is_expected.to be_valid}
            end
        end
        context '無効なパラメータでのテスト'do
            context 'course_detail_idがnullの場合' do
                let(:course_detail){FactoryGirl.build(:nill_CourseDetail_course_detail_id)}
                it {is_expected.not_to be_valid}
            end
            context 'course_idがnullの場合' do
                let(:course_detail){FactoryGirl.build(:nill_CourseDetail_course_id)}
                it {is_expected.not_to be_valid}
            end
            context 'latitudeがnullの場合' do
                let(:course_detail){FactoryGirl.build(:nill_CourseDetail_latitude)}
                it {is_expected.not_to be_valid}
            end
            context 'longitudeがnullの場合' do
                let(:course_detail){FactoryGirl.build(:nill_CourseDetail_longitude)}
                it {is_expected.not_to be_valid}
            end
            context 'course_detail_idが無効な値の場合' do
                let(:course_detail){FactoryGirl.build(:invalid_CourseDetail_course_detail_id)}
                it {is_expected.not_to be_valid}
            end
            context 'course_idが無効な値の場合' do
                let(:course_detail){FactoryGirl.build(:invalid_CourseDetail_course_id)}
                it {is_expected.not_to be_valid}
            end
            context 'latitudeが無効な値の場合' do
                let(:course_detail){FactoryGirl.build(:invalid_CourseDetail_latitude)}
                it {is_expected.not_to be_valid}
            end
            context 'longitudeが無効な値の場合' do
                let(:course_detail){FactoryGirl.build(:invalid_CourseDetail_longitude)}
                it {is_expected.not_to be_valid}
            end
        end
    end

    context 'make_sql_by_course_idメソッドのテスト' do
        context '正常系' do
            madeSQLByCourseID=CourseDetail.make_sql_by_course_id(FactoryGirl.build(:course_detail).course_id)
            it {expect(madeSQLByCourseID.class).to eq(Arel::Nodes::Equality)}
        end
        context '異常系' do
            xit
        end
    end
    context 'make_sql_by_lati_longiメソッドのテスト' do
        context '正常系' do
            bondedSearchCondition=CourseDetail.make_sql_by_lati_longi(FactoryGirl.build(:course_detail).latitude,FactoryGirl.build(:course_detail).longitude)
            it {expect(bondedSearchCondition.class).to eq(Arel::Nodes::And)}
        end
        context '異常系' do
            xit
        end
    end
end
