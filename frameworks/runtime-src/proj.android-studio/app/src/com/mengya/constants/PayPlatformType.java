package com.mengya.constants;

public enum PayPlatformType 
{
	APPSTORE(0),
	WECHAT(1),
	ALIPAY(2),
	BAIDU(3),
	XIAOMI(4),
	SNDA(5),
	BUKA(6);

	private int value = 0;

	private PayPlatformType(int v)
	{
		value = v;
	}

	public int value()
	{
		return this.value;
	}

	public boolean equals(int v)
	{
		return value == v;
	}
}
