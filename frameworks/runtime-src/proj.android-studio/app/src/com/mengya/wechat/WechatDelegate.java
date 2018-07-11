package com.mengya.wechat;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;

import com.common.CustomRunable;
import com.common.FYDSDK;
import com.mengya.constants.PurchaseCode;
import com.mengya.constants.SharePlatformType;
import com.tencent.mm.opensdk.modelpay.PayResp;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.SendAuth;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.tencent.mm.sdk.openapi.WXWebpageObject;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Date;

public class WechatDelegate extends BroadcastReceiver {

    private static final String TAG = "FYD";
    private static final String APP_ID = "wx272d396d103fbe71";

    private static final String APP_SECRET = "9f79c42520e953052f3da11dfe9fe5ce";

    private static final int THUMB_SIZE = 150;


    private static Cocos2dxActivity mActivity;

    private static String mRefreshToken;

    private static IWXAPI wxApi;

    private static WechatDelegate instance;

    private static int platform;

    private final static int SHARE_IMAGE  = 0x001;
    private static int CALL_BACK = 0x002;


    public synchronized static Object getInstance() {
        if (null == instance) {
            instance = new WechatDelegate();
        }
        return instance;
    }

    @Override
    public void onReceive(Context context, Intent data) {
        Bundle bundle = data.getExtras();
        // 微信支付
        if(data.hasCategory("wechat_pay"))
        {
            PayResp resp = new PayResp();
            resp.fromBundle(bundle);

            switch(resp.errCode){
                case 0:
                {
                    try {
                        JSONObject jsonObject1 = new JSONObject();
                        jsonObject1.put("action", "PAY");
                        jsonObject1.put("code", PurchaseCode.PURCHASE_SUCCESS.value());
                        jsonObject1.put("receipt", resp.returnKey);
                    }catch(Exception e){
                        Log.e(TAG,"error json object generate");
                    }
                }

                break;

                case -1:
                {
                    //支付错误， 可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
                    try {
                        JSONObject jsonObject1 = new JSONObject();
                        jsonObject1.put("action", "PAY");
                        jsonObject1.put("code", PurchaseCode.PURCHASE_ERROR.value());
                    }catch(Exception e){
                        Log.e(TAG,"error json object generate");
                    }
                }
                break;

                case -2:
                {
                    //用户取消，无需处理。发生场景：用户不支付了，点击取消，返回APP。
                    try {
                        JSONObject jsonObject1 = new JSONObject();
                        jsonObject1.put("action", "PAY");
                        jsonObject1.put("code", PurchaseCode.PURCHASE_CANCELED.value());
                    }catch(Exception e){
                        Log.e(TAG,"error json object generate");
                    }
                }
                break;

            }

        }
        // 微信登陆
        else if(data.hasCategory("wechat_auth"))
        {
            SendAuth.Resp authResp = new SendAuth.Resp();
            authResp.fromBundle(bundle);
            WechatDelegate.onAuthResponse(authResp);
        }
        // 微信分享
        else if(data.hasCategory("wechat_share"))
        {
            String errcode = bundle.getString("erro_code");
            WechatDelegate.onShareResponse(Integer.parseInt(errcode));
        }
    }

    public static void init(Activity activity){
        mActivity = (Cocos2dxActivity) activity;
        wxApi = WXAPIFactory.createWXAPI(mActivity, null);
        wxApi.registerApp(APP_ID);
    }

    // 微信是否安装
    public static boolean isWXAppInstalled()
    {
        return wxApi.isWXAppInstalled();
    }

    public static void signIn(int callBack)
    {
        CALL_BACK = callBack;
        try
        {
            InputStream in = mActivity.getContext().openFileInput("wechat.json");
            BufferedReader r = new BufferedReader(new InputStreamReader(in));

            StringBuilder sb = new StringBuilder();

            String line;
            while ((line = r.readLine()) != null) {
                sb.append(line);
            }

            JSONObject jObject = new JSONObject(sb.toString());

            if(jObject.has("expire_time"))
            {
                Date date = new Date();
                if((date.getTime()/1000) > jObject.getLong("expire_time"))
                {
                    refreshToken(jObject.getString("refresh_token"));
                }
                else
                {
                    mRefreshToken = jObject.getString("refresh_token");
                    try {
                        JSONObject jsonObject1 = new JSONObject();
                        jsonObject1.put("action", "AUTH");
                        jsonObject1.put("result", "success");
                        jsonObject1.put("openid", jObject.getString("openid"));
                        jsonObject1.put("access_token", jObject.getString("access_token"));
                        Object[] array = {jsonObject1.toString()};
                        FYDSDK.callBackWithVector(CALL_BACK,array);
                    }catch(Exception e) {
                        Log.e(TAG, "error json object generate");
                    }
                }
            }
            else
            {
                SendAuth.Req req = new SendAuth.Req();
                req.state = "aam";
                req.scope = "snsapi_base,snsapi_userinfo";
                wxApi.sendReq(req);
            }

            in.close();
        }
        catch (Exception e) {
            SendAuth.Req req = new SendAuth.Req();
            req.state = "game";
            req.scope = "snsapi_base,snsapi_userinfo";
            wxApi.sendReq(req);
        }
    }

