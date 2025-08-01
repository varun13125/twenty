# Twenty CRM - Customization Guide

This guide explains how to customize Twenty CRM while maintaining compatibility with upstream updates.

## 🎯 Customization Philosophy

All customizations should be:
1. **Isolated** - Kept in the `custom/` directory
2. **Non-invasive** - Override rather than modify core files
3. **Documented** - Clear comments and documentation
4. **Testable** - Include tests for custom features

## 📁 Directory Structure

```
custom/
├── branding/          # Branding configuration
│   ├── config.ts      # Main configuration file
│   └── assets/        # Custom logos, icons
├── components/        # Custom React components
│   ├── index.ts       # Component exports
│   └── overrides/     # Component overrides
├── hooks/             # Custom React hooks
├── api/               # Custom API endpoints
├── styles/            # Custom CSS/themes
├── utils/             # Utility functions
└── tests/             # Tests for customizations
```

## 🎨 Branding Customization

### 1. Basic Branding

Edit `custom/branding/config.ts`:

```typescript
export const customConfig = {
  company: {
    name: 'Acme CRM',
    tagline: 'Your Business, Simplified',
    website: 'https://acme.com',
  },
  colors: {
    primary: '#0066cc',
    secondary: '#004499',
    accent: '#0088ff',
  },
};
```

### 2. Logo Customization

Place your logos in `custom/branding/assets/`:
- `logo-light.svg` - For light backgrounds
- `logo-dark.svg` - For dark mode
- `favicon.ico` - Browser favicon

### 3. Advanced Theme Customization

Create `custom/styles/theme.ts`:

```typescript
export const customTheme = {
  spacing: {
    xs: '4px',
    sm: '8px',
    md: '16px',
    lg: '24px',
    xl: '32px',
  },
  borderRadius: {
    sm: '4px',
    md: '8px',
    lg: '16px',
  },
  shadows: {
    sm: '0 1px 2px rgba(0,0,0,0.05)',
    md: '0 4px 6px rgba(0,0,0,0.1)',
    lg: '0 10px 15px rgba(0,0,0,0.15)',
  },
};
```

## 🧩 Component Customization

### 1. Override Existing Components

Create `custom/components/overrides/Header.tsx`:

```typescript
import { Header as BaseHeader } from '@/components/Header';
import { customConfig } from '../../branding/config';

export const Header = () => {
  return (
    <BaseHeader
      logo={customConfig.logo.light}
      title={customConfig.company.name}
    />
  );
};
```

### 2. Add New Components

Create `custom/components/CustomDashboard.tsx`:

```typescript
import React from 'react';
import { useCustomMetrics } from '../hooks/useCustomMetrics';

export const CustomDashboard: React.FC = () => {
  const metrics = useCustomMetrics();
  
  return (
    <div className="custom-dashboard">
      {/* Your custom dashboard implementation */}
    </div>
  );
};
```

### 3. Component Registration

Update `packages/twenty-front/src/App.tsx`:

```typescript
import { CustomThemeProvider } from '@/custom/components';

function App() {
  return (
    <CustomThemeProvider baseTheme={theme}>
      {/* Rest of your app */}
    </CustomThemeProvider>
  );
}
```

## 🪝 Custom Hooks

Create reusable hooks in `custom/hooks/`:

```typescript
// custom/hooks/useCustomAuth.ts
import { useState, useEffect } from 'react';

export const useCustomAuth = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  
  // Custom authentication logic
  
  return { isAuthenticated };
};
```

## 🔌 API Customization

### 1. Custom Endpoints

Create `custom/api/custom-reports.ts`:

```typescript
import { Controller, Get } from '@nestjs/common';

@Controller('custom')
export class CustomReportsController {
  @Get('reports/summary')
  async getSummaryReport() {
    // Custom report logic
    return { data: 'Custom report data' };
  }
}
```

### 2. Extend GraphQL Schema

Create `custom/api/schema/custom.graphql`:

