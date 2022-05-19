import s from './EmailInput.module.css';

import cn from 'classnames';

import { MailIcon } from 'components/icons';
import { FC, useState } from 'react';
import { Input } from '../../ui/Input';
import { Text } from '../../ui/Text';

const EmailInput: FC<any> = props => {
  const [isValidEmail, setIsValidEmail] = useState(false);

  return (
    <>
      <div className={s.root} {...props}>
        <Text className={s.label} clean>
          Email
        </Text>

        <Input
          className={cn(s.input, {
            [s.invalid]: !isValidEmail
          })}
          type="email"
          name="email"
        />

        <MailIcon className={s.icon} />
      </div>
    </>
  );
};

export default EmailInput;
