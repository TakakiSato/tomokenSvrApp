require 'rails_helper'

RSpec.describe "Courses", :type => :request do

    describe "GET /courses.json" do
        #テストデータ作成
        before { @courses = FactoryGirl.create_list(:course,1)
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

        it "レスポンスコードが200であること" do
            # GET /courses.json にアクセスする
            get courses_path format: :json
            # ステータスコードの確認
            expect(response.status).to eq 200
        end

        context "一覧情報を取得できること" do
            context "user_id,緯度経度の条件を指定しない場合" do
                it "リクエストパラメータのuidが存在する latitude,logitudeがnillの場合"do
                    # GET /courses.json にアクセスする
                    get courses_path uid: @uid,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id
                end
                it "uidが存在しない latitude,logitudeがnill"do
                    # GET /courses.json にアクセスする
                    get courses_path uid: 1111111111,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                it "uidがnill latitude,logitudeが存在する。"do
                    # GET /courses.json にアクセスする
                    get courses_path latitude: @latitude,longitude: @longitude,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id

                end
                it "uidがnill latitude,logitudeが存在しない。"do
                    # GET /courses.json にアクセスする
                    get courses_path latitude: 11111111111111,longitude: 11111111111111,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                xit "uidがnill latitude,logitudeがnill"do
                    #両方nillであればエラー
                    # GET /courses.json にアクセスする
                    get courses_path format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                it "uidが存在する latitude,logitudeが存在する。"do
                    # GET /courses.json にアクセスする
                    get courses_path uid: @uid, latitude: @latitude,longitude: @longitude,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id
                end
            end

            context "user_id,緯度経度の条件をor条件とする場合" do
                it "リクエストパラメータのuidが存在する latitude,logitudeがnillの場合"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "or",uid: @uid,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id
                end
                it "uidが存在しない latitude,logitudeがnill"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "or",uid: 1111111111,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                it "uidがnill latitude,logitudeが存在する。"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "or",latitude: @latitude,longitude: @longitude,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id

                end
                it "uidがnill latitude,logitudeが存在しない。"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "or",latitude: 11111111111111,longitude: 11111111111111,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                it "uidが存在する。 latitude,logitudeが存在する。"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "or", uid: @uid, latitude: @latitude,longitude: @longitude,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id
                end
            end

            context "user_id,緯度経度の条件をand条件とする場合" do
                it "リクエストパラメータのuidが存在する latitude,logitudeがnillの場合"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "and",uid: @uid,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id
                end
                it "uidが存在しない latitude,logitudeがnill"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "and",uid: 1111111111,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                it "uidがnill latitude,logitudeが存在する。"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "and",latitude: @latitude,longitude: @longitude,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq @courses.count
                    expect(json[0]["course_id"]).to eq @course_id

                end
                it "uidがnill latitude,logitudeが存在しない。"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "and",latitude: 11111111111111,longitude: 11111111111111,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json.size).to eq 0
                end
                it "uidがn存在する。 latitude,logitudeが存在する。"do
                    # GET /courses.json にアクセスする
                    get courses_path linkCondition: "and", uid: @uid, latitude: @latitude , longitude: @longitude,format: :json
                    # JSONの確認
                    json = JSON.parse(response.body)
                    expect(json[0]["course_id"]).to eq @course_id
                end
            end
        end
    end

    #create
    describe "POST /courses.json" do
        before {
            @params = FactoryGirl.attributes_for(:course)
        }
        it "コース情報が作成されること" do
            # コース数が1増えることを確認
            bf=Course.count
            post courses_path(format: :json), @params
            af=Course.count
            p bf
            p af
            expect(af-bf).to eq 1
        end

        it "登録された値が正しいこと" do
            # JSONの各値の確認
            json = JSON.parse(response.body)
            expect(json["user_id"]).to  eq @params.user_id
            expect(json["course_name"]).to @params.course_name
        end

        xit "コース情報が作成されないこと" do
            # バリデーションエラーなどで作成されないようにし、帰り値を確認する
        end
    end

    #削除処理
    describe "DELETE /courses/:id.json" do
        before { @course = FactoryGirl.create(:course) }

        it "コース情報が削除されること" do
            # コース数が1増えることを確認
            bf=Course.count
            delete course_path(@course.course_id, format: :json)
            af=Course.count
            p bf
            p af
            expect(af-bf).to eq -1
        end
    end
end