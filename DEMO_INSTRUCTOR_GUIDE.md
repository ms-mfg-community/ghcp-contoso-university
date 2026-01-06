# GitHub Copilot Demo - Instructor Guide (60 Minutes)

## Overview
This demo showcases GitHub Copilot's capabilities including custom instructions, prompts, custom agents, and Model Context Protocol (MCP) integration with Playwright and documentation searching.

## Prerequisites
- GitHub Copilot license with access to Claude Sonnet 4.5
- Visual Studio Code with GitHub Copilot extensions installed
- .NET SDK 8.0+
- SQL Server LocalDB
- Node.js (for Playwright tests)

## Demo Setup (5 minutes before session)

### 1. Create Feature Branch
```powershell
cd C:\path\to\ghcp-contoso-university
git checkout local-testing
git pull origin local-testing
git checkout -b demo/copilot-capabilities
```

### 2. Verify Environment
```powershell
# From repository root
cd ContosoUniversity
dotnet restore .\ContosoUniversity.sln
dotnet build .\ContosoUniversity.sln -c Debug
```

### 3. Confirm Intentionally Broken Test
```powershell
dotnet test .\ContosoUniversity.sln -c Debug
```
**Expected**: You should see `StudentsControllerTests.Index_ReturnsViewWithPaginatedList` failing. This is intentional for the demo.

## Demo Flow

---

## Part 1: Introduction & Problem Discovery (10 minutes)

### Segment 1A: Project Overview (3 minutes)
**Objective**: Orient attendees to the Contoso University application.

**Script**:
> "Welcome! Today we're working with Contoso University, an ASP.NET Core MVC application that demonstrates modern .NET development practices with Domain-Driven Design. This is a student management system with courses, instructors, and departments."

**Actions**:
1. Open the solution in VS Code
2. Show the solution structure in Explorer:
   - `ContosoUniversity.Web` - Web application layer
   - `ContosoUniversity.Core` - Domain models
   - `ContosoUniversity.Infrastructure` - Data access
   - `ContosoUniversity.Tests` - Unit tests
   - `ContosoUniversity.PlaywrightTests` - E2E tests

3. Briefly show a controller file (e.g., `StudentsController.cs`)

### Segment 1B: Running the Test Suite (7 minutes)
**Objective**: Discover the failing test that we'll fix using GitHub Copilot.

**Script**:
> "Let's verify everything works by running our test suite. This is a critical step in any development workflow."

**Actions**:
1. Open integrated terminal in VS Code
2. Run tests:
```powershell
dotnet test .\ContosoUniversity.sln -c Debug
```

3. **Observe the failure**:
   - Point out the failed test: `StudentsControllerTests.Index_ReturnsViewWithPaginatedList`
   - Read the error message aloud
   - Highlight that this is a pagination-related test

**Script**:
> "We have a failing test related to student pagination. This is exactly the kind of problem GitHub Copilot can help us diagnose and fix. Let's use Copilot to understand what's happening."

---

## Part 2: Using GitHub Copilot Chat (15 minutes)

### Segment 2A: Analyzing the Test Failure (5 minutes)
**Objective**: Show how to use Copilot Chat for problem analysis.

**Actions**:
1. Open GitHub Copilot Chat panel (Ctrl+Alt+I or Cmd+Alt+I)
2. Type the following prompt:
```
@workspace I have a failing test: StudentsControllerTests.Index_ReturnsViewWithPaginatedList
Can you analyze why this test is failing and explain what the test expects?
```

3. **Wait for response** and read key points aloud:
   - What the test is checking
   - What might be causing the failure
   - Where to look in the codebase

**Teaching Points**:
- Using `@workspace` scope for codebase-wide analysis
- How Copilot understands test naming conventions
- Copilot's ability to infer intent from test names

### Segment 2B: Investigating the Implementation (5 minutes)
**Objective**: Use Copilot to navigate to relevant code.

**Actions**:
1. In Copilot Chat, follow up with:
```
Show me the StudentsController Index action implementation and the PaginatedList class
```

2. **Review the code snippets** Copilot provides
3. Click on file references to jump to the actual code

**Script**:
> "Notice how Copilot not only found the relevant code but also provided context about how pagination should work. This saves us from manually searching through files."

### Segment 2C: Understanding the Root Cause (5 minutes)
**Objective**: Deep dive into the specific issue.

**Actions**:
1. Open `PaginatedList.cs` 
2. Ask Copilot:
```
In PaginatedList.cs, what might cause the PageIndex or TotalPages properties to return incorrect values in a unit test scenario?
```

3. **Discuss Copilot's analysis** of:
   - Property calculations
   - Potential edge cases
   - Test data setup issues

