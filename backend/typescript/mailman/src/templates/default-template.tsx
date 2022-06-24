import React from 'react';

export type DefaultTemplateProps = {
  title: string;
  content: JSX.Element | string;
};

export default function DefaultTemplate({ title, content }: DefaultTemplateProps) {
  return (
    <div>
      <h1>Hello Dear Architect</h1>

      <h2>{title}</h2>

      {content}
    </div>
  );
}
