require 'rails_helper'

RSpec.describe Common, :type => :model do
    let(:arel){Course.make_search_condition("course_id",12,"eq")}
    let(:arel2){CourseDetail.make_search_condition("course_id",12,"eq")}
    let(:arel3){Course.make_search_condition("course_id",12,"eq")}
    let(:arel4){CourseDetail.make_search_condition("course_id",12,"eq")}
    subject{arel}
    context 'make_search_conditionメソッドのテスト' do
        context '有効なパラメータでのテスト'do
            context '引数が column: course_id,searchParam: 12,searchCondition: eqの場合' do
                    #引数は{model: モデル名,column:カラム名,searchParam: 検索パラメータ,searchCondition: 検索条件}のハッシュ
                    context '戻り値のクラスが' do
                        it {expect(arel.class).to eq(Arel::Nodes::Equality)}
                    end
                    context '検索対象テーブルが' do
                       it {expect(arel.left.relation.name).to eq("courses")}
                   end
                   context '検索対象カラムが' do
                    it {expect(arel.left.name).to eq("course_id")}
                end
                context '検索パラメータが' do
                    it {expect(arel.right).to eq(12)}
                end
            end
            context '引数が column => "user_id",searchParam => "12",searchCondition => "gteq"の場合' do
                let(:arel){Course.make_search_condition("user_id",12,"gteq")}
                context '戻り値のクラスが' do
                    it {expect(arel.class).to eq(Arel::Nodes::GreaterThanOrEqual)}
                end
                context '検索対象テーブルが' do
                    it {expect(arel.left.relation.name).to eq("courses")}
                end
                context '検索対象カラムが' do
                    it {expect(arel.left.name).to eq("user_id")}
                end
                context '検索パラメータが' do
                    it {expect(arel.right).to eq(12)}
                end
            end
            context '引数が column => "course_id",searchParam => "12",searchCondition => "lteq"の場合' do
                let(:arel){Course.make_search_condition("course_id",12,"lteq")}
                context '戻り値のクラスが' do
                    it {expect(arel.class).to eq(Arel::Nodes::LessThanOrEqual)}
                end
                context '検索対象テーブルが' do
                    it {expect(arel.left.relation.name).to eq("courses")}
                end
                context '検索対象カラムが' do
                    it {expect(arel.left.name).to eq("course_id")}
                end
                context '検索パラメータが' do
                    it {expect(arel.right).to eq(12)}
                end
            end
            context '引数が column => "user_id",searchParam => "12",searchCondition => "in"の場合' do
                let(:arel){Course.make_search_condition("course_id",[12,11],"in")}
                context '戻り値のクラスが' do
                    it {expect(arel.class).to eq(Arel::Nodes::In)}
                end
                context '検索対象テーブルが' do
                    it {expect(arel.left.relation.name).to eq("courses")}
                end
                context '検索対象カラムが' do
                    it {expect(arel.left.name).to eq("course_id")}
                end
                context '検索パラメータが' do
                    it {expect(arel.right).to eq([12,11])}
                end
            end
        end
        context '無効なパラメータでのテスト'do
            context '引数が column => "user_id",searchParam => "12",searchCondition => "eq"の場合' do
                let(:arel){Course.make_search_condition({'column' => "user_id",'searchParam' => "12",'searchCondition' => "eq"})}
                xit {expect(arel).to raise_error}
            end
        end
    end
    context 'bond_search_conditionのテスト' do
        context '有効なパラメータでのテスト'do
            context 'Arel::Nodesをandで連結させた場合' do
                let(:linkedArel){Course.bond_search_condition("and",arel,arel2)}
                    context '戻り値のクラスが' do
                        it {expect(linkedArel.class).to eq(Arel::Nodes::And)}
                end
            end
            context '2つのArel::Nodesを連結させた場合' do
                let(:linkedArel){Course.bond_search_condition("and",arel,arel2)}
                context '結合したArel::Nodes内のchildren変数の要素数が2であること' do
                   it {expect(linkedArel.children.length).to eq(2)}
                end
            end
            context '3つのArel::Nodesを連結させた場合' do
            let(:linkedArel){Course.bond_search_condition("and",arel,arel2,arel3)}
                context '結合したArel::Nodes内のchildren変数内のchildrenの要素数が2であること' do
                    it {expect(linkedArel.children[0].children.length).to eq(2)}
                end
            end
            context '4つのArel::Nodesを連結させた場合' do
                let(:linkedArel){Course.bond_search_condition("and",arel,arel2,arel3,arel4)}
                context '結合したArel::Nodes内のchildren変数内のchildren変数内のchildrenの要素数が2であること' do
                    it {expect(linkedArel.children[0].children[0].children.length).to eq(2)}
                end
            end
        end
        context 'Arel::Nodesをorで連結させた場合' do
            let(:linkedArel){Course.bond_search_condition("or",arel,arel2)}
            context '戻り値のクラスが' do
                it {expect(linkedArel.class).to eq(Arel::Nodes::Grouping)}
            end
            context '2つのArel::Nodesを連結させた場合' do
                let(:linkedArel){Course.bond_search_condition("or",arel,arel2)}
                context '結合したArel::Nodesが' do
                    it {expect(linkedArel.expr.right).to be_truthy}
                end
            end
            context '3つのArel::Nodesを連結させた場合' do
                let(:linkedArel){Course.bond_search_condition("or",arel,arel2,arel3)}
                context '結合したArel::Nodesが' do
                    it {expect(linkedArel.expr.left.expr.right).to be_truthy}
                end
            end
            context '4つのArel::Nodesを連結させた場合' do
                let(:linkedArel){Course.bond_search_condition("or",arel,arel2,arel3,arel4)}
                context '結合したArel::Nodesが' do
                    it {expect(linkedArel.expr.left.expr.left.expr.right).to be_truthy}
                end
            end
        end
    end
end
