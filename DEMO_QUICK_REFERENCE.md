# GitHub Copilot Demo - Quick Reference Card

## Pre-Demo Checklist
- [ ] GitHub Copilot enabled with Claude Sonnet 4.5
- [ ] Repository cloned and on `local-testing` branch
- [ ] .NET SDK 8.0+ installed
- [ ] SQL Server LocalDB running
- [ ] VS Code with Copilot extensions installed
- [ ] Playwright dependencies installed (`npm install` in PlaywrightTests folder)

## Branch Setup
```powershell
git checkout local-testing
git pull origin local-testing
git checkout -b demo/copilot-capabilities
```

## Build & Test Commands
```powershell
# Restore and build
dotnet restore .\ContosoUniversity.sln
dotnet build .\ContosoUniversity.sln -c Debug

# Run all tests (expect 1 failure)
dotnet test .\ContosoUniversity.sln -c Debug

# Run specific test
dotnet test --filter FullyQualifiedName~StudentsControllerTests.Index_ReturnsViewWithPaginatedList

# Run Playwright tests
cd ContosoUniversity.PlaywrightTests
npm test
```

## Key Files & Locations

### Custom Instructions
- `.github/instructions/dotnet-architecture-best-practices.instructions.md`

### Custom Agents
- `.github/agents/testing-agent.json`
- `.github/agents/architecture-reviewer.json`

### Intentionally Broken Test
- `ContosoUniversity.Tests/StudentsControllerTests.cs`
- Test: `Index_ReturnsViewWithPaginatedList`

### Key Code Files
- `ContosoUniversity.Web/Controllers/StudentsController.cs`
- `ContosoUniversity.Web/PaginatedList.cs`

## Essential Copilot Commands

### Chat Scopes
- `@workspace` - Search entire codebase
- `@file` - Reference current file
- `#file:path/to/file.cs` - Reference specific file

### Example Prompts

#### Analysis
```
@workspace I have a failing test: StudentsControllerTests.Index_ReturnsViewWithPaginatedList
Can you analyze why this test is failing?
```

#### Using Custom Instructions
```
@workspace Fix the test following our DDD best practices and SOLID principles
```

#### Testing Agent
```
@testing-agent Analyze our test coverage for StudentsController pagination
```

#### Architecture Review
```
@architecture-reviewer Review this controller action for SOLID compliance
```

#### MCP Integration
```
Using Playwright, create an E2E test for student list pagination
```

## Demo Timeline (60 min)

| Time | Segment | Duration |
|------|---------|----------|
| 0:00 | Intro & Problem Discovery | 10 min |
| 0:10 | Using Copilot Chat | 15 min |
| 0:25 | Custom Instructions & Fix | 15 min |
| 0:40 | Custom Agents | 10 min |
| 0:50 | MCP Integration | 10 min |

## Common Issues & Fixes

### "Custom instructions not being read"
- Reload VS Code window
- Check file is named `*.instructions.md`
- Verify location: `.github/instructions/`

### "Agent not available"
- Confirm JSON files in `.github/agents/`
- Validate JSON syntax
- Restart VS Code
- Check model selection (Claude Sonnet 4.5)

### "Test still failing after fix"
- Verify correct branch
- Run `dotnet clean` and `dotnet build`
- Check test data setup
- Ensure PaginatedList.cs was modified

### "MCP not working"
- Install Playwright: `cd ContosoUniversity.PlaywrightTests && npm install`
- Check MCP settings in VS Code
- Verify external tool permissions

## Teaching Points Cheat Sheet

### Why Custom Instructions?
✅ Enforce team standards  
✅ Capture domain knowledge  
✅ Ensure consistency across AI and human developers  
✅ Reduce code review burden  

### Why Custom Agents?
✅ Specialized expertise (testing, security, architecture)  
✅ Context-specific analysis  
✅ Focused outputs  
✅ Team role simulation  

### Why MCP?
✅ Tool integration (Playwright, documentation, APIs)  
✅ Real-time data access  
✅ Extended capabilities beyond code  
✅ Workflow automation  

## Post-Demo Cleanup
```powershell
# Save changes (optional)
git add .
git commit -m "Demo: Copilot capabilities"

# Or discard demo changes
git checkout local-testing
git branch -D demo/copilot-capabilities
```

## Backup Prompts (If Demo Deviates)

### If Copilot suggests wrong fix:
```
That doesn't follow our testing standards. Please review .github/instructions/dotnet-architecture-best-practices.instructions.md and try again using the MethodName_Condition_ExpectedResult naming pattern.
```

### If audience wants to see refactoring:
```
@workspace Refactor the StudentsController.Index action to better follow SOLID principles
```

### If audience asks about security:
```
@workspace What security considerations should we have for the student pagination feature?
```

### If time for architecture discussion:
```
@architecture-reviewer Explain how this codebase implements DDD patterns
```

## Additional Demo Ideas (If Time Permits)

1. **Code Documentation**: Generate XML comments
2. **Performance Optimization**: Identify N+1 queries
3. **Security Review**: Check for common vulnerabilities
4. **Refactoring**: Improve code with design patterns
5. **Migration Path**: Suggest upgrade to newer .NET version

## Resources During Q&A
- [GitHub Copilot Docs](https://docs.github.com/copilot)
- [DDD Reference](https://learn.microsoft.com/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
- [MCP Specification](https://modelcontextprotocol.io/)
- [Playwright Docs](https://playwright.dev/)

---

**Print this card for quick reference during the demo!**
