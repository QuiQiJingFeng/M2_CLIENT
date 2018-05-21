package com.mengya.constants;

public enum SharePlatformType 
{
	WECHAT_FRIEND(0),
	WECHAT_CIRCLE(1),
	QQZONE(2),
	WEIBO(3),
	FACEBOOK(4),
	QQ(5);

	private int value = 0;

	private SharePlatformType(int v)
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
