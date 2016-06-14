class CourseDetailsController < ApplicationController
    require 'upsert/active_record_upsert'
    def index
        if params[:course_id].present?
            courseIdCondition=CourseDetail.make_sql_by_course_id(params[:course_id].to_i)
            #sql実行
            result=CourseDetail.select("course_detail_id,course_id,latitude,longitude").where(courseIdCondition)
        end
        p result
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end

    def create
        result=CourseDetail.upsert({course_id: params[:course_id].to_i,course_detail_id: params[:course_detail_id].to_i},{latitude: params[:latitude] , longitude:params[:longitude]})
        p result
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end

    def update
        result=CourseDetail.upsert({course_id: params[:course_id].to_i,course_detail_id: params[:course_detail_id].to_i},{latitude: params[:latitude].to_f , longitude:params[:longitude].to_f})
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end

    def destroy
        p params
        result = CourseDetail.delete_all(course_id: params[:course_id].to_i,course_detail_id: params[:course_detail_id].to_i)
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end
end
