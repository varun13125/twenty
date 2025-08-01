/**
 * Customization Configuration
 * This file contains all branding and customization settings
 */

export const customConfig = {
  // Company Information
  company: {
    name: process.env.CUSTOM_COMPANY_NAME || 'Twenty',
    tagline: process.env.CUSTOM_COMPANY_TAGLINE || 'Modern CRM Platform',
    website: process.env.CUSTOM_COMPANY_WEBSITE || 'https://twenty.com',
  },

  // Branding Colors
  colors: {
    primary: process.env.CUSTOM_PRIMARY_COLOR || '#7c3aed',
    secondary: process.env.CUSTOM_SECONDARY_COLOR || '#a78bfa',
    accent: process.env.CUSTOM_ACCENT_COLOR || '#8b5cf6',
    background: process.env.CUSTOM_BACKGROUND_COLOR || '#ffffff',
    text: process.env.CUSTOM_TEXT_COLOR || '#1f2937',
  },

  // Logo Configuration
  logo: {
    light: process.env.CUSTOM_LOGO_LIGHT_URL || '/logo-light.svg',
    dark: process.env.CUSTOM_LOGO_DARK_URL || '/logo-dark.svg',
    favicon: process.env.CUSTOM_FAVICON_URL || '/favicon.ico',
  },

  // Feature Flags
  features: {
    customFields: process.env.ENABLE_CUSTOM_FIELDS === 'true',
    advancedReporting: process.env.ENABLE_ADVANCED_REPORTING === 'true',
    apiIntegrations: process.env.ENABLE_API_INTEGRATIONS === 'true',
    multiTenancy: process.env.ENABLE_MULTI_TENANCY === 'true',
  },

  // Custom Routes
  routes: {
    dashboard: process.env.CUSTOM_DASHBOARD_ROUTE || '/dashboard',
    login: process.env.CUSTOM_LOGIN_ROUTE || '/login',
    signup: process.env.CUSTOM_SIGNUP_ROUTE || '/signup',
  },
};