**Teaching Points**:
- Copilot can reason about code logic
- It considers testing scenarios specifically
- Helps identify edge cases

---

## Part 3: Custom Instructions & Domain Expertise (15 minutes)

### Segment 3A: Introducing Custom Instructions (3 minutes)
**Objective**: Explain the power of repository-specific guidance.

**Script**:
> "GitHub Copilot can be guided by custom instructions specific to your repository. Let's look at what we've configured for this project."

**Actions**:
1. Navigate to `.github/instructions/dotnet-architecture-best-practices.instructions.md`
2. Scroll through and highlight:
   - DDD principles
   - SOLID principles
   - Testing standards (especially `MethodName_Condition_ExpectedResult` naming)
   - Financial domain considerations

**Teaching Points**:
- Custom instructions ensure consistency
- They enforce architectural patterns
- They capture domain knowledge

### Segment 3B: Fixing the Test with DDD Guidance (12 minutes)
**Objective**: Use Copilot to fix the test while adhering to project standards.

**Actions**:
1. In Copilot Chat, ask:
```
@workspace Fix the StudentsControllerTests.Index_ReturnsViewWithPaginatedList test failure. 
Make sure the fix follows our DDD best practices and SOLID principles from the custom instructions.
```

2. **Review Copilot's proposed fix**:
   - Does it follow the `MethodName_Condition_ExpectedResult` naming?
   - Does it respect domain boundaries?
   - Is the fix minimal and surgical?

