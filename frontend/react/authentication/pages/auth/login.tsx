import { LoginView } from 'components/views/auth';
import { resolveUser } from 'lib/user';
import { GetServerSidePropsContext, NextPage } from 'next';

export async function getServerSideProps({ req }: GetServerSidePropsContext) {
  const { isAuthenticated } = await resolveUser(req).catch(() => ({
    isAuthenticated: false
  }));

  if (isAuthenticated) {
    return {
      redirect: {
        destination: '/'
      }
    };
  }

  return {
    props: {}
  };
}

const LoginPage: NextPage = () => {
  return (
    <>
      <LoginView />
    </>
  );
};

export default LoginPage;
