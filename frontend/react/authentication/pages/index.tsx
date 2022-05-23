import cookie from 'cookie';
import type { GetServerSideProps, InferGetServerSidePropsType } from 'next';
import { getMe, MeResponse } from './api/users/me';

export const getServerSideProps: GetServerSideProps = async ({ req }): Promise<any> => {
  const { ARCHITOKEN: token = null } = cookie.parse(req.headers.cookie || '');

  if (!token) {
    return {
      redirect: {
        destination: '/auth/login'
      }
    };
  }

  const response = await getMe(token);

  const data: MeResponse = await response.json();

  const user = data?.data;

  if (!user) {
    console.error('User logged out?');

    return {
      redirect: {
        destination: '/auth/login'
      }
    };
  }

  return {
    props: {
      user
    }
  };
};

export default function HomePage({ user }: InferGetServerSidePropsType<typeof getServerSideProps>) {
  return (
    <>
      <div className="title">
        Hello User: {user?.name} [{user?.email}]
      </div>
    </>
  );
}
