import cookie from 'cookie';
import { User } from 'lib/user/types';
import { NextApiRequest, NextApiResponse } from 'next';

export type MeResponse = {
  success: boolean;
  data?: User | {};
  message: string;
};

export async function getMe(token: string): Promise<Response> {
  const { KONG_GATEWAY_ENDPOINT, NEXT_PUBLIC_HOST } = process.env;

  const response = await fetch(`${KONG_GATEWAY_ENDPOINT}/users/me`, {
    method: 'GET',
    headers: {
      Accept: 'application/json',
      Host: NEXT_PUBLIC_HOST,
      Authorization: `Bearer ${token}`
    }
  } as RequestInit);

  return response;
}

export default async function handler(req: NextApiRequest, res: NextApiResponse<MeResponse>) {
  if (req.method !== 'GET') {
    res.setHeader('Allow', ['GET']);
    res.status(405).json({
      success: false,
      message: `Method ${req.method} not allowed`
    });

    return;
  }

  const { ARCHITOKEN: token } =
    cookie.parse(req.headers.cookie || '') ??
    req.headers.authorization?.substring(0, 'Bearer '.length);

  const response = await getMe(token);

  const data: MeResponse = await response.json();

  if (!response.ok) {
    return res.status(response.status).json({
      success: data.success,
      message: data.message
    });
  }

  return res.status(200).json(data);
}
