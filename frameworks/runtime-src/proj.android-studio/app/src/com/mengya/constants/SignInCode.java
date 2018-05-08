package com.mengya.constants;

public enum SignInCode
{
	START(0),
	SUCCESS(1),
	FAILURE(2),
	CANCEL(3),
	IN_PROGRESS(4);

	private int value = 0;

	private SignInCode(int v)
	{
		value = v;
	}

	public int value()
	{
		return this.value;
	}
}
