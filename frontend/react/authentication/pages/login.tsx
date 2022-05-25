import { LoginView } from 'components/views/auth';
import cookie from 'cookie';
import { GetServerSidePropsContext, NextPage } from 'next';

export async function getServerSideProps({ req, res }: GetServerSidePropsContext) {
  const { ARCHITOKEN: token } = cookie.parse(req.headers.cookie || '');

  if (token) {
    res.writeHead(301, {
      location: 'http://localhost/'
    });
    res.end();
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
