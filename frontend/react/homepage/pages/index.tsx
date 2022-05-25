import { NextPage } from 'next';

const HomePage: NextPage = () => {
  return (
    <>
      <div className="flex flex-col items-center justify-center h-screen">
        <div className="m-auto text-center title">Welcome to Home, Architect</div>

        <div className="mt-4">
          <a href="/auth/login" className="text-center">
            <button className="px-4 py-2 font-bold text-white rounded bg-slate-500 hover:bg-slate-700">
              Login
            </button>
          </a>
        </div>
      </div>
    </>
  );
};

export default HomePage;
