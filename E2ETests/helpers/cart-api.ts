import { APIRequestContext } from '@playwright/test';

/**
 * Direct API helpers for the cart endpoints.
 * Used by API specs and to seed state in UI specs (via request context).
 */

export interface AddToCartPayload {
  id: number;
  price?: number | string;
  type?: number;
  qty?: number;
  searchId?: string;
}

export interface CartApiResponse {
  success: boolean;
  message: string;
  cartCount: number;
  productsPrice?: string;
  shippingFee?: string;
  totalAmount?: string;
}

/** POST /api/cart/add */
export async function apiAddToCart(request: APIRequestContext, payload: AddToCartPayload): Promise<CartApiResponse> {
  const res = await request.post('/api/cart/add', { data: payload });
  return { status: res.status(), ...(await res.json()) } as any;
}

/** POST /api/cart/adjust */
export async function apiAdjustCart(request: APIRequestContext, payload: AddToCartPayload): Promise<CartApiResponse> {
  const res = await request.post('/api/cart/adjust', { data: payload });
  return { status: res.status(), ...(await res.json()) } as any;
}
