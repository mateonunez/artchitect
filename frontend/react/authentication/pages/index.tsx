import cookie from 'cookie';
import { AuthContext } from 'lib/contexts';
import type { GetServerSidePropsContext, NextPage } from 'next';
import { useContext } from 'react';

export async function getServerSideProps({ req }: GetServerSidePropsContext) {
  const { ARCHITOKEN: token = null } = cookie.parse(req.headers.cookie || '');

  if (!token) {
    return {
      redirect: {
        destination: '/auth/login'
      }
    };
  }

  // TODO resolve user via server-side

  return {
    props: {}
  };
}

const HomePage: NextPage = () => {
  const { user } = useContext(AuthContext);

  return (
    <>
      <div className="title">
        Hello User: {user.name} [{user.email}]
      </div>
    </>
  );
};

export default HomePage;
