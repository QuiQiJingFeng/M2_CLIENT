/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2017 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.mengya.game;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.service.LocationService;
import com.common.Device;
import com.common.FYDSDK;
import com.mengya.wechat.WechatDelegate;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONObject;

public class AppActivity extends Cocos2dxActivity{

    private static LocationService __locationService;
    private static int CALL_BACK = 0x0;
    private static Activity __activity;

    protected void onCreate(Bundle savedInstanceState) {
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        super.onCreate(savedInstanceState);
        WechatDelegate.init(this);
        ((Device)Device.getInstance()).init(this);
        __activity = this;

        // -----------location config ------------
        __locationService = new LocationService(this);
        __locationService.registerListener(__mListener);
    }

    public static void start(int callBack) {
        CALL_BACK = callBack;
        Log.d("FYD--->>>","start");
        __activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //注册监听
                __locationService.setLocationOption(__locationService.getDefaultLocationClientOption());
                // start之后会默认发起一次定位请求，开发者无须判断isstart并主动调用request
                __locationService.start();// 定位SDK
            }
        });
    }

    private BDAbstractLocationListener __mListener = new BDAbstractLocationListener() {

        @Override
        public void onReceiveLocation(BDLocation location) {
            Log.d("FYD--->>>","onReceiveLocation");
            // TODO Auto-generated method stub
            if (null != location && location.getLocType() != BDLocation.TypeServerError) {
                try {
                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("time", location.getTime());
                    jsonObject1.put("latitude", location.getLatitude());
                    jsonObject1.put("lontitude", location.getLongitude());

                    Object[] array = {jsonObject1.toString()};
                    FYDSDK.callBackWithVector(CALL_BACK,array);
                    __locationService.stop(); //停止定位服务
                }catch(Exception e) {
                    Log.e("FYD", "error json object generate");
                }
            }
        }

    };
}


































