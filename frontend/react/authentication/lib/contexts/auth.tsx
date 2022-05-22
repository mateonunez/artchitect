import { createContext } from 'react';

const AuthContext = createContext({
  doLogin: (...args: any) => {}
});

export default AuthContext;
