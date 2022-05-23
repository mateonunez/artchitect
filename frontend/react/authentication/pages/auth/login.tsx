import { LoginView } from 'components/views/auth';
import cookie from 'cookie';
import { GetServerSidePropsContext, NextPage } from 'next';

export async function getServerSideProps({ req }: GetServerSidePropsContext) {
  const { ARCHITOKEN: token } = cookie.parse(req.headers.cookie || '');

  if (token) {
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
