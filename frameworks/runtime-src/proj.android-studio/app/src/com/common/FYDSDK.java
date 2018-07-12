package com.common;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;

public class FYDSDK {
	public native static void callBackWithVector(int funcId,Object[] vector);

	public static final int CALL_BACK = 0X0001;

	public static interface CallFunc {
		void exec();
	}
	//主线程
	public static Handler handler = new Handler(Looper.getMainLooper()){
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
				case CALL_BACK:
				{
					CallFunc callBack = (CallFunc)msg.obj;
					callBack.exec();
				}
				break;
				default:
					break;
			}
		}
	};
}