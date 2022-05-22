import cn from 'classnames';
import { FC, forwardRef, InputHTMLAttributes, Ref } from 'react';
import s from './Input.module.css';

interface Props extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  onChange?: (...args: any[]) => any;
  fullWidth?: boolean;
}

const Input = ({ className, onChange, fullWidth, ...rest }: Props, ref: Ref<any>) => {
  const classNames = cn(className || s.root);

  const handleOnChange = (e: any) => {
    if (onChange) {
      onChange(e);
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

export default forwardRef(Input);
