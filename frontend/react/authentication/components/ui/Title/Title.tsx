import cn from 'classnames';
import { ComponentType, FC, HTMLAttributes } from 'react';
import s from './Title.module.css';

interface Props {
  className?: string;
  children?: any;
  element?: HTMLElement;
  clean?: boolean;
}

const Title: FC<Props> = ({ className, children, element = 'h1', clean }) => {
  const classNames = cn(s.root, className, {
    'mx-auto max-w-8-xl px-4': !clean
  });

  const Component: ComponentType<HTMLAttributes<HTMLDivElement>> = element as any;

  return (
    <>
      <Component className={classNames}>{children}</Component>
    </>
  );
};

export default Title;
