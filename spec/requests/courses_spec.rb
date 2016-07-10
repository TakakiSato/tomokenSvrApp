require 'rails_helper'

RSpec.describe "Courses", :type => :request do

    describe "GET /courses.jsonのテスト" do
        #テストデータ作成
        before {
           @courses = FactoryGirl.create_list(:course,1)
            #作成したcouresのcourse_idを使ってcourse_detailを作成
            @courses.each do | course |
                courseDetails=FactoryGirl.build_list(:course_detail,10)
                courseDetails.each do |courseDetail|
                    courseDetail.course_id=course.course_id
                    courseDetail.save
                    @latitude=courseDetail.latitude
                    @longitude=courseDetail.longitude

                end
                @uid=course.user_id
                @course_id=course.course_id
            end
        }
        context "uidと緯度経度情報(linkCondition)の結合条件を指定せずに、" do
            context "存在するuidが引数として渡されている。latitude,longitudeが引数としてわたされていない場合" do
                it "コース情報を取得できること"do
                    # GET /courses.json にアクセスする
                    get courses_path uid: @uid,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"].size).to eq @courses.count
                    expect(json["record"][0]["course_id"]).to eq @course_id
                end
                it "successがtrueであること"do
                    #
                    get courses_path uid: @uid,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
            context "存在しないuidが引数として渡されている。latitude,longitudeが引数としてわたされていない場合" do
                not_exist_course = FactoryGirl.build(:other_pattern_course)
                it "検索結果が0件であること"do
                    # GET /courses.json にアクセスする
                    get courses_path uid: not_exist_course.user_id,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"].size).to eq 0
                end
                it "successがtrueであること"do
                    #
                    get courses_path uid: not_exist_course.user_id,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
        end

        context "uidが引数としてわたされていない。存在するlatitude,存在するlongitudeが引数としてわたされている場合" do
            not_exist_course = FactoryGirl.build(:other_pattern_course)
            it "コース情報を取得できること"do
                # GET /courses.json にアクセスする
                get courses_path latitude: @latitude,longitude: @longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq @courses.count
                expect(json["record"][0]["course_id"]).to eq @course_id
            end
            it "successがtrueであること"do
                #
                get courses_path uid: not_exist_course.user_id,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end

        context "uidが引数としてわたされていない。存在しないlatitude,存在しないlongitudeが引数としてわたされている場合" do
            not_exist_course_detail = FactoryGirl.build(:other_pattern_course_detail)
            not_exist_course = FactoryGirl.build(:other_pattern_course)
            it "検索結果が0件であること"do
                # GET /courses.json にアクセスする
                get courses_path latitude: not_exist_course_detail.latitude,longitude: not_exist_course_detail.longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq 0
            end
            it "successがtrueであること"do
                #
                get courses_path uid: not_exist_course.user_id,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end

        context "uidがnill latitude,logitudeがnill" do
            it "エラーメッセージが返ってくること"do
                #
                get courses_path ,format: :json
                json = JSON.parse(response.body)
                expect(json["error_message"]).to_not be_nil
            end
            it "successがfalseであること"do
                #
                get courses_path ,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_falsey
            end
        end

        context "存在するuid,存在するlatitude,存在するlongitudeが引数として渡されている。" do
            it "コース情報を取得できること"do
                # GET /courses.json にアクセスする
                get courses_path uid: @uid, latitude: @latitude,longitude: @longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq @courses.count
                expect(json["record"][0]["course_id"]).to eq @course_id
            end
            it "successがtrueであること"do
                #
                get courses_path uid: @uid, latitude: @latitude,longitude: @longitude,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "uidと緯度経度情報(linkCondition)の結合条件にorを指定し、" do
            context "存在するuidが引数として渡されている。latitude,longitudeが引数としてわたされていない場合" do
                it "コース情報を取得できること"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "or",uid: @uid,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"].size).to eq @courses.count
                    expect(json["record"][0]["course_id"]).to eq @course_id
                end
                it "successがtrueであること"do
                    #
                    get courses_path linkCondition: "or",uid: @uid,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
        end
        context "存在しないuidが引数として渡されている。latitude,longitudeが引数としてわたされていない場合" do
            it "検索結果が0件であること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "or",uid: 1111111111,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq 0
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "or",uid: 1111111111,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "uidが引数として渡されていない。存在するlatitude,longitudeが引数としてわたされている場合" do
            #
            it "コース情報を取得できること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "or",latitude: @latitude,longitude: @longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq @courses.count
                expect(json["record"][0]["course_id"]).to eq @course_id
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "or",latitude: @latitude,longitude: @longitude,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "uidが引数として渡されていない。存在しないlatitude,longitudeが引数としてわたされている場合" do
            #
            it "検索結果が0件であること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "or",latitude: 11111111111111,longitude: 11111111111111,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq 0
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "or",latitude: 11111111111111,longitude: 11111111111111,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "存在するuid,存在するlatitude,存在するlongitudeが引数としてわたされている場合" do
            it "コース情報が取得できること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "or", uid: @uid, latitude: @latitude,longitude: @longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq @courses.count
                expect(json["record"][0]["course_id"]).to eq @course_id
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "or", uid: @uid, latitude: @latitude,longitude: @longitude,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "uidと緯度経度情報(linkCondition)の結合条件にandを指定し、" do
            context "存在するuidが引数としてわたされている。latitude,longitudeが引数としてわたされていない場合" do
                it "コース情報を取得できること"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "and",uid: @uid,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"].size).to eq @courses.count
                    expect(json["record"][0]["course_id"]).to eq @course_id
                end
                it "successがtrueであること"do
                    #
                    get courses_path linkCondition: "and",uid: @uid,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
        end
        context "存在しないuidが引数としてわたされている。latitude,longitudeが引数としてわたされていない場合" do
            it "検索結果が0件であること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "and",uid: 1111111111,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq 0
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "and",uid: 1111111111,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "uidが引数としてわたされていない。存在するlatitude,存在するlongitudeが引数としてわたされている場合" do
            it "コース情報を取得できること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "and",latitude: @latitude,longitude: @longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq @courses.count
                expect(json["record"][0]["course_id"]).to eq @course_id
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "and",latitude: @latitude,longitude: @longitude,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "uidが引数としてわたされていない。存在しないlatitude,存在しないlongitudeが引数としてわたされている場合" do
            it "検索結果が0件であること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "and",latitude: 11111111111111,longitude: 11111111111111,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"].size).to eq 0
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "and",latitude: 11111111111111,longitude: 11111111111111,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end

        context "存在するuid,存在するlatitude,存在するlongitudeが引数としてわたされている場合" do
            it "コース情報が取得できること"do
                # GET /courses.json にアクセスする
                get courses_path linkCondition: "and", uid: @uid, latitude: @latitude , longitude: @longitude,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["record"][0]["course_id"]).to eq @course_id
            end
            it "successがtrueであること"do
                #
                get courses_path linkCondition: "and", uid: @uid, latitude: @latitude , longitude: @longitude,format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
    end


    #create
    describe "POST /courses.jsonのテスト" do
        before {
            @params = FactoryGirl.attributes_for(:course)
        }
        context "course_nameが引数として渡されている場合" do
            it "コース情報が作成されること" do
                # コース数が1増えることを確認
                bf=Course.count
                post courses_path(format: :json), @params
                af=Course.count
                expect(af-bf).to eq 1
            end
            it "successがtrueであること"do
                #
                post courses_path(format: :json), @params
                #JSONの確認
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
            it "登録処理後に採番されたcourse_idが返ってくること" do
                # JSONの各値の確認
                post courses_path(format: :json), @params
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["course_id"]).to_not be_nil
            end
        end

        context "course_nameが引数として渡されていない場合" do
            it "エラーメッセージが返ってくること"do
                #
                post courses_path(format: :json)
                json = JSON.parse(response.body)
                expect(json["error_message"]).to_not be_nil

            end
            it "successがfalseであること"do
                # JSONの各値の確認
                post courses_path(format: :json)
                #JSONの確認
                json = JSON.parse(response.body)
                expect(json["success"]).to be_falsey
            end
        end
    end

    #update
    describe "PATCH    /courses/:course_id.jsonのテスト" do
        before {
            @params = FactoryGirl.create(:course)
            @update_params = FactoryGirl.build(:other_pattern_course)
        }
        context "存在する:course_idを指定し" do
            context "course_nameが引数として渡されている場合" do
                it "コース情報が更新されること" do
                    # コース数が1増えることを確認
                    patch course_path course_id: @params[:course_id],course_name: @params[:course_name] ,format: :json
                    json = JSON.parse(response.body)
                    expect(json["record"][-1]["course_name"]).to eq @params[:course_name]
                end
                it "successがtrueであること"do
                    #
                    patch course_path course_id: @params[:course_id],course_name: @params[:course_name] ,format: :json
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy

                end
                it "course_idが返ってくること" do
                    # JSONの各値の確認
                    patch course_path course_id: @params[:course_id],course_name: @params[:course_name] ,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"][-1]["course_id"]).to_not be_nil
                end
            end
            context "course_nameが引数として渡されていない場合" do
                it "latitudeがnillである旨のエラーメッセージが返ってくること"do
                    #
                    patch course_path course_id: @params[:course_id],format: :json
                    json = JSON.parse(response.body)
                    expect(json["error_message"]).to_not be_nil
                end
                it "successがfalseであること"do
                    # JSONの各値の確認
                    post courses_path(format: :json)
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_falsey
                end
            end
        end
        context "存在しない:course_idを指定した場合" do
            @params = FactoryGirl.build(:other_pattern_course)
            it "エラーが発生すること"do
                #
                expect{patch course_path course_id: @params[:other_pattern_course],course_name: @params[:course_name] ,format: :json}.to raise_error()
            end
        end
    end

    #削除処理
    describe "DELETE /courses/:course_idのテスト" do
        before { @course = FactoryGirl.create(:course) }
        context "存在する:course_idを指定した場合" do
            it "コース情報が削除されること" do
            # コース数が1減ることを確認
            bf=Course.count
            delete course_path(@course.course_id, format: :json)
            af=Course.count
            expect(af-bf).to eq -1
        end
    end
    context "存在しない:course_idを指定した場合" do
        it "エラーが発生すること"do
        @other_course = FactoryGirl.build(:other_pattern_course)
                # JSONの各値の確認
                expect{delete course_path(@other_course.course_id format: :json)}.to raise_error()
            end
        end
    end
end