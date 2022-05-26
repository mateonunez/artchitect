import { Context, useContext } from 'react';
import { AuthContext } from 'lib/contexts';

export default function useAuth() {
  return useContext(AuthContext);
}
