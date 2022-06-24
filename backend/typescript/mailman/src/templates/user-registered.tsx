import React from 'react';

export type UserRegisteredTemplateProps = {
  title: string;
  content: JSX.Element | string;
};

export default function UserRegisteredTemplate({ title, content }: UserRegisteredTemplateProps) {
  return (
    <div>
      <h1>Hello Dear Architect</h1>
      Yes, I'm a different layout
      <h2>{title}</h2>
      {content}
    </div>
  );
}
