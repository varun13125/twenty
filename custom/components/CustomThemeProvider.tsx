import React from 'react';
import { ThemeProvider } from '@emotion/react';
import { customConfig } from '../branding/config';

const createCustomTheme = (baseTheme: any) => ({
  ...baseTheme,
  color: {
    ...baseTheme.color,
    primary: customConfig.colors.primary,
    secondary: customConfig.colors.secondary,
    accent: customConfig.colors.accent,
  },
  background: {
    ...baseTheme.background,
    primary: customConfig.colors.background,
  },
  font: {
    ...baseTheme.font,
    color: {
      ...baseTheme.font?.color,
      primary: customConfig.colors.text,
    },
  },
});

export const CustomThemeProvider: React.FC<{
  children: React.ReactNode;
  baseTheme: any;
}> = ({ children, baseTheme }) => {
  const customTheme = createCustomTheme(baseTheme);
  
  return <ThemeProvider theme={customTheme}>{children}</ThemeProvider>;
};