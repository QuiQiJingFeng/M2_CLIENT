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

public class Utils {
    private Activity __activity;
    private Utils() {}
    private static Utils __instance = null;
    public static synchronized Object getInstance(){
        if (__instance == null) {
            __instance = new Utils();
        }
        return __instance;
    }

	
    protected static final String PREFS_FILE = "device_info.xml";
    protected static final String PREFS_DEVICE_ID = "device_id";
    protected static final String PREFS_DEVICE_TYPE = "device_type";

    public void init(Activity activity){
        __activity = (Cocos2dxActivity) activity;
     }

     /*
        获取设备ID
     */
    public String getDeviceId() {
        final SharedPreferences prefs = __activity.getSharedPreferences(PREFS_FILE, 0);
        String id = prefs.getString(PREFS_DEVICE_ID, null);

        if (id == null) {
            TelephonyManager teleMgr = (TelephonyManager) __activity.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
            id = teleMgr.getDeviceId();

            if (id == null) {
                try {
                    final String androidId = Settings.Secure.getString(__activity.getContentResolver(), Settings.Secure.ANDROID_ID);
                    id = androidId;
                } catch (Exception e) {
                    id = "unknown";
                }
            }

            prefs.edit().putString(PREFS_DEVICE_ID, id).commit();
        }
        return id;
    }
    /*
     * 获取设备类型
    */
    public String getDeviceType(){
        final SharedPreferences prefs = __activity.getSharedPreferences(PREFS_FILE, 0);
        
        String type = prefs.getString(PREFS_DEVICE_TYPE, null);
        if(type == null){
            type = Build.MANUFACTURER + "-" + Build.MODEL + "-" + Build.VERSION.SDK;
            prefs.edit().putString(PREFS_DEVICE_TYPE, type).commit();
        }
        return type;
    }
}