package com.mengya.game.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.tencent.mm.sdk.openapi.BaseReq;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.ConstantsAPI;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.SendAuth;
import com.tencent.mm.sdk.openapi.WXAPIFactory;


public class WXEntryActivity extends Activity implements IWXAPIEventHandler
{
	public static final String APP_ID = "wx272d396d103fbe71";
	private IWXAPI api;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// 通过WXAPIFactory工厂，获取IWXAPI的实例
		api = WXAPIFactory.createWXAPI(this, APP_ID, false);

		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		setIntent(intent);
		api.handleIntent(intent, this);
	}

	// 微信发送请求到第三方应用时，会回调到该方法
	@Override
	public void onReq(BaseReq req) {

	}

	// 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
	@Override
	public void onResp(BaseResp resp) {
		switch(resp.getType()) {
			case ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX:
			{
				onShareResp(resp.errCode);
			}
			break;
			case ConstantsAPI.COMMAND_SENDAUTH:
			{
				SendAuth.Resp authResp = (SendAuth.Resp) resp;
				onAuthResp(authResp);
			}
			break;
		}

	}

	private void onAuthResp(SendAuth.Resp resp)
	{
		Intent intent = new Intent();
		intent.setAction("com.mengya.game.Intent.WECHAT_AUTH");
		intent.addCategory("wechat_auth");

		Bundle bundle = new Bundle();
		resp.toBundle(bundle);
		intent.putExtras(bundle);

		sendBroadcast(intent);
		finish();
	}

	private void onShareResp(int erro_code)
	{
		Intent intent = new Intent();
		intent.setAction("com.mengya.game.Intent.WECHAT_SHARE");
		intent.addCategory("wechat_share");

		intent.putExtra("erro_code", erro_code + "");

		sendBroadcast(intent);
		finish();
	}
}