```graphql
extend type Query {
  customMetrics: CustomMetrics!
}

type CustomMetrics {
  totalRevenue: Float!
  activeUsers: Int!
  conversionRate: Float!
}
```

## 📊 Database Customization

### 1. Custom Fields

Create migration for custom fields:

```typescript
// custom/migrations/AddCustomFields.ts
export class AddCustomFields1234567890 implements MigrationInterface {
  async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "company" 
      ADD COLUMN "customField1" varchar,
      ADD COLUMN "customField2" integer
    `);
  }
  
  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "company" 
      DROP COLUMN "customField1",
      DROP COLUMN "customField2"
    `);
  }
}
```

### 2. Custom Entities

Create `custom/entities/CustomMetric.ts`:

```typescript
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('custom_metrics')
export class CustomMetric {
  @PrimaryGeneratedColumn('uuid')
  id: string;
  
  @Column()
  name: string;
  
  @Column('float')
  value: number;
  
  @Column()
  timestamp: Date;
}
```

## 🎯 Feature Flags

Control custom features via environment variables:

```typescript
// custom/utils/featureFlags.ts
export const isFeatureEnabled = (feature: string): boolean => {
  const envVar = `ENABLE_${feature.toUpperCase()}`;
  return process.env[envVar] === 'true';
};

// Usage
if (isFeatureEnabled('custom_dashboard')) {
  // Show custom dashboard
}
```

## 🧪 Testing Customizations

### 1. Unit Tests

Create `custom/tests/components/CustomDashboard.test.tsx`:

```typescript
import { render, screen } from '@testing-library/react';
import { CustomDashboard } from '../../components/CustomDashboard';

describe('CustomDashboard', () => {
  it('renders correctly', () => {
    render(<CustomDashboard />);
    expect(screen.getByText('Dashboard')).toBeInTheDocument();
  });
});
```

### 2. Integration Tests

```typescript
// custom/tests/api/custom-reports.test.ts
describe('Custom Reports API', () => {
  it('returns summary report', async () => {
    const response = await request(app)
      .get('/custom/reports/summary')
      .expect(200);
    
    expect(response.body).toHaveProperty('data');
  });
});
```

## 🔄 Maintaining Customizations

### 1. Document Changes

Maintain `custom/CHANGELOG.md`:

```markdown
# Custom Changes Log

## 2024-01-15
- Added custom dashboard component
- Modified header to include company logo
- Added custom metrics API endpoint

## 2024-01-10
- Initial customization setup
- Configured brand colors and logos
```

### 2. Conflict Resolution

When syncing with upstream:

1. **Identify conflicts** in custom overrides
2. **Update imports** if core paths change
3. **Test thoroughly** after merge
4. **Update documentation** for any changes

### 3. Best Practices

1. **Use TypeScript** for type safety
2. **Follow Twenty's coding standards**
3. **Keep customizations minimal**
4. **Comment complex logic**
5. **Version control custom assets**

## 📦 Deployment

### Environment-Specific Customizations

Use different configs per environment:

```typescript
// custom/branding/config.ts
const configs = {
  production: {
    company: { name: 'Acme CRM' },
    colors: { primary: '#0066cc' },
  },
  staging: {
    company: { name: 'Acme CRM (Staging)' },
    colors: { primary: '#ff6600' },
  },
};

export const customConfig = configs[process.env.NODE_ENV] || configs.production;
```

## 🚨 Common Pitfalls

1. **Don't modify core files directly** - Use overrides
2. **Don't hardcode values** - Use configuration
3. **Don't skip tests** - Test all customizations
4. **Don't ignore TypeScript errors** - Fix them properly
5. **Don't forget documentation** - Document everything

## 💡 Advanced Tips

1. **Use composition** over inheritance
2. **Leverage Twenty's hooks** and contexts
3. **Create custom plugins** for complex features
4. **Use feature flags** for gradual rollouts
5. **Monitor performance** of customizations

---

Remember: The goal is to enhance Twenty without breaking future updates!