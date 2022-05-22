import s from './LoginForm.module.css';

import { FC, SyntheticEvent, useContext, useRef, useState } from 'react';

import { EmailInput } from 'components/inputs/EmailInput';
import { PasswordInput } from 'components/inputs/PasswordInput';
import { Button } from 'components/ui/Button';
import { Container } from 'components/ui/Container';
import { useAuth } from 'lib/hooks/auth';
import { AuthContext } from 'lib/contexts';

interface Props {
  className?: string;
  children?: any;
}

const LoginForm: FC<Props> = ({}) => {
  const { user, doLogin } = useContext(AuthContext);

  const [disabled, setDisabled] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);

  const [error, setError] = useState<string>('');

  const emailInputRef = useRef<any>(null);
  const passwordInputRef = useRef<any>(null);

  const handleLogin = async (e: SyntheticEvent<EventTarget>) => {
    e.preventDefault();

    const { current: emailInput } = emailInputRef;
    const { current: passwordInput } = passwordInputRef;

    if (!emailInput.valid || !passwordInput.valid) {
      return;
    }

    try {
      setLoading(true);
      setDisabled(true);

      await doLogin({ email: emailInput.value, password: passwordInput.value });
    } catch (e: any) {
      const { message } = JSON.parse(e.message);

      setError(message);
    } finally {
      setLoading(false);
      setDisabled(false);
    }
  };

  return (
    <>
      <Container>
        <form className={s.root} onSubmit={handleLogin}>
          {/* Email input */}
          <EmailInput ref={emailInputRef} />

          {/* Password */}
          <PasswordInput ref={passwordInputRef} />

          {/* Submit */}
          <div className="flex mx-auto flex-column">
            <Button
              type="submit"
              variant="slim"
              className={s.submit}
              disabled={disabled}
              loading={loading}>
              Login
            </Button>
          </div>
        </form>

        {/* TODO handle this */ user && <p className="text-green-500">{JSON.stringify(user)}</p>}

        {/* TODO handle this */ error && <p className="text-red-500">{error}</p>}
      </Container>
    </>
  );
};

export default LoginForm;
