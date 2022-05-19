import s from './PasswordInput.module.css';

import cn from 'classnames';

import { LockClosedIcon } from 'components/icons';
import { FC, useState } from 'react';
import { Input } from '../../ui/Input';
import { Text } from '../../ui/Text';

const PasswordInput: FC<any> = props => {
  const [isValidPassword, setIsValidPassword] = useState(false);

  return (
    <>
      <div className={s.root} {...props}>
        <Text className={s.label} clean>
          Password
        </Text>

        <Input
          className={cn(s.input, {
            [s.invalid]: !isValidPassword
          })}
          type="password"
          name="password"
        />

        <LockClosedIcon className={s.icon} />
      </div>
    </>
  );
};

export default PasswordInput;
