package com.mengya.constants;

public enum PurchaseCode
{
	PURCHASE_NOT_AVAILABLE(0),
	RECV_PRODUCT_LIST(1),
	PRODUCT_LIST_EMPTY(2),

	PURCHASE_START(3),
	PURCHASE_SUCCESS(4),
	PURCHASE_ERROR(5),
	PURCHASE_CANCELED(6),
	PURCHASE_RESTORE(7);

	private int value = 0;

	private PurchaseCode(int v)
	{
		value = v;
	}

	public int value()
	{
		return this.value;
	}
}
