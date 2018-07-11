package com.common;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipDescription;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import org.cocos2dx.lib.Cocos2dxActivity;

public class Device {
    private Activity __activity;
    private Device() {}
    private static Device __instance = null;
    public static synchronized Object getInstance(){
        if (__instance == null) {
            __instance = new Device();
        }
        return __instance;
    }

    protected static final String PREFS_FILE = "device_info.xml";
    protected static final String PREFS_DEVICE_ID = "device_id";
    protected static final String PREFS_DEVICE_TYPE = "device_type";
    private static ClipboardManager __manater;

    public void init(Activity activity){

        __activity = (Cocos2dxActivity) activity;

        __manater = (ClipboardManager) __activity.getSystemService(Context.CLIPBOARD_SERVICE);
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

    /*
    * 复制内容到剪切板
    * */
    public boolean copyToClipBoard(String content){
        try {
            ClipData data = ClipData.newPlainText("com_mengya_game", content);
            __manater.setPrimaryClip(data);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public String getClipFromBoard() {
        try {
            //判断剪贴板里是否有内容
            if (!__manater.hasPrimaryClip()) {
                return "";
            }

            ClipData clip = __manater.getPrimaryClip();
            String text = clip.getItemAt(0).getText().toString();
            return text;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }
}