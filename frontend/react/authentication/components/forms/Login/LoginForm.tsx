import s from './LoginForm.module.css';

import { FC, SyntheticEvent, useCallback, useEffect, useRef, useState } from 'react';

import { EmailInput } from 'components/inputs/EmailInput';
import { PasswordInput } from 'components/inputs/PasswordInput';
import { Button } from 'components/ui/Button';
import { Container } from 'components/ui/Container';

interface Props {
  className?: string;
  children?: any;
}

const LoginForm: FC<Props> = ({}) => {
  const [disabled, setDisabled] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);

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

      return await new Promise(resolve => setTimeout(resolve, 1000));
    } catch (e: any) {
      console.error(e);
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
      </Container>
    </>
  );
};

export default LoginForm;
