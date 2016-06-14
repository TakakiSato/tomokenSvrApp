class CoursesController < ApplicationController
  require 'upsert/active_record_upsert'

    def index
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
        result=Course.select("course_id,user_id,course_name").where(bondCondition)
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end

    def create
        result=Course.upsert({course_id: params[:course_id].to_i},{user_id: params[:uid].to_i , course_name:params[:course_name]})
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end

    def update
        p params
        result=Course.upsert({course_id: params[:course_id].to_i},{user_id: params[:uid].to_i , course_name:params[:course_name]})
        p result
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end

    def destroy
        p params
        result = Course.delete_all(course_id: params[:id].to_i)
        p result
        respond_to do |format|
            format.html
            format.json {render :json => result}
        end
    end
end
