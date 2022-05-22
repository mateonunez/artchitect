import type { GetServerSidePropsContext, NextPage } from 'next';
import cookie from 'cookie';
import { useContext } from 'react';
import { AuthContext } from 'lib/contexts';

export async function getServerSideProps({ req }: GetServerSidePropsContext) {
  const { ARCHITOKEN: token } = cookie.parse(req.headers.cookie);

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
