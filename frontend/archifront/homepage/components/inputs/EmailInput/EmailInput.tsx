import s from './EmailInput.module.css';

import cn from 'classnames';

import { MailIcon } from 'components/icons';
import { FC, forwardRef, Ref, useCallback, useImperativeHandle, useRef, useState } from 'react';
import { Input } from '../../ui/Input';
import { Text } from '../../ui/Text';

const EmailInput = (props: any, ref: Ref<any>) => {
  const [email, setEmail] = useState<string>('');
  const [isValidEmail, setIsValidEmail] = useState<boolean>(false);

  const validate = useCallback(() => {
    setIsValidEmail(
      /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) && email.length > 0 && email.length < 255
    );
  }, [email]);

  const handleEmailInput = (e: any) => {
    setEmail(e.target.value);
    validate();
  };

  useImperativeHandle(ref, () => ({
    value: email,
    valid: isValidEmail
  }));

  return (
    <>
      <div className={s.root}>
        <Text className={s.label} clean>
          Email
        </Text>

        <Input
          className={cn(s.input, {
            [s.invalid]: email.length > 0 && !isValidEmail
          })}
          onChange={handleEmailInput}
          ref={ref}
          type="email"
          name="email"
          {...props}
        />

        <MailIcon className={s.icon} />
      </div>
    </>
  );
};

export default forwardRef(EmailInput);