    private static void doSendAuth(HttpGet request)
    {
        try
        {
            HttpClient client = new DefaultHttpClient();
            HttpResponse response = client.execute(request);

            // Check if server response is valid
            StatusLine status = response.getStatusLine();
            if (status.getStatusCode() != 200) {
                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("action", "AUTH");
                    jsonObject1.put("result", "failed");
                    Object[] array = {jsonObject1.toString()};
                    FYDSDK.callBackWithVector(CALL_BACK,array);

                return;
            }

            // Pull content stream from response
            HttpEntity entity = response.getEntity();
            InputStream inputStream = entity.getContent();

            StringBuilder sb = new StringBuilder();
            BufferedReader rd = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));

            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }

            JSONObject jObject = new JSONObject(sb.toString());

            if(jObject.has("errcode"))
            {
                int errcode = jObject.getInt("errcode");
                //刷新令牌失效, 重新拉取授权
                if(errcode == 40030 || errcode == 42002)
                {
                    SendAuth.Req req = new SendAuth.Req();
                    req.state = "game";
                    req.scope = "snsapi_base,snsapi_userinfo";
                    wxApi.sendReq(req);
                }
                else if(errcode == 42001)
                {
                    refreshToken(mRefreshToken);
                }
                else
                {
                        JSONObject jsonObject1 = new JSONObject();
                        jsonObject1.put("action", "AUTH");
                        jsonObject1.put("result", "failed");
                        Object[] array = {jsonObject1.toString()};
                        FYDSDK.callBackWithVector(CALL_BACK,array);
                }
            }
            else if(jObject.has("openid"))
            {
                Date date = new Date();
                //过期时间缩短一半
                jObject.put("expire_time", (date.getTime()/1000) + 1800);

                FileOutputStream out = mActivity.getContext().openFileOutput("wechat.json", Context.MODE_PRIVATE);
                out.write(jObject.toString().getBytes());
                out.close();

                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("action", "AUTH");
                    jsonObject1.put("result", "success");
                    jsonObject1.put("openid", jObject.getString("openid"));
                    jsonObject1.put("access_token", jObject.getString("access_token"));
                    Object[] array = {jsonObject1.toString()};
                    FYDSDK.callBackWithVector(CALL_BACK,array);
            }
            else
            {
                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("action", "AUTH");
                    jsonObject1.put("result", "failed");
                    Object[] array = {jsonObject1.toString()};
                    FYDSDK.callBackWithVector(CALL_BACK,array);
            }
        }

        catch (Exception e) {
            try {
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("action", "AUTH");
                jsonObject1.put("result", "failed");
                Object[] array = {jsonObject1.toString()};
                FYDSDK.callBackWithVector(CALL_BACK,array);
            }catch(Exception e1){
                Log.e(TAG,"error json object generate");
            }
            String str = e.getLocalizedMessage();
            Log.e(TAG, str);
        }

    }

    private static void refreshToken(String token)
    {

        CustomRunable runable = new CustomRunable(){
            private String _data;
            public void setData(String data){
                this._data = data;
            }
            @Override
            public void run() {
                HttpGet request = new HttpGet(String.format("https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%s&grant_type=refresh_token&refresh_token=%s", APP_ID, this._data));
                doSendAuth(request);
            }
        };
        runable.setData(token);
        new Thread(runable).start();
    }


    public static void onAuthResponse(SendAuth.Resp resp)
    {
        if(resp.errCode == BaseResp.ErrCode.ERR_USER_CANCEL)
        {
            try {
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("action", "AUTH");
                jsonObject1.put("result", "cancel");
                Object[] array = {jsonObject1.toString()};
                FYDSDK.callBackWithVector(CALL_BACK,array);
            }catch(Exception e){
                Log.e(TAG,"error json object generate");
            }
            return;
        }
        else if(resp.errCode != BaseResp.ErrCode.ERR_OK)
        {
            try {
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("action", "AUTH");
                jsonObject1.put("result", "failed");
                Object[] array = {jsonObject1.toString()};
                FYDSDK.callBackWithVector(CALL_BACK,array);
            }catch(Exception e){
                Log.e(TAG,"error json object generate");
            }
            return;
        }


        CustomRunable runable = new CustomRunable(){
            private String _data;
            public void setData(String data){
                this._data = data;
            }
            @Override
            public void run() {
                HttpGet request = new HttpGet(String.format("https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code", APP_ID, APP_SECRET,this._data));
                doSendAuth(request);
            }
        };
        runable.setData(resp.token);
        new Thread(runable).start();

    }

    public static void onShareResponse(int errCode)
    {

        if(errCode == BaseResp.ErrCode.ERR_OK)
        {
            if(platform !=SharePlatformType.WECHAT_FRIEND.value()) {
                try {
                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("action", "SHARE");
                    jsonObject1.put("result", "success");
                    Object[] array = {jsonObject1.toString()};
                    FYDSDK.callBackWithVector(CALL_BACK,array);
                } catch (Exception e) {
                    Log.e(TAG, "error json object generate");
                }
            }
            return;
        }
        else
        {
            if(platform !=SharePlatformType.WECHAT_FRIEND.value()) {
                try {
                    JSONObject jsonObject1 = new JSONObject();
                    jsonObject1.put("action", "SHARE");
                    jsonObject1.put("result", "failed");
                    Object[] array = {jsonObject1.toString()};
                    FYDSDK.callBackWithVector(CALL_BACK,array);
                } catch (Exception e) {
                    Log.e(TAG, "error json object generate");
                }
            }
            return;
        }
    }


    public static void wxshareImg(String imgStr,int callBack)
    {
        if(!wxApi.isWXAppInstalled()){
            try {
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("action", "SHARE");
                jsonObject1.put("result", "un_install_wechat");

                Object[] array = {jsonObject1.toString()};
                FYDSDK.callBackWithVector(callBack,array);
            }catch(Exception e) {
                Log.e(TAG, "error json object generate");
            }
            return;
        }

        CALL_BACK = callBack;

        Bitmap  bmp = BitmapFactory.decodeFile(imgStr);
        WXImageObject imgObj = new WXImageObject(bmp);
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = imgObj;

        //设置缩略图
        Bitmap thumpBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
        bmp.recycle();
        msg.thumbData = bmpToByteArray(thumpBmp, true);
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.message = msg;
        wxApi.sendReq(req);
    }

    public static void shareURL(int plat, String titleStr, String desStr, String urlStr, String imgStr,int callBack)
    {
        // Log.e("wxshareURL", "wxshareURL");
        // Log.d("wxshareURL", "wxshareURL" + platform + titleStr + desStr + urlStr+ "图片路径：" + imgStr);
        if(!wxApi.isWXAppInstalled()){
            try {
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("action", "SHARE");
                jsonObject1.put("result", "un_install_wechat");
                Object[] array = {jsonObject1.toString()};
                FYDSDK.callBackWithVector(callBack,array);
            }catch(Exception e) {
                Log.e(TAG, "error json object generate");
            }
            return;
        }
        CALL_BACK = callBack;
        platform = plat;



        WXWebpageObject webpage = new WXWebpageObject();
        webpage.webpageUrl = urlStr;

        WXMediaMessage msg = new WXMediaMessage(webpage);
        msg.title = titleStr;
        msg.description = desStr;

        Bitmap bmp = getBitmap(mActivity);

        //设置缩略图
        Bitmap thumpBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE, THUMB_SIZE, true);
        bmp.recycle();
        msg.thumbData = bmpToByteArray(thumpBmp, true);
        //构造一个Req
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        //req.transaction = "webpage";
        req.message = msg;
        if(platform == SharePlatformType.WECHAT_FRIEND.value()){
            req.scene = SendMessageToWX.Req.WXSceneSession;
            try {
                JSONObject jsonObject1 = new JSONObject();
                jsonObject1.put("action", "SHARE");
                jsonObject1.put("result", "success");
                Object[] array = {jsonObject1.toString()};
                FYDSDK.callBackWithVector(CALL_BACK,array);
            } catch (Exception e) {
                Log.e(TAG, "error json object generate");
            }
        } else{
            req.scene = SendMessageToWX.Req.WXSceneTimeline;
        }

        wxApi.sendReq(req);

    }

    public static synchronized Bitmap getBitmap(Context context) {
        PackageManager packageManager = null;
        ApplicationInfo applicationInfo = null;
        try {
            packageManager = context.getApplicationContext()
                    .getPackageManager();
            applicationInfo = packageManager.getApplicationInfo(
                    context.getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            applicationInfo = null;
        }
        Drawable d = packageManager.getApplicationIcon(applicationInfo); //xxx根据自己的情况获取drawable
        BitmapDrawable bd = (BitmapDrawable) d;
        Bitmap bm = bd.getBitmap();
        return bm;
    }



    public static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bmp.compress(CompressFormat.JPEG, 100, output);
        if (needRecycle) {
            bmp.recycle();
        }

        byte[] result = output.toByteArray();
        try {
            output.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

}


