class CoursesController < ApplicationController
    protect_from_forgery :except => [:index,:create,:update,:destroy]
    require 'upsert/active_record_upsert'

    def index
        begin
            result=Hash.new
            success= true
            if params[:uid].blank? && params[:latitude].blank? && params[:longitude].blank?
                result[:error_message]="パラメータがたりません。"
                raise
            else
               #配列初期化
               bondBaseConditionArray=Array.new
                #Course_detail.make_sql_by_lati_longi(latitude,longitude)を実施latiLongiConditionに格納(latitude,longitudeが前後1km以内に該当するものを検索)
            #linkCondition　デフォルト値設定
            if params[:linkCondition]=="or" or params[:linkCondition]=="and"
                linkCondition=params[:linkCondition]
            else
                linkCondition="or"
            end
                #緯度経度情報での検索
                if params[:latitude].present? and params[:longitude].present?
                    latiLongiCondition=CourseDetail.make_sql_by_lati_longi(params[:latitude],params[:longitude])
                    courseIdList=CourseDetail.select("course_id").where(latiLongiCondition).uniq.pluck("course_id")
                    if courseIdList[0].present?
                        bondBaseConditionArray.push(Course.make_sql_by_course_id(courseIdList))
                    else
                        #緯度経度の検索で該当コースがなかった場合、course_idは0に設定する。
                        bondBaseConditionArray.push(Course.make_sql_by_course_id(0))
                    end
                end
                #uid がnilでなければ、make_sql_by_user_id(uid)を実施。uidConditionに格納
                if params[:uid].present?
                    bondBaseConditionArray.push(Course.make_sql_by_user_id(params[:uid]))
                end
                #bondBaseConditionArrayがnillでなければ、bond_search_condition(bondBaseConditionArray)を実行
                if bondBaseConditionArray[0].present?
                    bondCondition=Course.bond_search_condition(linkCondition,bondBaseConditionArray)
                end
                #sql実行
                result[:record]=Course.select("course_id,user_id,course_name").where(bondCondition)

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

    def create
        begin
            result=Hash.new
            success= true
            #if params[:course_name].blank?
            #    result[:error_message]="パラメータがたりません。"
            #    raise
            #else
            Course.create(course_id: params[:course_id].to_i,user_id: params[:uid].to_i , course_name:params[:course_name])
            result[:course_id]=Course.maximum(:course_id)
            p result[:course_id]
            #end
        rescue => e
            result[:error_message]=e.message
            success=false
        ensure
            result[:success] = success
            respond_to do |format|
                format.html
                format.json {render :json => result}
            end
        end
    end

    def update
        begin
            result=Hash.new
            success= true
            if params[:course_name].blank?
                result[:error_message]="コース名が登録されていません。"
                raise
            else
                Course.upsert({course_id: Integer(params[:course_id])},{course_name:params[:course_name]})
                result[:record]=Course.select("course_id,course_name").where(course_id: Integer(params[:course_id]))
            end
        rescue => e
            result[:error_message]=e.message
            success=false
        ensure
            result[:success] = success
            p result
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
            del_row_count = Course.delete_all(course_id: Integer(params[:course_id]))
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
