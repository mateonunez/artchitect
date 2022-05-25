import { User } from '../entities/User';

export type MeResponse = {
  success: boolean;
  data?: User | {};
  message: string;
};
