import { IncomingMessage } from 'http';
import { authenticationConfg } from 'lib/config/authentication';
import { NextApiRequestCookies } from 'next/dist/server/api-utils';
import { User } from './types';

export type ResolveUserResponse = {
  user: User | null;
  error?: any;
  isAuthenticated: boolean;
};

export default async function resolveUser(
  req: IncomingMessage & { cookies: NextApiRequestCookies }
): Promise<ResolveUserResponse> {
  const { cookies } = req;

  const userToken = cookies[authenticationConfg.userCookie];

  if (!userToken) {
    return Promise.reject(new Error('User not logged in'));
  }

  // const user = await getUserId({ token: userToken });
  const user = {
    id: '1',
    name: 'John Doe'
  };

  if (!user) {
    return Promise.reject(new Error('User invalid'));
  }

  return {
    user,
    isAuthenticated: !!user || false
  };
}
