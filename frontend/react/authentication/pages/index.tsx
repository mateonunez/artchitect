import { resolveUser } from 'lib/user';
import type { GetServerSidePropsContext, NextPage } from 'next';

export async function getServerSideProps({ req }: GetServerSidePropsContext) {
  const { isAuthenticated } = await resolveUser(req).catch(() => ({
    isAuthenticated: false
  }));

  if (!isAuthenticated) {
    return {
      redirect: {
        destination: '/auth/login'
      }
    };
  }

  return {
    props: {}
  };
}

const HomePage: NextPage = () => {
  return (
    <>
      <div className="title">Hello World</div>
    </>
  );
};

export default HomePage;
