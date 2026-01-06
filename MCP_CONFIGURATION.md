# MCP Configuration for GitHub Copilot Demo

This document explains the Model Context Protocol (MCP) integration for the Contoso University demo.

## What is MCP?

Model Context Protocol (MCP) allows GitHub Copilot to interact with external tools, services, and data sources beyond just reading code files. In this demo, we use MCP for:

1. **Playwright Integration** - Generate and run browser-based E2E tests
2. **Documentation Search** - Search across all markdown documentation in the repository

## Configuration

### VS Code Settings

Add the following to your VS Code `settings.json` (User or Workspace settings):

```json
{
  "github.copilot.advanced": {
    "mcp": {
      "enabled": true,
      "providers": [
        {
          "name": "playwright",
          "type": "tool",
          "description": "Playwright browser automation for E2E testing",
          "command": "npx",
          "args": ["playwright"],
          "workingDirectory": "${workspaceFolder}/ContosoUniversity/ContosoUniversity.PlaywrightTests"
        },
        {
          "name": "documentation-search",
          "type": "search",
          "description": "Search repository documentation",
          "patterns": [
            "**/*.md",
            "**/*.instructions.md",
            ".github/**/*.md"
          ],
          "exclude": [
            "**/node_modules/**",
            "**/bin/**",
            "**/obj/**"
          ]
        }
      ]
    }
  }
}
```

### Alternative: .copilot/mcp.json

You can also place MCP configuration in the repository itself:

**File: `.copilot/mcp.json`**
```json
{
  "version": "1.0",
  "providers": [
    {
      "id": "playwright-tests",
      "name": "Playwright Testing",
      "description": "Generate and execute browser-based tests",
      "type": "tool",
      "config": {
        "executable": "npx",
        "args": ["playwright", "test"],
        "cwd": "./ContosoUniversity.PlaywrightTests"
      },
      "capabilities": {
        "testGeneration": true,
        "testExecution": true,
        "browserAutomation": true
      }
    },
    {
      "id": "docs-search",
      "name": "Documentation Search",
      "description": "Search all markdown documentation",
      "type": "search",
      "config": {
        "include": [
          "**/*.md",
          ".github/instructions/**",
          ".github/prompts/**"
        ],
        "exclude": [
          "node_modules",
          "bin",
          "obj"
        ],
        "indexing": "realtime"
      },
      "capabilities": {
        "semanticSearch": true,
        "fullTextSearch": true,
        "crossReferencing": true
      }
    }
  ]
}
```

## Using MCP in the Demo

### Playwright Integration

Once configured, you can ask Copilot to:

```
Using Playwright, create an E2E test that:
1. Navigates to the students page
2. Clicks the "Next" pagination button
3. Verifies the URL includes ?page=2
4. Checks that student names are displayed
```

Copilot will:
1. Access Playwright APIs and documentation
2. Generate test code following Playwright conventions
3. Include proper waits, selectors, and assertions
4. Use async/await patterns correctly

### Documentation Search

Ask Copilot to search your docs:

```
Search our documentation for pagination best practices
```

Or reference specific docs:

```
Based on SETUP_TESTING_GUIDE.md, how should I configure the test database?
```

MCP allows Copilot to:
- Find relevant sections across multiple markdown files
- Understand documentation structure
- Cross-reference between documents
- Provide context-aware answers

## Verification

### Test Playwright MCP

```powershell
# Ensure Playwright is installed
cd ContosoUniversity\ContosoUniversity.PlaywrightTests
npm install

# Verify Playwright works
npx playwright test --list

# Install browsers if needed
npx playwright install
```

### Test Documentation Search

In VS Code with Copilot Chat:
```
@workspace Search all documentation for "DDD" and summarize the architectural principles
```

Expected: Copilot should find and reference content from:
- `.github/instructions/dotnet-architecture-best-practices.instructions.md`
- `README.md`
- `DEMO_INSTRUCTOR_GUIDE.md`

## Troubleshooting

### MCP Not Working

**Symptom**: Copilot doesn't seem to use Playwright or find documentation

**Solutions**:
1. Reload VS Code window (Ctrl+Shift+P → "Reload Window")
2. Check that MCP is enabled in settings
3. Verify file paths are correct (use absolute paths if needed)
4. Ensure Playwright is installed: `cd ContosoUniversity.PlaywrightTests && npm install`
5. Check VS Code output panel for MCP errors

### Playwright Tests Not Generating

**Solutions**:
1. Verify Playwright installation: `npx playwright --version`
2. Install browsers: `npx playwright install`
3. Check working directory in MCP config
4. Try explicit prompt: "Using the Playwright tool, generate a test..."

### Documentation Not Found

**Solutions**:
1. Verify markdown files exist and are UTF-8 encoded
2. Check include/exclude patterns in MCP config
3. Use more specific prompts with file references
4. Try `@workspace` scope explicitly

## Advanced MCP Scenarios

### Custom Tool Integration

You can extend MCP to integrate other tools:

```json
{
  "id": "sql-query",
  "name": "SQL Database Query",
  "description": "Query the Contoso University database",
  "type": "tool",
  "config": {
    "executable": "sqlcmd",
    "args": ["-S", "(localdb)\\MSSQLLocalDB", "-d", "ContosoUniversity"]
  }
}
```

### API Integration

Connect to external APIs for real-time data:

```json
{
  "id": "azure-resources",
  "name": "Azure Resource Information",
  "description": "Query Azure resources for the application",
  "type": "api",
  "config": {
    "endpoint": "https://management.azure.com",
    "authentication": "azure-cli"
  }
}
```

## Security Considerations

- **Authentication**: MCP tools may require credentials - use secure methods
- **Scope Limitation**: Only grant access to necessary files and tools
- **Audit Logging**: Consider logging MCP tool invocations
- **Sensitive Data**: Exclude files with secrets from MCP search paths

## Demo Tips

1. **Pre-test MCP** before the demo - verify both providers work
2. **Show the config** to attendees so they understand setup
3. **Explain the value** - why MCP extends beyond code completion
4. **Use live examples** - generate a test in real-time during the demo
5. **Contrast with/without** - show a prompt without MCP, then with MCP

## Resources

- [MCP Specification](https://modelcontextprotocol.io/)
- [Playwright Documentation](https://playwright.dev/)
- [GitHub Copilot MCP Guide](https://docs.github.com/copilot/mcp)

---

**Note**: MCP is a rapidly evolving feature. Check the latest GitHub Copilot documentation for updates to configuration syntax and capabilities.
