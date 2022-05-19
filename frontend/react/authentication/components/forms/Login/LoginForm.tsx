import { EmailInput } from 'components/inputs/EmailInput';
import { PasswordInput } from 'components/inputs/PasswordInput';
import { Button } from 'components/ui/Button';
import { Container } from 'components/ui/Container';
import { FC } from 'react';
import s from './LoginForm.module.css';

interface Props {
  className?: string;
  children?: any;
}

const LoginForm: FC<Props> = ({}) => {
  return (
    <>
      <Container>
        <form className={s.root}>
          {/* Email input */}
          <EmailInput />

          {/* Password */}
          <PasswordInput />

          {/* Submit */}
          <div className="flex mx-auto flex-column">
            <Button type="submit" className={s.submit}>
              Login
            </Button>
          </div>
        </form>
      </Container>
    </>
  );
};

export default LoginForm;
