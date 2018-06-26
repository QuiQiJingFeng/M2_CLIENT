package com.mengya.game.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;


public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

	private IWXAPI api;
	public static final String APP_ID = "wx272d396d103fbe71";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
//		setContentView(R.layout.pay_result);

		api = WXAPIFactory.createWXAPI(this, APP_ID);
		api.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req)
       	{
	}

	@Override
	public void onResp(BaseResp resp)
       	{
		switch(resp.getType()) {
			case ConstantsAPI.COMMAND_PAY_BY_WX:
			{
//				PayResp payResp = (PayResp) resp;
				BaseResp payResp = resp;
				Intent intent = new Intent();
				intent.setAction("com.mengya.game.Intent.WECHAT_PAY");
				intent.addCategory("wechat_pay");

				Bundle bundle = new Bundle();
				payResp.toBundle(bundle);
				intent.putExtras(bundle);

				sendBroadcast(intent);
				finish();
			}
			break;
		}
	}
}
