# Twenty CRM - Troubleshooting Guide

## 🚨 Common Deployment Issues

### 1. Yarn Lockfile Errors on Vercel

**Error**: `The lockfile would have been modified by this install`

**Solution**:
```json
// vercel.json
{
  "installCommand": "yarn install --no-immutable"
}
```

**Alternative**:
```bash
# Before pushing to Vercel
yarn install
git add yarn.lock
git commit -m "Update yarn.lock"
git push
```

### 2. Build Memory Issues

**Error**: `JavaScript heap out of memory`

**Solution**:
```json
// vercel.json
{
  "env": {
    "NODE_OPTIONS": "--max-old-space-size=4096"
  }
}
```

### 3. Database Connection Failures

**Error**: `ECONNREFUSED` or `timeout`

**Solutions**:

**For Neon**:
```
postgresql://user:pass@host/db?sslmode=require&pgbouncer=true
```

**For Supabase**:
```
postgresql://user:pass@host:6543/postgres?pgbouncer=true
```

**Connection Pool Config**:
```typescript
// packages/twenty-server/src/database/typeorm/core/core.datasource.ts
{
  type: 'postgres',
  url: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  extra: {
    max: 5, // Reduce for serverless
  }
}
```

### 4. Redis Connection Issues

**Error**: `Redis connection timeout`

**Solution with Upstash**:
```typescript
import { Redis } from '@upstash/redis';

const redis = new Redis({
  url: process.env.UPSTASH_REDIS_REST_URL,
  token: process.env.UPSTASH_REDIS_REST_TOKEN,
});
```

## 🔧 Build & Development Issues

### 1. TypeScript Errors

**Error**: Type errors during build

**Quick Fix**:
```json
// vercel.json
{
  "env": {
    "VITE_DISABLE_TYPESCRIPT_CHECKER": "true"
  }
}
```

**Proper Fix**:
```bash
# Fix all TypeScript errors
npx nx typecheck twenty-front
npx nx typecheck twenty-server
```

### 2. ESLint Errors

**Disable for deployment**:
```json
{
  "env": {
    "VITE_DISABLE_ESLINT_CHECKER": "true"
  }
}
```

**Fix properly**:
```bash
npx nx lint twenty-front --fix
npx nx lint twenty-server --fix
```

### 3. Module Resolution Issues

**Error**: `Cannot find module`

**Solution**:
1. Check `tsconfig.json` paths
2. Verify workspace dependencies
3. Clear cache:
```bash
rm -rf node_modules
yarn install
```

## 🔄 Upstream Sync Issues

### 1. Merge Conflicts

**Common conflict areas**:
- `package.json`
- `yarn.lock`
- Configuration files

**Resolution Strategy**:
```bash
# For package.json conflicts
git checkout --theirs package.json
yarn install
git add yarn.lock

# For code conflicts
git status
# Manually resolve each file
git add .
git commit
```

### 2. Breaking Changes

**Check for**:
- API changes
- Database schema changes
- Dependency updates

**Mitigation**:
1. Review upstream changelog
2. Test in staging first
3. Update custom code accordingly

## 🚀 Performance Issues

### 1. Slow Build Times

**Solutions**:
- Enable Vercel build cache
- Optimize imports
- Use dynamic imports for large modules

### 2. Cold Start Issues

**Optimize serverless functions**:
```typescript
// Keep functions warm
export const config = {
  maxDuration: 10,
};
```

### 3. Large Bundle Size

**Analyze bundle**:
```bash
npx nx run twenty-front:analyze
```

**Optimize**:
- Tree shaking
- Code splitting
- Lazy loading

## 🐛 Runtime Issues

### 1. CORS Errors

**Frontend config**:
```typescript
// packages/twenty-front/src/apollo/client.ts
const httpLink = new HttpLink({
  uri: process.env.VITE_SERVER_BASE_URL,
  credentials: 'include',
});
```

**Backend config**:
```typescript
// packages/twenty-server/src/main.ts
app.enableCors({
  origin: process.env.FRONT_BASE_URL,
  credentials: true,
});
```

### 2. Authentication Issues

**Common causes**:
- Mismatched secrets
- Cookie domain issues
- HTTPS requirements

**Debug**:
```typescript
console.log({
  NODE_ENV: process.env.NODE_ENV,
  FRONT_URL: process.env.FRONT_BASE_URL,
  cookies: document.cookie,
});
```

### 3. GraphQL Errors

**Enable detailed errors** (dev only):
```typescript
// packages/twenty-server/src/graphql/graphql.module.ts
GraphQLModule.forRoot({
  debug: true,
  playground: true,
});
```

## 📊 Monitoring & Debugging

### 1. Enable Detailed Logging

```typescript
// Backend
import { Logger } from '@nestjs/common';
const logger = new Logger('Debug');
logger.verbose('Detailed message');

// Frontend
if (process.env.NODE_ENV === 'development') {
  console.log('Debug info:', data);
}
```

### 2. Vercel Function Logs

Access via:
1. Vercel Dashboard → Functions tab
2. CLI: `vercel logs`

### 3. Browser DevTools

Check:
- Network tab for failed requests
- Console for JavaScript errors
- Application tab for cookies/storage

## 🔐 Security Issues

### 1. Environment Variable Exposure

**Never expose secrets in**:
- Frontend code
- Git commits
- Build logs

**Use Vercel secrets**:
```bash
vercel secrets add my-secret "value"
```

### 2. Database Security

**Always use**:
- SSL connections
- Connection pooling
- IP whitelisting
- Strong passwords

## 📱 Mobile/Responsive Issues

### 1. Viewport Problems

Add to `index.html`:
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### 2. Touch Events

Ensure components support touch:
```typescript
onTouchStart={handleTouch}
onMouseDown={handleMouse}
```

## 🆘 Getting Help

### 1. Gather Information

Before asking for help, collect:
- Error messages
- Vercel deployment logs
- Browser console output
- Network requests

### 2. Debug Steps

1. Check environment variables
2. Verify database connectivity
3. Test locally with production config
4. Review recent changes

### 3. Resources

- Twenty Discord: https://discord.gg/twenty
- GitHub Issues: https://github.com/twentyhq/twenty/issues
- Stack Overflow: Tag with `twenty-crm`

## 💡 Prevention Tips

1. **Test locally** with production-like config
2. **Use staging** environment
3. **Monitor** error rates
4. **Document** custom changes
5. **Keep dependencies** updated
6. **Regular backups** of database

---

Remember: Most issues have been encountered before. Check issues and discussions first!