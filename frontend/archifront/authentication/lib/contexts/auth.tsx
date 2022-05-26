import { resolveUser } from 'lib/user';
import { User } from 'lib/user/types';
import { LoginReponse } from 'pages/api/login'; // TODO move to reusable type
import { MeResponse } from 'pages/api/users/me';
import { createContext, PropsWithChildren, useEffect, useState } from 'react';

type DoLoginProps = {
  email: string;
  password: string;
};

const AuthContext = createContext({
  user: {} as User,
  doLogin: ({ email, password }: DoLoginProps) => {}
});

export const AuthProvider = ({ children }: PropsWithChildren<Element | Element[]>) => {
  const [user, setUser] = useState<User>({} as User);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');

  useEffect(() => {
    resolveUser().then((user: MeResponse) => {
      user.data && setUser(user.data);
    });
  }, []);

  /**
   * Login Action
   */
  const doLogin = async ({ email, password }: DoLoginProps) => {
    setLoading(true);

    const response = await fetch('/auth/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email, password })
    });

    const data: LoginReponse = await response.json();
    setLoading(false);

    if (!response.ok) {
      setError(data.message);
      throw new Error(JSON.stringify(data));
    }

    const user = await resolveUser();

    user.data && setUser(user.data);

    return data;
  };

  return <AuthContext.Provider value={{ user, doLogin }}>{children}</AuthContext.Provider>;
};

export default AuthContext;
