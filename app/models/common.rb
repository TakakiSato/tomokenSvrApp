module Common
    class ActiveRecord::Base
        class << self
            def make_search_condition(column,searchParam,searchCondition)
                #引数は{column:カラム名,searchParam: 検索パラメータ,searchCondition: 検索条件}
                #検索パラメータは検索したいカラムの具体的な値。
                #searchConditionは eq(=) gteq(>=) lteq(<=) betweenで指定する。一つのみ指定可

                #モデル名のarel_tableを作成し、where句の中身を作成する。
                #arelBase = searchCondionHash.with_indifferent_access[:model].arel_table
                #calssifyでRailsのクラス名として適切な文字列にに変換
                #constantizeで引数の文字列で指定した名前で定数にする。
                    arel=self.class_name.classify.constantize.arel_table[column].send(searchCondition,searchParam)
                #戻り値はArel:Node
                return arel
            end

            def bond_search_condition(linkCondition,searchArelArray)
                #引数はlinkConditionが連結条件(and or) searchArelArrayがmakeSearchConditonで生成されたArel:Nodeの配列,
                #渡されたsearchArelArrayをlinkConditonで連結させる。
                linkedArel=searchArelArray[0]
                for i in 0..searchArelArray.length-2
                    linkedArel=linkedArel.send(linkCondition,searchArelArray[i+1])
                end
                return linkedArel
                #searchArelArrayのindex番号が0以下の場合エラーとする。
            end
        end
    end
end
