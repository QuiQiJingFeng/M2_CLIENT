package com.mengya.constants;

public enum AccountPlatformType 
{
	MU77(0),
	WECHAT(1),
	QQ(2),
	SNDA(3),
	BAIDU(4),
	XIAOMI(5),
	UC(6),
	BUKA(7);

	private int value = 0;

	private AccountPlatformType(int v)
	{
		value = v;
	}

	public int value()
	{
		return this.value;
	}
}
