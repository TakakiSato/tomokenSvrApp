require 'rails_helper'

RSpec.describe "CourseDetails", :type => :request do
    describe "GET /course_details/:course_id.jsonのテスト" do
        #テストデータ作成
        before { @courses = FactoryGirl.create_list(:course,1)
            #作成したcouresのcourse_idを使ってcourse_detailを作成
            @courses.each do | course |
                @courseDetails=FactoryGirl.build_list(:course_detail,10)
                @courseDetails.each do |courseDetail|
                    courseDetail.course_id=course.course_id
                    courseDetail.save
                    @courseDetailId=courseDetail.course_detail_id
                    @courseId=courseDetail.course_id
                    @latitude=courseDetail.latitude
                    @longitude=courseDetail.longitude
                end
                @uid=course.user_id
                @course_id=course.course_id
            end
        }

        context "存在する:course_idを指定し" do
            context ":course_idに紐づくcourse_detailsが存在する場合" do
                it "一覧情報を取得できること"do
                    # GET /course_details.json にアクセスする
                    get course_details_path course_id: @course_id ,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"].size).to eq @courseDetails.count
                    expect(json["record"][-1]["course_detail_id"]).to eq @courseDetailId
                    expect(json["record"][-1]["course_id"]).to eq @courseId
                    expect(json["record"][-1]["latitude"]).to eq @latitude.to_s
                    expect(json["record"][-1]["longitude"]).to eq @longitude.to_s
                end
                it "successがtrueであること"do
                    #
                    get course_details_path course_id: @course_id ,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
            context ":course_idに紐づくcourse_detailsが存在しない場合" do
                not_exist_course = FactoryGirl.create(:other_pattern_course)
                it "一覧情報が空であること"do
                    #
                    get course_details_path course_id: not_exist_course.course_id ,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"][0]).to be_nil
                end
                it "successがtrueであること"do
                    #
                    get course_details_path course_id: not_exist_course ,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
        end
        context "存在しない:course_idを指定する場合" do
            not_exist_course = FactoryGirl.build(:other_pattern_course)
            it "一覧情報が空であること"do
                    #
                    get course_details_path course_id: not_exist_course.course_id ,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["record"][0]).to be_nil
                end
                it "successがtrueであること"do
                    #
                    get course_details_path course_id: not_exist_course ,format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
        end
    #create
    describe "POST /course_details/:course_id.jsonのテスト" do
        before {
            @params = FactoryGirl.attributes_for(:course_detail)
            @course = FactoryGirl.create(:course)
        }
        context "存在する:course_idを指定し" do
            context "latitude,longitudeが引数として渡されている場合" do
                it "コース情報が作成されること" do
                    # コース数が1増えることを確認
                    bf=CourseDetail.count
                    post course_details_path course_id: @course[:course_id] ,latitude: @params[:latitude],longitude: @params[:longitude],format: :json
                    af=CourseDetail.count
                    expect(af-bf).to eq 1
                end

                it "successがtrueであること"do
                    # JSONの各値の確認
                    post course_details_path course_id: @course[:course_id] ,latitude: @params[:latitude],longitude: @params[:longitude],format: :json
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
                it "登録処理後に採番されたcourse_detail_idが返ってくること" do
                    # JSONの各値の確認
                    post course_details_path course_id: @course[:course_id] ,latitude: @params[:latitude],longitude: @params[:longitude],format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["course_detail_id"]).to_not be_nil
                end
            end

            context "latitudeのみが引数として渡されている場合" do
                it "エラーが発生すること"do
                    #
                    expect{post course_details_path latitude: @params[:latitude],format: :json}.to raise_error()
                end
            end

            context "longitudeのみが引数として渡されている場合" do
                it "エラーが発生すること"do
                    #
                    expect{post course_details_path longitude: @params[:longitude],format: :json}.to raise_error()
                end
            end

            context "latitude,longitudeが引数として渡されていない場合" do
                it "エラーが発生すること"do
                    #
                    expect{post course_details_path longitude: @params[:longitude],format: :json}.to raise_error()
                end
                it "longitudee,longitudeがnillである旨のエラーメッセージが返ってくること"do
                    # JSONの各値の確認
                    post course_details_path course_id: @params[:course_id] ,format: :json
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["error_message"]).to_not be_nil
                end
                it "successがfalseであること"do
                    # JSONの各値の確認
                    post course_details_path course_id: @params[:course_id] ,format: :json
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_falsey
                end
            end
        end
        context "存在しない:course_idを指定した場合" do
            not_exist_course = FactoryGirl.build(:other_pattern_course)
            it "エラーメッセージが返ってくること"do
                #
                post course_details_path course_id: not_exist_course.course_id ,latitude: @params[:latitude],longitude: @params[:longitude],format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                expect(json["error_message"]).to_not be_nil
            end
            it "successがfalseであること"do
                #
                post course_details_path course_id: not_exist_course.course_id ,latitude: @params[:latitude],longitude: @params[:longitude],format: :json
                json = JSON.parse(response.body)
                expect(json["success"]).to be_falsey
            end
        end
    end
    #更新処理
    describe "PATCH       /course_details/:course_id/:course_detail_idのテスト" do
        before {
            @params = FactoryGirl.create(:course_detail)
            @upd_params = FactoryGirl.build(:course_detail)
        }
        context "存在する:course_id,:course_detail_idを指定し、" do
            context "latitude,longitudeが引数として渡されている場合" do
                it "コース情報が更新されること" do
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],latitude: @upd_params[:latitude],longitude: @upd_params[:longitude],format: :json
                    json = JSON.parse(response.body)
                    expect(json["record"][-1]["latitude"]).to eq @upd_params[:latitude].to_s
                    expect(json["record"][-1]["longitude"]).to eq @upd_params[:longitude].to_s
                end
                it "successがtrueであること"do
                    # JSONの各値の確認
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],latitude: @upd_params[:latitude],longitude: @upd_params[:longitude],format: :json
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
            context "latitudeのみが引数として渡されている場合" do
                it "コース情報が更新されること" do
                    p @params[:longitude]
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],latitude: @upd_params[:latitude],format: :json
                    json = JSON.parse(response.body)
                    p json
                    expect(json["record"][-1]["latitude"]).to eq @upd_params[:latitude].to_s
                end
                it "successがtrueであること"do
                    #
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],latitude: @upd_params[:latitude],format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
            context "longitudeのみが引数として渡されている場合" do
                it "コース情報が更新されること" do
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],longitude: @upd_params[:longitude],format: :json
                    json = JSON.parse(response.body)
                    expect(json["record"][-1]["longitude"]).to eq @upd_params[:longitude].to_s
                end
                it "successがtrueであること"do
                    #
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],longitude: @upd_params[:longitude],format: :json
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_truthy
                end
            end
            context "latitude,longitudeが引数として渡されていない場合" do
                it "longitudee,longitudeがnillである旨のエラーメッセージが返ってくること"do
                    #
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],format: :json
                    json = JSON.parse(response.body)
                    expect(json["error_message"]).to_not be_nil
                end
                it "successがfalseであること"do
                    # JSONの各値の確認
                    patch course_detail_path course_id: @params[:course_id],course_detail_id: @params[:course_detail_id],format: :json
                    #JSONの確認
                    json = JSON.parse(response.body)
                    expect(json["success"]).to be_falsey
                end
            end
        end
        context "存在しない:course_idを指定した場合" do
            not_exist_course = FactoryGirl.build(:other_pattern_course)
            it "エラーメッセージが返ってくること"do
                #
                patch course_detail_path course_id: not_exist_course.course_id,course_detail_id: @params[:course_detail_id],format: :json
                json = JSON.parse(response.body)
                expect(json["error_message"]).to_not be_nil
            end
            it "successがfalseであること"do
                # JSONの各値の確認
                patch course_detail_path course_id: not_exist_course.course_id,course_detail_id: @params[:course_detail_id],format: :json
                #JSONの確認
                json = JSON.parse(response.body)
                expect(json["success"]).to be_falsey
            end
        end
        context "存在しない:course_detail_idを指定した場合" do
            not_exist_course_detail = FactoryGirl.build(:other_pattern_course_detail)
            it "エラーが発生すること"do
            expect{
                patch course_detail_path course_id: @params[:course_detail], course_detail_id: not_exist_course_detail.course_detail_id,format: :json
                }.to raise_error()
            end
        end
    end
    #削除処理
    describe "DELETE /course_details/:course_id/:course_detail_id.jsonのテスト" do
        before { @courseDetail = FactoryGirl.create(:course_detail) }
        context "存在する:course_id,:course_detail_idを指定した場合" do
            it "コース情報が削除されること" do
                # コース数が1減ることを確認
                bf=CourseDetail.count
                params = {course_id: @courseDetail.course_id,course_detail_id: @courseDetail.course_detail_id}
                delete course_detail_path(@courseDetail.course_id,@courseDetail.course_detail_id,format: :json),params
                af=CourseDetail.count
                expect(af-bf).to eq -1
            end
            it "successがtrueであること"do
            params = {course_id: @courseDetail.course_id,course_detail_id: @courseDetail.course_detail_id}
            delete course_detail_path(@courseDetail.course_id,@courseDetail.course_detail_id,format: :json),params
                #JSONの確認
                json = JSON.parse(response.body)
                expect(json["success"]).to be_truthy
            end
        end
        context "存在しない:course_idを指定した場合" do
            not_exist_course = FactoryGirl.build(:other_pattern_course)
            it "エラーが発生すること"do
                #
                params = {course_id: not_exist_course.course_id,course_detail_id: @courseDetail.course_detail_id}
                delete course_detail_path(not_exist_course.course_id,@courseDetail.course_detail_id,format: :json),params
                json = JSON.parse(response.body)
                p json
                expect(json["del_row_count"]).to eq 0
            end
        end
        context "存在しない:course_detail_idを指定した場合" do
            not_exist_course_detail = FactoryGirl.build(:other_pattern_course_detail)
            it "エラーが発生すること"do
                #
                params = {course_id: @courseDetail.course_id,course_detail_id: not_exist_course_detail.course_detail_id}
                delete course_detail_path(@courseDetail.course_id,not_exist_course_detail.course_detail_id,format: :json),params
                json = JSON.parse(response.body)
                p json
                expect(json["del_row_count"]).to eq 0
            end
        end
    end
end
