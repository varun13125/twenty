# Twenty CRM - Vercel Deployment Guide

This guide will help you deploy a customized version of Twenty CRM to Vercel while maintaining the ability to sync with upstream updates.

## 🚀 Quick Start

### 1. Fork and Clone

1. Fork the Twenty repository from GitHub
2. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/twenty.git
cd twenty
```

### 2. Set Up Upstream Remote

```bash
git remote add upstream https://github.com/twentyhq/twenty.git
git fetch upstream
```

### 3. Install Dependencies

Make sure you have Node.js 22+ installed, then:

```bash
# Enable Corepack for Yarn
corepack enable

# Install dependencies
yarn install
```

### 4. Database Setup

Twenty requires PostgreSQL and Redis. For Vercel deployment, we recommend:

#### Option A: Neon (PostgreSQL)
1. Create an account at [neon.tech](https://neon.tech)
2. Create a new database
3. Copy the connection string

#### Option B: Supabase
1. Create a project at [supabase.com](https://supabase.com)
2. Go to Settings → Database
3. Copy the connection string

#### Redis Setup
Use [Upstash](https://upstash.com) for serverless Redis:
1. Create an Upstash account
2. Create a Redis database
3. Copy the connection URL

### 5. Environment Variables

Copy `.env.example` to `.env` and update with your values:

```bash
cp .env.example .env
```

Key variables to set:
- `DATABASE_URL`: Your PostgreSQL connection string
- `REDIS_URL`: Your Redis connection URL
- `ACCESS_TOKEN_SECRET`, `LOGIN_TOKEN_SECRET`, etc.: Generate secure random strings
- Custom branding variables (optional)

### 6. Deploy to Vercel

1. Install Vercel CLI:
```bash
npm i -g vercel
```

2. Deploy:
```bash
vercel
```

3. Set environment variables in Vercel dashboard:
   - Go to your project settings
   - Navigate to Environment Variables
   - Add all variables from your `.env` file

## 🎨 Customization

### Branding Configuration

Edit `custom/branding/config.ts` to customize:
- Company name and tagline
- Brand colors
- Logo URLs
- Feature flags

### Custom Components

Add custom components in `custom/components/`:

```typescript
// custom/components/CustomHeader.tsx
import React from 'react';
import { customConfig } from '../branding/config';

export const CustomHeader: React.FC = () => {
  return (
    <header style={{ backgroundColor: customConfig.colors.primary }}>
      <img src={customConfig.logo.light} alt={customConfig.company.name} />
      <h1>{customConfig.company.name}</h1>
    </header>
  );
};
```

### Theme Override

The `CustomThemeProvider` automatically applies your brand colors to the Twenty UI.

## 🔄 Syncing with Upstream

### Automatic Sync (GitHub Actions)

The workflow runs daily and creates PRs with upstream changes:
1. Check Actions tab for sync status
2. Review and merge sync PRs

### Manual Sync

Run the sync script:
```bash
bash scripts/sync-upstream.sh
```

## 🏗️ Build Configuration

The `vercel.json` file is configured to:
- Use Yarn workspaces
- Build only the frontend package
- Disable immutable installs for Vercel
- Optimize for production

## 🐛 Troubleshooting

### Yarn Lock Issues

If you get lockfile errors:
```bash
yarn install --no-immutable
```

### Build Failures

1. Check Node version (must be 22+)
2. Clear Vercel cache in dashboard
3. Verify all environment variables are set

### Database Connection Issues

- Ensure connection pooling is enabled
- Add `?pgbouncer=true` to Neon URLs
- Check SSL requirements

## 📚 Advanced Configuration

### Custom API Endpoints

Add custom endpoints in `custom/api/`:

```typescript
// custom/api/custom-endpoint.ts
export async function customEndpoint(req, res) {
  // Your custom logic
}
```

### Database Extensions

For custom fields, create migrations:
```bash
npx nx run twenty-server:typeorm migration:generate custom/migrations/AddCustomFields -d src/database/typeorm/core/core.datasource.ts
```

## 🔐 Security Best Practices

1. **Never commit `.env` files**
2. **Use strong secrets** (minimum 32 characters)
3. **Enable 2FA** on GitHub and Vercel
4. **Restrict database access** to Vercel IPs only
5. **Use environment-specific** variables

## 📈 Performance Optimization

1. **Enable caching** in Vercel settings
2. **Use CDN** for static assets
3. **Optimize images** with Next.js Image component
4. **Enable ISR** for dynamic pages

## 🚨 Monitoring

1. **Set up Sentry** for error tracking
2. **Enable Vercel Analytics**
3. **Monitor database performance**
4. **Set up uptime monitoring**

## 💡 Tips

- Keep customizations in the `custom/` directory
- Document all custom changes
- Test upstream syncs in staging first
- Maintain a changelog of customizations
- Use feature flags for gradual rollouts

## 📞 Support

- Twenty Documentation: https://twenty.com/developers
- GitHub Issues: https://github.com/twentyhq/twenty/issues
- Community Discord: https://discord.gg/twenty

---

Remember to star the original Twenty repository and contribute back when possible!