package com.common;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;
import android.os.Message;

/*
	参考 android官网:https://developer.android.com/guide/topics/location/strategies
*/
public class PhoneLocation {
    private PhoneLocation() {}
    private static PhoneLocation __instance = null;
    public static synchronized Object getInstance(){
        if (__instance == null) {
            __instance = new PhoneLocation();
        }
        return __instance;
    }

    private LocationManager __locationManager = null;
    private Activity __activity = null;
    private LocationListener __locationListener = null;

    public void initWithActivity(Activity activity){
        __activity = activity;
        __locationManager = (LocationManager) __activity.getSystemService(Context.LOCATION_SERVICE);
    }
    /*
    * @lua
    * 注册
    * locationType(String) =>(network/gps)
    * 返回handle_id 移除监听时用到
    * */
    public boolean registerHandler(final String locationType, final int funcId){

        if(__locationManager.getProvider(locationType) == null){
            return false;
        }

        if(__locationListener != null){
            return false;
        }

        if(Looper.myLooper() != Looper.getMainLooper()) {
            Message message = new Message();
            message.what = FYDSDK.CALL_BACK;
            FYDSDK.CallFunc call = () -> this.registerHandler(locationType, funcId);
            message.obj = call;
            FYDSDK.handler.sendMessage(message);
            return true;
        }

        __locationListener = new LocationListener() {
            public void onLocationChanged(Location location) {
                // Called when a new location is found by the network location provider.
                Object[] array = {"LOCATION_CHANGE",location.toString()};
                FYDSDK.callBackWithVector(funcId,array);
            }
            /*
            // GPS状态为可见时
            LocationProvider.AVAILABLE:
            // GPS状态为服务区外时
            LocationProvider.OUT_OF_SERVICE:
            // GPS状态为暂停服务时
            LocationProvider.TEMPORARILY_UNAVAILABLE:
            */
            public void onStatusChanged(String provider, int status, Bundle extras) {
                Object[] array = {"STATUS_CHANGED",status};
                FYDSDK.callBackWithVector(funcId,array);
            }

            public void onProviderEnabled(String provider) {
                Object[] array = {"PROVIDER_ENABLED"};
                FYDSDK.callBackWithVector(funcId,array);
            }

            public void onProviderDisabled(String provider) {
                Object[] array = {"PROVIDER_DISABLED"};
                FYDSDK.callBackWithVector(funcId,array);
            }
        };
        __locationManager.requestLocationUpdates(locationType, 0, 0, __locationListener);
        return true;
    }
    //移除注册
    public boolean unregisterHandler(){
        if(__locationListener != null){
            __locationManager.removeUpdates(__locationListener);
            __locationListener = null;
            return true;
        }

        return false;
    }
    /*
    * 获取最后一次的定位
    * locationType(String) =>(network/gps)
    * */
    public String getLastLocation(String locationType){
        Location lastKnownLocation = __locationManager.getLastKnownLocation(locationType);
        String result = "";
        if(lastKnownLocation != null){
            result = lastKnownLocation.toString();
        }
        return result;
    }



}
