import cookie from 'cookie';
import { MeResponse } from 'lib/types/responses/MeResponse';
import { GetServerSideProps, InferGetServerSidePropsType } from 'next';

export const getServerSideProps: GetServerSideProps = async ({ req }): Promise<any> => {
  const { ARCHITOKEN: token = null } = cookie.parse(req.headers.cookie || '');

  if (token) {
    const { NEXT_PUBLIC_KONG_GATEWAY_ENDPOINT, NEXT_PUBLIC_HOST } = process.env;

    const response = await fetch(`${NEXT_PUBLIC_KONG_GATEWAY_ENDPOINT}/users/me`, {
      headers: {
        Accept: 'application/json',
        Authorization: `Bearer ${token}`,
        Host: NEXT_PUBLIC_HOST,
        Cookie: req.headers.cookie
      } as HeadersInit
    });

    const data: MeResponse = await response.json();

    const { data: user = {} } = data;

    return {
      props: {
        user
      }
    };
  }

  return {
    props: {
      user: {}
    }
  };
};

export default function HomePage({ user }: InferGetServerSidePropsType<typeof getServerSideProps>) {
  return (
    <>
      <div className="flex flex-col items-center justify-center h-screen">
        <div className="m-auto text-center title">Welcome to Home, Architect</div>

        {!Object.keys(user).length && (
          <div className="mt-4">
            <a href="/auth/login" className="text-center">
              <button className="px-4 py-2 font-bold text-white rounded bg-slate-500 hover:bg-slate-700">
                Login
              </button>
            </a>
          </div>
        )}
      </div>
    </>
  );
}