3. **Apply the fix** (either accept Copilot's suggestion or implement it manually while discussing)

4. **Run the test again**:
```powershell
dotnet test .\ContosoUniversity.sln -c Debug --filter FullyQualifiedName~StudentsControllerTests.Index_ReturnsViewWithPaginatedList
```

5. **Verify success**

**Script**:
> "Notice how Copilot's suggestion aligned with our architectural standards. This is because it read and understood our custom instructions. In a team environment, this ensures all developers—and AI assistants—follow the same patterns."

---

## Part 4: Custom Agents & Specialized Tasks (10 minutes)

### Segment 4A: Introducing Custom Agents (3 minutes)
**Objective**: Explain when and why to use custom agents.

**Script**:
> "Sometimes you need more than general assistance. Custom agents are specialized Copilot configurations for specific tasks like code review, testing, or architecture validation."

**Actions**:
1. Navigate to `.github/agents/`
2. Show the agent configuration files we'll create:
   - `testing-agent.json` - Specialized for test creation and debugging
   - `architecture-reviewer.json` - Validates DDD/SOLID adherence

### Segment 4B: Using the Testing Agent (7 minutes)
**Objective**: Demonstrate agent-specific capabilities.

**Actions**:
1. Open Copilot Chat and select the Testing Agent (if configured)
2. Ask:
```
Analyze our test coverage for the StudentsController. Are we missing any important test cases for the pagination feature?
```

3. **Review suggestions** for additional tests:
   - Edge cases (empty result sets, single page, last page)
   - Error scenarios
   - Performance considerations

4. **Generate a new test** based on Copilot's recommendation:
```
Create a test for StudentsController.Index when requesting a page number beyond the available pages
```

5. **Show the generated test code** and explain how it follows conventions

**Teaching Points**:
- Specialized agents provide domain-specific insights
- They can identify gaps in test coverage
- Generated tests follow project conventions automatically

---

## Part 5: Model Context Protocol (MCP) Integration (10 minutes)

### Segment 5A: MCP for Playwright Testing (5 minutes)
**Objective**: Show how MCP enables Copilot to interact with external tools.

**Script**:
> "Model Context Protocol allows Copilot to interact with external tools and services. We've configured MCP to work with Playwright for end-to-end testing and documentation search."

**Actions**:
1. Navigate to `ContosoUniversity.PlaywrightTests/`
2. Show an existing Playwright test file
3. In Copilot Chat with MCP enabled, ask:
```
Using Playwright, create an E2E test that verifies the student list pagination works correctly in the browser
```

4. **Review the generated test**:
   - Proper page navigation
   - Element selection
   - Assertion strategies
   - Wait conditions

**Teaching Points**:
- MCP extends Copilot's capabilities beyond code generation
- It can generate tests for specific frameworks
- Integration with testing tools improves test quality

### Segment 5B: MCP for Documentation Search (5 minutes)
**Objective**: Demonstrate documentation-aware assistance.

**Actions**:
1. In Copilot Chat, ask:
```
Search our documentation for best practices on implementing pagination in ASP.NET Core MVC
```

2. **Show how Copilot references**:
   - README.md
   - SETUP_TESTING_GUIDE.md
   - Custom instruction files
   - Any other markdown documentation

3. Ask a follow-up:
```
Based on our documentation, what's the recommended way to handle pagination parameters in controller actions?
```

**Script**:
> "MCP allows Copilot to search and understand your project's documentation, ensuring suggestions align with your documented standards and practices."

---

## Part 6: Wrap-up & Best Practices (10 minutes)

### Segment 6A: Verify All Changes (3 minutes)
**Actions**:
1. Run full test suite:
```powershell
dotnet test .\ContosoUniversity.sln -c Debug
```

2. Show all tests passing
3. Run a quick build to ensure no compilation issues:
```powershell
dotnet build .\ContosoUniversity.sln -c Release
```

### Segment 6B: Review What We Accomplished (4 minutes)
**Script**:
> "Let's review what we achieved using GitHub Copilot today:"

**Recap**:
1. ✅ Diagnosed a failing test using Copilot Chat
2. ✅ Fixed the test following DDD/SOLID principles with custom instructions
3. ✅ Used a specialized testing agent to identify coverage gaps
4. ✅ Generated new tests with proper conventions
5. ✅ Leveraged MCP for Playwright E2E test generation
6. ✅ Used MCP to search and apply documentation standards

### Segment 6C: Best Practices & Q&A (3 minutes)
**Key Takeaways**:
1. **Start with clear prompts**: Use `@workspace`, `@file`, or agent references
2. **Leverage custom instructions**: Encode team standards and domain knowledge
3. **Use specialized agents**: For specific tasks like testing, security reviews, or architecture validation
4. **Enable MCP**: For tool integrations and documentation search
5. **Always validate**: Review and test AI-generated code
6. **Iterate**: Have a conversation with Copilot, don't expect perfection on the first try

**Questions to prompt discussion**:
- "How could you use custom instructions in your projects?"
- "What specialized agents would be valuable for your team?"
- "What external tools would you want to integrate via MCP?"

---

## Post-Demo Cleanup

```powershell
# Commit changes if desired
git add .
git commit -m "Demo: GitHub Copilot capabilities showcase"

# Or reset if this was just a demo
git checkout local-testing
git branch -D demo/copilot-capabilities
```

---

## Troubleshooting

### Test Still Failing After Fix
- Verify you're on the correct branch
- Ensure all dependencies are restored: `dotnet restore`
- Check that the fix was applied to the correct file
- Review test data setup in the test file

### Copilot Not Reading Custom Instructions
- Confirm files are in `.github/instructions/` with `.instructions.md` extension
- Reload VS Code window (Ctrl+Shift+P -> "Reload Window")
- Check file encoding (should be UTF-8)

### MCP Not Working
- Verify Playwright is installed: `cd ContosoUniversity.PlaywrightTests && npm install`
- Check MCP configuration in VS Code settings
- Ensure proper permissions for external tool access

### Agent Not Available
- Confirm agent JSON files are in `.github/agents/`
- Validate JSON syntax
- Restart VS Code
- Check that Claude Sonnet 4.5 is selected as the model

---

## Customization Tips

### Adjust Demo Length
- **45-minute version**: Skip Part 4 (Custom Agents) or Part 5B (Documentation Search)
- **30-minute version**: Skip Parts 4 and 5, focus on chat and custom instructions
- **90-minute version**: Add hands-on exercises where attendees try prompts themselves

### Make It Interactive
- Have attendees suggest prompts
- Vote on which approach to try when Copilot offers multiple solutions
- Break into pairs for the agent testing section

### Domain-Specific Adaptation
- Replace financial domain references with your industry (healthcare, retail, etc.)
- Adjust custom instructions to match your architecture patterns
- Use your own failing test scenarios

---

## Additional Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [DDD Best Practices for .NET](https://learn.microsoft.com/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
- [Playwright Testing Documentation](https://playwright.dev/)

---

## Appendix: Example Prompts Library

### For Analysis
- `@workspace Explain the architecture of this solution`
- `@workspace Find all usages of [ClassName]`
- `@workspace What design patterns are used in this codebase?`

### For Testing
- `Generate unit tests for [MethodName] covering edge cases`
- `Create integration tests for the student enrollment workflow`
- `What test cases are we missing for this controller action?`

### For Refactoring
- `Refactor this method to follow SOLID principles`
- `How can I improve the testability of this class?`
- `Suggest ways to reduce coupling in this module`

### For Documentation
- `Generate XML documentation comments for this class`
- `Create a README section explaining the pagination implementation`
- `Document the expected behavior of this domain service`

---

**Version**: 1.0  
**Last Updated**: January 2026  
**Model**: Claude Sonnet 4.5  
**Target Audience**: Developers familiar with .NET and interested in AI-assisted development
