class Course < ActiveRecord::Base
    include Common
    has_many :course_detail

    validates :course_id, presence: true
    validates :user_id, numericality: { only_integer: true } , :allow_blank => true# 数値or nill 不可

    class << self
        def make_sql_by_user_id(uid)
            madeSQLByUserId=make_search_condition("user_id",uid,"eq")
        end
        def make_sql_by_course_id(course_id)
            madeSQLByUserId=make_search_condition("course_id",course_id,"in")
        end
    end

end