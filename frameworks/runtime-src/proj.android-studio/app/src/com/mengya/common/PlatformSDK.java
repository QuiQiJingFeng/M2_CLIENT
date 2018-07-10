package com.mengya.common;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

public class PlatformSDK{
      private static int __call_back;
      private static Cocos2dxActivity mActivity;
      protected static final String PREFS_FILE = "mengya_device_id.xml";
      protected static final String PREFS_DEVICE_ID = "device_id";

     public static void init(Activity activity){
        mActivity = (Cocos2dxActivity) activity;
     }

	  public static void registerCallBack(int call_back){
          if(call_back > 0) {
              __call_back = call_back;
              Cocos2dxLuaJavaBridge.retainLuaFunction(__call_back);
          }else{
              Log.e("FYD","CALL BACK ID == 0");
          }
      }

      public static void invokeCallBack(String value){
          Cocos2dxLuaJavaBridge.callLuaFunctionWithString(__call_back,
                  value);
      }

    public static String getDeviceInfo() {
        final SharedPreferences prefs = mActivity.getSharedPreferences(PREFS_FILE, 0);
        String id = prefs.getString(PREFS_DEVICE_ID, null);

        if (id == null) {
            TelephonyManager teleMgr = (TelephonyManager) mActivity.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
            id = teleMgr.getDeviceId();

            if (id == null) {
                try {
                    final String androidId = Settings.Secure.getString(mActivity.getContentResolver(), Settings.Secure.ANDROID_ID);
                    if (!"9774d56d682e549c".equals(androidId)) {
                        id = androidId;
                    }
                } catch (Exception e) {
                    id = "unknown";
                }
            }

            prefs.edit().putString(PREFS_DEVICE_ID, id).commit();
        }
        return "{\"device_id\":\"" + id + "\"," + "\"device_type\":\"" + Build.MANUFACTURER + "-" + Build.MODEL + "-" + Build.VERSION.SDK + "\"}";
    }
}