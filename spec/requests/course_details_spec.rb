require 'rails_helper'

RSpec.describe "CourseDetails", :type => :request do
    describe "GET /course_details.json" do
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

        it "レスポンスコードが200であること" do
            # GET /course_details.json にアクセスする
            get course_details_path course_id: @course_id ,format: :json
            # ステータスコードの確認
            expect(response.status).to eq 200
        end

        context "一覧情報を取得できること" do
            it "course_idを指定する場合"do
                # GET /course_details.json にアクセスする
                get course_details_path course_id: @course_id ,format: :json
                # JSONの確認
                json = JSON.parse(response.body)
                p json
                expect(json.size).to eq @courseDetails.count
                expect(json[-1]["course_detail_id"]).to eq @courseDetailId
                expect(json[-1]["course_id"]).to eq @courseId
                expect(json[-1]["latitude"]).to eq @latitude.to_s
                expect(json[-1]["longitude"]).to eq @longitude.to_s
            end
        end
    end
            #create
    describe "POST /course_details.json" do
        before {
            @params = FactoryGirl.attributes_for(:course_detail)
        }
        it "コース情報が作成されること" do
            # コース数が1増えることを確認
            bf=CourseDetail.count
            post course_details_path(format: :json), @params
            af=CourseDetail.count
            p bf
            p af
            expect(af-bf).to eq 1
        end

        it "登録された値が正しいこと" do
            # JSONの各値の確認
            post course_details_path(format: :json), @params
            p response.body
            json = JSON.parse(response.body)
            expect(json["course_detail_id"]).to  eq @params.course_detail_id
            expect(json["course_id"]).to @params.course_id
            expect(json["latitude"]).to  eq @params.latitude
            expect(json["longitude"]).to @params.longitude
        end

        xit "コース情報が作成されないこと" do
            # バリデーションエラーなどで作成されないようにし、帰り値を確認する
        end
    end

    #削除処理
    describe "DELETE /course_details/:id.json" do
        before { @courseDetail = FactoryGirl.create(:course_detail) }
        it "コース情報が削除されること" do
            # コース数が1減ることを確認
            bf=CourseDetail.count
            params = {course_id: @courseDetail.course_id,course_detail_id: @courseDetail.course_detail_id}
            delete course_detail_path(@courseDetail.course_id,@courseDetail.course_detail_id,format: :json),params
            af=CourseDetail.count
            p bf
            p af
            expect(af-bf).to eq -1
        end
    end

end
