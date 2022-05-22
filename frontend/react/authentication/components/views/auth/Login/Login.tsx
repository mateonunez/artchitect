import { LoginForm } from 'components/forms/Login';
import { Container } from 'components/ui/Container';
import { Text } from 'components/ui/Text';
import { Title } from 'components/ui/Title';
import s from './Login.module.css';

export default function Login() {
  return (
    <>
      <div className={s.root}>
        <Container className={s.container}>
          {/* Login message */}
          <Container>
            <Title className={s.title}>Login</Title>
            <Text>Welcome Back!</Text>
          </Container>

          {/* Login form */}
          <LoginForm />
        </Container>
      </div>
    </>
  );
}
