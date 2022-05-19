import cn from 'classnames';
import { FC, InputHTMLAttributes } from 'react';
import s from './Input.module.css';

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  onChange?: (...args: any[]) => any;
  fullWidth?: boolean;
}

const Input: FC<Props> = ({ className, onChange, fullWidth, ...rest }) => {
  const classNames = cn(className || s.root);

  const handleOnChange = (e: any) => {
    if (onChange) {
      onChange(e.target.value);
    }

    return null;
  };

  return (
    <label className={cn(fullWidth && s['full-width'])}>
      <input
        className={classNames}
        onChange={handleOnChange}
        autoComplete="off"
        autoCorrect="off"
        autoCapitalize="off"
        spellCheck="false"
        {...rest}
      />
    </label>
  );
};

export default Input;
