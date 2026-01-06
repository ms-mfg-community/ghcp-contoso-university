# Contoso University - GitHub Copilot Demo Repository

This repository contains the Contoso University sample application, designed to demonstrate GitHub Copilot capabilities including custom instructions, custom agents, and Model Context Protocol (MCP) integration.

## Overview

Contoso University is a university management application that showcases:
- **Domain-Driven Design (DDD)** patterns with .NET
- **SOLID principles** in practice
- **Layered architecture** (Domain/Application/Infrastructure)
- **Comprehensive testing** (Unit, Integration, E2E with Playwright)
- **AI-assisted development** workflows with GitHub Copilot

Originally built on .NET Framework 4.8, this application demonstrates modern .NET development practices and serves as a teaching platform for AI-assisted software development.

## 🎓 Demo Materials

This repository includes complete instructor materials for a **60-minute GitHub Copilot demonstration**:

- **[DEMO_INSTRUCTOR_GUIDE.md](DEMO_INSTRUCTOR_GUIDE.md)** - Complete step-by-step guide for instructors with timing, scripts, and teaching points
- **[DEMO_QUICK_REFERENCE.md](DEMO_QUICK_REFERENCE.md)** - Quick reference card for commands, prompts, and troubleshooting
- **[ContosoUniversity/README.md](ContosoUniversity/README.md)** - Application-specific setup and quickstart guide

### Demo Highlights
✅ Analyzing and fixing failing tests with Copilot Chat  
✅ Using custom instructions for DDD/SOLID compliance  
✅ Specialized agents for testing and architecture review  
✅ MCP integration with Playwright and documentation search  
✅ Real-world debugging and problem-solving scenarios  

## Quick Start

See the [ContosoUniversity README](ContosoUniversity/README.md) for detailed setup instructions.

```powershell
# Clone and navigate
git clone <repository-url>
cd ContosoUniversity

# Build and test
dotnet restore .\ContosoUniversity.sln
dotnet build .\ContosoUniversity.sln -c Debug
dotnet test .\ContosoUniversity.sln -c Debug
```

## Project Structure

- **`ContosoUniversity/`** - Main application code
  - `ContosoUniversity.Web` - ASP.NET Core MVC web application
  - `ContosoUniversity.Core` - Domain models and interfaces
  - `ContosoUniversity.Infrastructure` - Data access and infrastructure
  - `ContosoUniversity.Tests` - xUnit test project
  - `ContosoUniversity.PlaywrightTests` - End-to-end browser tests
  - `.github/` - GitHub Copilot configurations
    - `instructions/` - Custom instructions for AI guidance
    - `agents/` - Specialized agent configurations
    - `prompts/` - Reusable prompt templates

## GitHub Copilot Features Demonstrated

### 1. Custom Instructions
The `.github/instructions/` folder contains domain-specific guidance that helps Copilot:
- Follow DDD and SOLID principles
- Adhere to testing conventions (`MethodName_Condition_ExpectedResult`)
- Apply financial domain best practices
- Maintain architectural consistency

### 2. Custom Agents
Specialized agents in `.github/agents/` provide focused expertise:
- **Testing Agent** - Test creation, debugging, and coverage analysis
- **Architecture Reviewer** - DDD/SOLID validation and design review

### 3. Model Context Protocol (MCP)
MCP integration enables:
- Playwright test generation and execution
- Documentation search across markdown files
- External tool and service integration

## Prerequisites

- **Windows** (recommended)
- **.NET SDK 8.0+**
- **SQL Server LocalDB** (for local development)
- **Node.js** (for Playwright tests)
- **Visual Studio Code** with GitHub Copilot extensions
- **GitHub Copilot** license with Claude Sonnet 4.5 access

## Branches

- `main` - Production-ready code
- `local-testing` - Demo starting point with intentionally broken test
- `feature/*` - Feature development branches

## Teaching & Learning

This repository intentionally includes:
- ❌ **One failing test** - To demonstrate debugging with Copilot
- 📚 **Comprehensive documentation** - README files, guides, and inline comments
- 🏗️ **Architectural patterns** - DDD, SOLID, layered architecture examples
- 🧪 **Testing strategies** - Unit, integration, and E2E test examples

## Contributing

This is a teaching repository. Contributions that enhance the learning experience are welcome:
- Additional custom instructions for different domains
- New custom agent configurations
- Enhanced demo scenarios
- Documentation improvements

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Domain-Driven Design with .NET](https://learn.microsoft.com/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
- [Playwright Testing](https://playwright.dev/)

## License

[Your License Here]

---

**Ready to run the demo?** Start with the [DEMO_INSTRUCTOR_GUIDE.md](DEMO_INSTRUCTOR_GUIDE.md)!
