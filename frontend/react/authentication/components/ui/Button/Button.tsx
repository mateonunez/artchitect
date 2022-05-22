import s from './Button.module.css';

import cn from 'classnames';

import { LoadingDotsAnimation } from 'components/animations/LoadingDots';
import mergeRefs from 'lib/utils/merge-refs';
import {
  ButtonHTMLAttributes,
  ComponentType,
  FC,
  forwardRef,
  HTMLAttributes,
  JSXElementConstructor,
  useEffect,
  useRef
} from 'react';

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  href?: string;
  className?: string;
  element?: string | JSXElementConstructor<any>;
  variant?: 'flat' | 'slim' | 'ghost' | 'naked';
  type?: 'button' | 'submit' | 'reset';
  active?: boolean;
  disabled?: boolean;
  loading?: boolean;
  width?: string;
  backgroundColor?: string;
  textColor?: string;
  style?: any;
}

const Button: FC<Props> = forwardRef(
  (
    {
      href,
      className,
      children,
      element = 'button',
      variant = 'flat',
      type = 'button',
      active,
      disabled,
      loading,
      width,
      backgroundColor = 'bg-accent-9',
      textColor = 'text-accent-0',
      style = {},
      ...rest
    },
    buttonRef
  ) => {
    const ref = useRef<typeof element>(null);

    const classNames = cn(
      s.root,
      {
        [s.ghost]: variant === 'ghost',
        [s.slim]: variant === 'slim',
        [s.naked]: variant === 'naked',
        [s.active]: active,
        [s.disabled]: disabled,
        [s.loading]: loading
      },
      className,
      backgroundColor,
      textColor
    );

    const Component: any | ComponentType<HTMLAttributes<HTMLButtonElement>> = element as any;

    return (
      <>
        <Component
          ref={mergeRefs(ref, buttonRef)}
          aria-pressed={active}
          data-variant={variant}
          className={classNames}
          disabled={disabled}
          style={{
            width,
            ...style
          }}
          {...rest}>
          {!loading && children}

          {loading && (
            <i className={s.loading}>
              <LoadingDotsAnimation />
            </i>
          )}
        </Component>
      </>
    );
  }
);

Button.displayName = 'Button';

export default Button;
