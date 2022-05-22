type DoLoginProps = {
  email: string;
  password: string;
};

export default function useProvider() {
  const doLogin = async ({ email, password }: DoLoginProps) => {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ email, password })
    }).then(res => res.json());

    console.log(response);

    return await new Promise(resolve => resolve(setTimeout(() => {}, 1000)));
  };

  return { doLogin };
}
