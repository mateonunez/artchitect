import s from './LoginForm.module.css';

import { FC, useRef } from 'react';

import { EmailInput } from 'components/inputs/EmailInput';
import { PasswordInput } from 'components/inputs/PasswordInput';
import { Button } from 'components/ui/Button';
import { Container } from 'components/ui/Container';

interface Props {
  className?: string;
  children?: any;
}

const LoginForm: FC<Props> = ({}) => {
  const emailInputRef = useRef<any>(null);
  const passwordInputRef = useRef<any>(null);

  return (
    <>
      <Container>
        <form className={s.root}>
          {/* Email input */}
          <EmailInput ref={emailInputRef} />

          {/* Password */}
          <PasswordInput ref={passwordInputRef} />

          {/* Submit */}
          <div className="flex mx-auto flex-column">
            <Button
              type="submit"
              className={s.submit}
              onClick={e => {
                e.preventDefault();
                console.log(emailInputRef);
              }}>
              Login
            </Button>
          </div>
        </form>
      </Container>
    </>
  );
};

export default LoginForm;
