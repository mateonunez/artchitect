import { User } from 'lib/user/types';
import { LoginReponse } from 'pages/api/auth/login'; // TODO move to reusable type
import { MeResponse } from 'pages/api/users/me';
import {
  createContext,
  JSXElementConstructor,
  PropsWithChildren,
  ReactElement,
  ReactNode,
  useState
} from 'react';

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

  /**
   * Login Action
   */
  const doLogin = async ({ email, password }: DoLoginProps) => {
    setLoading(true);

    const response = await fetch('/api/auth/login', {
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

    const user = await getUser();
    console.log(user);

    user.data && setUser(user.data);

    return data;
  };

  /**
   * Get User
   */
  const getUser = async () => {
    setLoading(true);

    const response = await fetch('/api/users/me', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json'
      }
    });

    const data: MeResponse = await response.json();

    setLoading(false);

    if (!response.ok) {
      setError(data.message);
      throw new Error(JSON.stringify(data));
    }

    return data;
  };

  return <AuthContext.Provider value={{ user, doLogin }}>{children}</AuthContext.Provider>;
};

export default AuthContext;
