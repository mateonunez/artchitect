import { Callback } from 'src/lib/types/callback';
import { User } from './user';

export type UserLoggedIn = {
  event: string;
  data: User;
  callbacks?: Array<Callback>;
};
