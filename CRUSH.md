# Development Commands

## Single Test Commands
```bash
# Frontend
npx nx test twenty-front --testPathPattern="AuthModule" --watch
npx nx test twenty-front --testNamePattern="should render loading state"

# Backend  
npx nx run twenty-server:test --testNamePattern="UserService"
npx nx run twenty-server:test:integration:with-db-reset --testNamePattern="user creation"

# E2E
npx nx playwright test twenty-e2e-testing --grep "Login flow"
```

## Core Development Commands
```bash
# Type checking
npx nx typecheck twenty-front
npx nx typecheck twenty-server

# Linting with auto-fix
npx nx lint twenty-front --fix
npx nx lint twenty-server --fix

# GraphQL generation
npx nx run twenty-front:graphql:generate

# Database operations
npx nx database:reset twenty-server
npx nx run twenty-server:command workspace:sync-metadata -f
```

## Code Style Guidelines
- **No 'any' type** - Use strict TypeScript types only
- **Named exports only** - No default exports for components/functions
- **Functional components only** - Use React functional components with hooks
- **Types over interfaces** - Use type aliases except when extending third-party interfaces
- **String literals over enums** - Use union types instead of enums (except GraphQL)
- **Event handlers > useEffect** - Prefer direct event handling
- **Prettier formatting** - 2-space indentation, single quotes, trailing commas
- **Import organization** - External → Internal → Relative, absolute paths for internal imports

## Testing Conventions
- AAA pattern: Arrange → Act → Assert
- Test behavior, not implementation - query by user-visible elements
- Use descriptive test names: "should [behavior] when [condition]"

## Performance & Quality
- Use Recoil for global state, React hooks for local state
- Memoize expensive components and callbacks only when needed
- Follow Nx workspace patterns with proper barrel exports
- Keep components under 300 lines, extract logic to hooks/utilities