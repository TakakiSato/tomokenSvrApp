class CourseDetailsController < ApplicationController
    require 'upsert/active_record_upsert'
    def index
        begin
            result=Hash.new
            success= true
            courseIdCondition=CourseDetail.make_sql_by_course_id(Integer(params[:course_id]))
            p courseIdCondition
            #sql実行
            result[:record]=CourseDetail.select("course_detail_id,course_id,latitude,longitude").where(courseIdCondition)
        rescue => e
            if result[:error_message].blank?
                result[:error_message]=e.message
            end
            success=false
        ensure
            result[:success] = success
            respond_to do |format|
                format.html
                format.json {render :json => result }
            end
        end
    end

    def create
        begin
            result=Hash.new
            success= true
            if params[:course_id].blank? || params[:latitude].blank? || params[:longitude].blank?
                result[:error_message]="パラメータがたりません。"
                raise
            else
                if Course.exists?(course_id: params[:course_id])
                    result[:course_detail_id]=CourseDetail.new.create(params[:course_id],params[:latitude],params[:longitude])
                else
                    result[:error_message]="存在しないcourseです。"
                    raise
                end
            end
        rescue => e
            if result[:error_message].blank?
                result[:error_message]=e.message
            end
            success=false
        ensure
            result[:success] = success
            respond_to do |format|
                format.html
                format.json {render :json => result }
            end
        end
    end

    def update
        begin
            result=Hash.new
            success= true
            if params[:latitude].blank? && params[:longitude].blank?
                result[:error_message]="パラメータがたりません。"
                raise
            else
                #update用のパラメータ設定
                upd_param=Hash.new
                if params[:latitude].present?
                    upd_param[:latitude]=params[:latitude]
                end
                if params[:longitude].present?
                    upd_param[:longitude]=params[:longitude]
                end
                if CourseDetail.exists?(course_id: Integer(params[:course_id]),course_detail_id: Integer(params[:course_detail_id]))
                    CourseDetail.upsert({course_id: Integer(params[:course_id]),course_detail_id: Integer(params[:course_detail_id])},upd_param)
                    result[:record]=CourseDetail.select("course_detail_id,course_id,latitude,longitude").where(course_id: Integer(params[:course_id]),course_detail_id: Integer(params[:course_detail_id]))
                else
                    result[:error_message]="存在しないcourse_detailです。"
                    raise
                end
            end
        rescue => e
            if result[:error_message].blank?
                result[:error_message]=e.message
            end
            success=false
        ensure
            result[:success] = success
            respond_to do |format|
                format.html
                format.json {render :json => result}
            end
        end
    end

    def destroy
        begin
            result=Hash.new
            success= true
            del_row_count = CourseDetail.delete_all(course_id: Integer(params[:course_id]),course_detail_id: Integer(params[:course_detail_id]))
            result[:del_row_count] = del_row_count
        rescue => e
            if result[:error_message].blank?
                result[:error_message]=e.message
            end
            success=false
        ensure
            result[:success] = success
            respond_to do |format|
                format.html
                format.json {render :json => result }
            end
        end
    end
end
