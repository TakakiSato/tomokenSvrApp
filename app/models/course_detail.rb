class CourseDetail < ActiveRecord::Base
    include Common
    # 主キー設定
    self.primary_keys = :course, :course_detail_id
    belongs_to :course , foreign_key: "user_id"

    validates :course_detail_id, presence: true
    validates :course_id, numericality: { only_integer: true } # 数値or nill 不可
    validates :latitude, numericality: true # 数値,少数のみ nill　不可
    validates :longitude, numericality:true # 数値,少数のみ nill　不可

    class << self
        def make_sql_by_course_id(course_id)
            madeSQLByCourseID=make_search_condition("course_id",course_id,"eq")
        end
        def make_sql_by_lati_longi(latitude,longitude)
            latiLongiCondition=Array.new
            #make_search_condition(latitude+1km)を呼び出す。latitudeConditionLteqに格納
            latiLongiCondition.push(make_search_condition("latitude",latitude.to_f+0.0090133729745762,"lteq"))
            #make_search_condition(latitude-1km)を呼び出す。latitudeConditionGteqに格納
            latiLongiCondition.push(make_search_condition("latitude",latitude.to_f-0.0090133729745762,"gteq"))
            #make_search_condition(longitude+1km)を呼び出す。longitudeConditionLteqに格納
            latiLongiCondition.push(make_search_condition("longitude",longitude.to_f+0.010966404715491394,"lteq"))
            #make_search_condition(longitude01km)を呼び出す。longitudeConditionGteqに格納
            latiLongiCondition.push(make_search_condition("longitude",longitude.to_f-0.010966404715491394,"gteq"))
            bondedSearchCondition=bond_search_condition("and",latiLongiCondition)
        end
    end
end
