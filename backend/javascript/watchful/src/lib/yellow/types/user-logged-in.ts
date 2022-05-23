import { User } from './user';

export type UserLoggedIn = {
  event: string;
  data: User;
  timestamp: string;
};
