$(function () {
    // グローバル変数
    var syncerWatchPosition = {
        count: 0 ,
        lastTime: 0 ,
        map: null ,
        marker: null ,
        nowTime: 0
    } ;
    // 成功した時の関数
    function successFunc( position )
    {
        // 取得したデータの整理
        var data = position.coords ;
        // 位置情報
        var latlng = new google.maps.LatLng( data.latitude , data.longitude ) ;
        // Google Mapsに書き出し
        syncerWatchPosition.map = new google.maps.Map( document.getElementById( 'map-canvas' ) , {
                zoom: 15 ,              // ズーム値
                center: latlng ,        // 中心座標 [latlng]
            } ) ;
        //開いた情報ウィンドウを格納しておく
        var currentInfoWindow=[];
        // マーカーの新規出力
        syncerWatchPosition.marker = new google.maps.Marker( {
            map: syncerWatchPosition.map ,
            position: latlng ,
        } ) ;
        //mapの表示範囲が変更されたら以下のイベント実行
        google.maps.event.addListener( syncerWatchPosition.map , 'dragend' , function(){
            //先に開いた情報ウィンドウがあれば、closeする
            MarkerClear(currentInfoWindow);

            //地図の中心の座標を取得
            var mapCenterLatLng = syncerWatchPosition.map.getCenter();
            //DBにアクセスした結果の配列定義
            //DBにアクセスして周辺の位置情報を取得する。　couresの検索
            $.get("/courses.json?latitude=" + mapCenterLatLng.lat() + "&longitude=" + mapCenterLatLng.lng()).done(function(courses){
                var i=0;
                while( i < courses.record.length){
                    var courses_info=courses.record[i];
                    console.log(courses_info);
                   //course_detailsの検索
                   $.get("/course_details/" + courses_info.course_id + ".json").done(function(course_details){
                    mapRender( courses_info,course_details.record );
                });
                   i++;
               };
           });
        });

        // 地図にコースを描画
        function mapRender( courses,course_details_array ){
            //情報ウィンドウ表示//////////////////////////////////////////////
            // 情報ウィンドウのインスタンスを格納する配列
            var infoWindows = [] ;
            var i = 0 ;
            //緯度経度をmap用に変換
            //var course_latlng = new google.maps.LatLng( course_details_array[i].latitude , course_details_array[i].longitude );
            var course_latlng = new google.maps.LatLng( course_details_array[0].latitude , course_details_array[0].longitude );
            //情報ウィンドウオブジェクト作成
            var info_window = new google.maps.InfoWindow({
                content: courses.course_name ,
                position: course_latlng
            });
            // 情報ウィンドウ(のインスタンス)を地図に設置(レンダリング)する
            info_window.open( syncerWatchPosition.map ) ;
            //開いたウィンドウを保存
            currentInfoWindow.push(info_window);
            //線表示//////////////////////////////////////////////
            // 線(Polyline)のインスタンスを格納する配列
            var polylines = [] ;
            var j = 0;
            var path = [ ] ;
            while(j < course_details_array.length){
                // 1つ目の線(Polyline)のインスタンスを作成する
                // [ new google.maps.Polyline() ]の引数にオプションオブジェクトを指定する
                path.push(new google.maps.LatLng(course_details_array[j].latitude, course_details_array[j].longitude ))
                j++;
            }
            console.log("aaaaaaaaaaaa");
            console.log(path);
            polylines[0] = new google.maps.Polyline( {
                map: syncerWatchPosition.map ,
                path: path,
            } ) ;
        };
    };
    //情報ウィンドウ初期化
    function MarkerClear(currentInfoWindow) {
        //表示中のマーカーがあれば削除
        if(currentInfoWindow.length > 0){
            //マーカー削除
            for (i = 0; i <  currentInfoWindow.length; i++) {
                currentInfoWindow[i].close();
            }
            //配列削除
            for (i = 0; i <=  currentInfoWindow.length; i++) {
                currentInfoWindow=[];
            }
        }
    }


    // 失敗した時の関数
    function errorFunc( error )
    {
        // エラーコード(error.code)の番号
        // 0:UNKNOWN_ERROR              原因不明のエラー
        // 1:PERMISSION_DENIED          利用者が位置情報の取得を許可しなかった
        // 2:POSITION_UNAVAILABLE       電波状況などで位置情報が取得できなかった
        // 3:TIMEOUT                    位置情報の取得に時間がかかり過ぎた…

        // エラー番号に対応したメッセージ
        var errorInfo = [
        "原因不明のエラーが発生しました…。" ,
        "位置情報の取得が許可されませんでした…。" ,
        "電波状況などで位置情報が取得できませんでした…。" ,
        "位置情報の取得に時間がかかり過ぎてタイムアウトしました…。"
        ] ;
        // エラー番号
        var errorNo = error.code ;
        // エラーメッセージ
        var errorMessage = "[エラー番号: " + errorNo + "]\n" + errorInfo[ errorNo ] ;
        // アラート表示
        alert( errorMessage ) ;
        // HTMLに書き出し
        document.getElementById("result").innerHTML = errorMessage;
    }

    // ユーザーの端末がGeoLocation APIに対応しているかの判定
    // 対応している場合
    if( navigator.geolocation )
    {
        // オプション・オブジェクト
        var optionObj = {
            "enableHighAccuracy": false ,
            "timeout": 1000000 ,
            "maximumAge": 0 ,
        } ;
        // 現在地を取得
        navigator.geolocation.getCurrentPosition(successFunc , errorFunc , optionObj) ;
    }
    // 対応していない場合
    else
    {
        // エラーメッセージ
        var errorMessage = "お使いの端末は、GeoLacation APIに対応していません。" ;

        // アラート表示
        alert( errorMessage ) ;

        // HTMLに書き出し
        document.getElementById( 'result' ).innerHTML = errorMessage ;
    }

    // 成功した時の関数
    var course_id ;

    function recordingFunc( position ){
        // 取得したデータの整理
        var nowTime = ~~( new Date() / 1000 ) ; // UNIX Timestamp
        // 前回の書き出しから3秒以上経過していたら描写
        // 毎回HTMLに書き出していると、ブラウザがフリーズするため
        if( (syncerWatchPosition.lastTime + 10) > nowTime )
        {
            return false ;
        }else{
            var data = position.coords ;
            console.log(course_id);
            $.post("/course_details/" + course_id + ".json",{"latitude": data.latitude,"longitude": data.longitude}).done(function(course_details){
                console.log(course_details);
            });
        }
        // 位置情報
        var latlng = new google.maps.LatLng( position.coords.latitude , position.coords.longitude ) ;
        // 前回の時間を更新
        syncerWatchPosition.lastTime = nowTime ;
        // 地図の中心を変更
        syncerWatchPosition.map.setCenter( latlng ) ;

        // マーカーの場所を変更
        syncerWatchPosition.marker.setPosition( latlng ) ;
    }

    //登録プロセスID
    var watchId;
    //コースレコードボタンが押されたとき
    $("#course_recoreding").click(function() {
        var onOff = $("#course_recoreding").prop('checked');
        console.log(onOff);
        if (onOff==1){
            $.post("/courses.json").done(function(course){
                // オプション・オブジェクト
                var optionObj = {
                    "enableHighAccuracy": false ,
                    "timeout": 1000000 ,
                    "maximumAge": 0 ,
                } ;
                console.log(course);
                course_id = course["course_id"]
                //登録開始
                watchId=navigator.geolocation.watchPosition( recordingFunc , errorFunc , optionObj ) ;
            });
        }else{
            //登録終了
            var confirm_result = confirm( "コースの記録を終了しますか?" );
            //記録終了
            navigator.geolocation.clearWatch(watchId);
            if(confirm_result){
                //無限ループ(コース名登録されるまで)
                var not_finish=true
                while(not_finish){
                    var course_name = prompt( "コース名を入力してください。" , "" );
                    if(course_name){
                        break;
                    }
                }
                //コース名を登録する。
                $.ajax ({
                    url: "/courses/" + course_id + ".json",
                    method: 'PATCH',
                    data: {course_name: course_name},
                    success: function(course){
                        console.log(course["success"])
                        //コース登録結果確認
                        if (course["success"]==true){
                            // 現在地を取得
                            navigator.geolocation.getCurrentPosition(successFunc , errorFunc , optionObj) ;
                            console.log("フラグ変更")
                            //コース名登録されたら終了
                            not_finish=false;
                        }else{
                            if (course["success"]==false){
                                alert(course["error_message"]);
                            }
                        }
                    }
                });
            }
        }
    });
});