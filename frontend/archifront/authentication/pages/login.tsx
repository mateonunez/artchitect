import { LoginView } from 'components/views/auth';
import cookie from 'cookie';
import { GetServerSidePropsContext, NextPage } from 'next';
import { getMe, MeResponse } from './api/users/me';

export async function getServerSideProps({ req, res }: GetServerSidePropsContext) {
  const { ARCHITOKEN: token } = cookie.parse(req.headers.cookie || '');

  if (token) {
    const response = await getMe(token);

    const data: MeResponse = await response.json();

    const user = data?.data;

    if (user) {
      res.writeHead(301, {
        location: 'http://localhost/'
      });
      res.end();
    }
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
