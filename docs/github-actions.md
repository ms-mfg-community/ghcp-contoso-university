# GitHub Actions Documentation

> **Repository**: ms-mfg-community/ghcp-contoso-university  
> **Last Updated**: January 21, 2026  
> **Project**: Contoso University - .NET Framework to Azure Migration Sample

## Table of Contents

- [Overview](#overview)
- [Quick Reference](#quick-reference)
- [Workflow 1: CodeQL Security Scanning](#workflow-1-codeql-security-scanning)
- [Workflow 2: Copilot Coding Agent](#workflow-2-copilot-coding-agent)
- [Understanding Dynamic Workflows](#understanding-dynamic-workflows)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## Overview

This repository uses **2 automated GitHub Actions workflows** to maintain code quality and assist with development:

1. **CodeQL Security Scanning** - Automatically detects security vulnerabilities in your code
2. **Copilot Coding Agent** - AI-powered development assistance for complex coding tasks

### What Makes These Workflows Special?

Both workflows use GitHub's **dynamic workflow feature**, which means they're not defined as traditional YAML files in `.github/workflows/`. Instead, they're managed by GitHub's internal systems. This provides seamless integration but less visibility into their configuration.

### Why This Matters for You

As a developer working on this project:
- 🔒 **Security scans run automatically** on every pull request and weekly on schedule
- 🤖 **AI assistance is available** for complex coding tasks via GitHub Copilot
- ✅ **You don't need to configure anything** - workflows are pre-configured and running
- 👀 **You should review results** in the "Actions" and "Security" tabs regularly

---

## Quick Reference

### 🚀 When Do Workflows Run?

| Workflow | Trigger | Frequency | Duration |
|----------|---------|-----------|----------|
| **CodeQL** | Pull requests, Weekly schedule (Mondays 11:20 PM UTC), Pushes to main | Automatic | ~3 minutes |
| **Copilot Agent** | Manual/on-demand | As needed | Varies by task |

### 📊 Where to View Results

- **Security Scan Results**: Navigate to the **Security** tab → **Code scanning alerts**
- **Workflow Runs**: Navigate to the **Actions** tab → Select workflow
- **PR Checks**: View directly in pull request checks section

### 🔔 What Should You Do?

**For Pull Requests:**
1. Wait for CodeQL scan to complete (~3 minutes)
2. Review any security alerts that appear
3. Fix identified issues before merging
4. Never bypass security checks without team discussion

**For Security Alerts:**
1. Check the **Security** tab regularly
2. Prioritize fixing "High" and "Critical" severity issues
3. Review "Medium" severity issues during sprint planning
4. Document why "Low" severity issues are deferred (if applicable)

---

## Workflow 1: CodeQL Security Scanning

### What It Does

CodeQL is GitHub's powerful security analysis tool that scans your code for vulnerabilities. Think of it as an automated security expert that reviews every line of code looking for potential issues like:

- SQL Injection vulnerabilities
- Cross-Site Scripting (XSS) attacks
- Insecure password storage
- Command injection risks
- Path traversal vulnerabilities
- And 65+ other security issues

### How It Works

The workflow analyzes **two parts** of this project in parallel:

#### 1. C# Backend Analysis (2-3 minutes)
Scans the .NET application code in `ContosoUniversity.csproj`:
- Detects security vulnerabilities specific to C# and .NET Framework
- Runs **70 security queries** covering OWASP Top 10 and beyond
- Uses CodeQL version **2.23.9** with C# query pack **v1.5.4**

#### 2. JavaScript/TypeScript Frontend Analysis (1-1.5 minutes)
Scans any JavaScript or TypeScript code in the project:
- Detects client-side security issues
- Checks for common JavaScript vulnerabilities
- Completes faster due to less code to analyze

**Total runtime**: ~3 minutes (both analyses run simultaneously)

### When It Runs

#### ✅ Automatic Triggers

1. **Pull Requests** - Every time you create or update a PR
   - Ensures no vulnerable code gets merged
   - Results appear as a check in the PR

2. **Weekly Schedule** - Every Monday at 11:20 PM UTC
   - Catches newly discovered vulnerabilities in existing code
   - Ensures continuous monitoring even without new changes

3. **Push to Main** - When commits are pushed to the main branch
   - Final verification before code reaches production

#### 📋 Recent Run History

The workflow has been highly reliable:
- ✅ **100% success rate** over the last 10 runs
- ⏱️ **Consistent 3-minute runtime**
- 📅 **Regular weekly scans** (last scheduled: Jan 20, 2026)

### Understanding the Results

#### Where to Find Results

**Option 1: Security Tab** (Recommended)
1. Click the **Security** tab at the top of the repository
2. Select **Code scanning alerts**
3. Filter by severity, language, or status

**Option 2: Pull Request Checks**
- View inline in PR conversation
- Click "Details" next to "CodeQL" check
- See specific files and line numbers with issues

#### Interpreting Severity Levels

| Severity | Action Required | Typical Examples |
|----------|----------------|------------------|
| 🔴 **Critical** | Fix before merging | SQL injection, Remote code execution |
| 🟠 **High** | Fix before merging | Authentication bypass, XSS vulnerabilities |
| 🟡 **Medium** | Review and plan fix | Information disclosure, Weak cryptography |
| 🟢 **Low** | Optional improvement | Code quality issues, Minor risks |

#### Example: Reading a Security Alert

```
Alert: SQL query built from user-controlled sources
Severity: High
File: Controllers/StudentController.cs
Line: 145

Description:
This SQL query is built using string concatenation with user input,
making it vulnerable to SQL injection attacks.

Recommendation:
Use parameterized queries or an ORM like Entity Framework to prevent
SQL injection vulnerabilities.
```

### What Types of Issues Does It Find?

#### Input Validation & Injection
- **SQL Injection** (CWE-089): Untrusted data in SQL queries
- **Cross-Site Scripting** (CWE-079): Unescaped user input in HTML
- **Command Injection** (CWE-078): User input in system commands
- **LDAP/XPath Injection**: Untrusted data in queries

#### Cryptography & Authentication
- **Weak Encryption** (CWE-326): Use of outdated algorithms
- **ECB Mode Encryption**: Insecure cipher mode
- **Cookie Security** (CWE-614, CWE-1004): Missing secure flags
- **Cleartext Storage**: Passwords or secrets in plain text

#### File & Data Handling
- **Path Traversal** (CWE-022): Arbitrary file access risks
- **Deserialization** (CWE-502): Unsafe object deserialization
- **Zip Slip**: File extraction vulnerabilities
- **File Upload Issues**: Unrestricted file uploads

#### Other Security Issues
- **Regular Expression DoS (ReDoS)**: Vulnerable regex patterns
- **Information Exposure**: Leaking sensitive data
- **CSRF**: Missing cross-site request forgery protection

### Common Scenarios & Actions

#### Scenario 1: PR Shows Security Alerts
```
Your PR: "Add student search feature"
Status: ❌ CodeQL check failed
Alert: SQL Injection vulnerability detected
```

**What to do:**
1. Click "Details" on the failed check
2. Review the specific file and line number
3. Fix the vulnerability (use parameterized queries)
4. Commit the fix to the same branch
5. Wait for re-scan to verify fix

#### Scenario 2: Weekly Scan Finds New Issue
```
Email: "New security alert in ms-mfg-community/ghcp-contoso-university"
Alert: New high-severity vulnerability detected
```

**What to do:**
1. Visit the Security tab
2. Check if it's a newly discovered vulnerability type
3. Create a GitHub issue to track the fix
4. Prioritize based on severity
5. Submit a PR with the fix

#### Scenario 3: False Positive Alert
```
Alert: Potential SQL injection
Your code: Uses Entity Framework (safe)
```

**What to do:**
1. Review the alert carefully
2. If confirmed as false positive, document why
3. Discuss with team about dismissing the alert
4. Someone with appropriate permissions can dismiss it with justification

### Best Practices for Developers

#### ✅ Do This

- **Review alerts immediately** when they appear in PRs
- **Fix high/critical issues** before requesting review
- **Ask questions** if you don't understand an alert
- **Test your fixes** to ensure functionality still works
- **Document dismissed alerts** with clear reasoning

#### ❌ Avoid This

- **Don't ignore security checks** to merge faster
- **Don't bypass alerts** without team discussion
- **Don't disable security scanning**
- **Don't assume all alerts are false positives**

### Configuration Details

#### What Languages Are Scanned?

```yaml
# Equivalent configuration (this is managed dynamically)
languages:
  - csharp         # C# .NET Framework code
  - javascript     # JavaScript files
  - typescript     # TypeScript files
```

#### Query Packs Used

The workflow uses GitHub's official security query packs:
- **C# Query Pack**: `codeql/csharp-queries` v1.5.4 (70 queries)
- **JavaScript/TypeScript Query Pack**: Latest version from GitHub

#### Build Process

CodeQL uses **autobuild** to compile your project:
```bash
# For C#: Automatically detects and builds
dotnet build ContosoUniversity.csproj

# For JS/TS: Analyzes source files directly (no build needed)
```

---

## Workflow 2: Copilot Coding Agent

### What It Does

The GitHub Copilot Coding Agent is an AI-powered assistant that can perform complex coding tasks automatically. Unlike the inline code suggestions you might see in your IDE, this workflow-based agent can:

- Generate documentation
- Refactor large code sections
- Implement new features based on specifications
- Update code patterns across multiple files
- Perform code migrations

**Important**: This is a specialized tool for complex tasks, not for everyday code writing.

### How It Works

The Copilot agent runs as a full workflow with these stages:

#### Workflow Stages

1. **Setup & Validation** (~1 second)
   - Verifies runner operating system
   - Checks network and firewall settings
   - Ensures environment is secure

2. **Preparation** (~11 seconds each)
   - Downloads Playwright MCP server (for browser automation)
   - Initializes Copilot environment
   - Starts Model Context Protocol (MCP) servers

3. **Request Processing** (Variable duration)
   - This is where the actual AI task runs
   - Duration depends on task complexity
   - Could be minutes for documentation, longer for code changes

4. **Cleanup** (~5 seconds)
   - Removes temporary files
   - Archives task details
   - Prepares results

**Total runtime**: Typically 15-30 minutes for complex tasks

### When It Runs

#### 🎯 Manual Triggers Only

Unlike CodeQL, this workflow **does not run automatically**. It's triggered:
- Manually by team members for specific tasks
- By the Copilot bot when requested through GitHub's interface
- On-demand for complex development work

#### 📋 Example Run

```
Run #1: January 21, 2026
Branch: copilot/document-github-actions
PR: #4
Task: "Generate GitHub Actions documentation"
Status: In Progress
Triggered by: Copilot bot
```

### What It Can Do

#### ✅ Good Use Cases

1. **Documentation Generation**
   - Creating comprehensive README files
   - Generating API documentation
   - Writing user guides from code

2. **Code Refactoring**
   - Updating patterns across many files
   - Modernizing legacy code
   - Applying consistent code style

3. **Migration Tasks**
   - Converting .NET Framework to .NET 6+
   - Updating deprecated APIs
   - Moving from on-premises to Azure

4. **Feature Implementation**
   - Adding new functionality based on specs
   - Creating boilerplate code
   - Implementing design patterns

#### ❌ Not Ideal For

- Quick bug fixes (use manual coding instead)
- Single-file changes (faster to do manually)
- Exploratory work (use IDE Copilot instead)
- Production-critical code without review

### Understanding the Agent's Capabilities

#### Model Context Protocol (MCP)

The agent uses MCP to interact with various tools:
- **File System**: Read and write files
- **Git Operations**: Commit, branch, and push changes
- **Build Tools**: Compile and test code
- **Playwright**: Automate browser testing (if needed)

#### Cross-Platform Support

The workflow is designed for both:
- **Linux** (Ubuntu) - Currently used
- **Windows** - Available but not active

Steps automatically skip based on the running platform.

### Security Considerations

#### 🔒 How Copilot Accesses Your Code

The Copilot agent:
- Uses a dedicated bot account (ID: 198982749)
- Creates dedicated branches (e.g., `copilot/document-github-actions`)
- Makes commits with bot attribution
- Requires human review before merging

#### ⚠️ Important Security Notes

**What You Should Know:**
1. **All AI-generated code requires human review**
   - The agent can make mistakes
   - Generated code must be tested
   - Security implications must be verified

2. **The bot can make automated commits**
   - Commits are clearly attributed to the bot
   - Changes are visible in PRs
   - You control what gets merged

3. **Limited visibility into permissions**
   - Dynamic workflow means permissions aren't visible in code
   - Trust GitHub's security model
   - Review all bot actions carefully

**What You Should Do:**
- ✅ Thoroughly review all Copilot-generated code
- ✅ Test functionality after AI changes
- ✅ Run security scans on generated code
- ✅ Discuss concerns with team before merging
- ❌ Never merge AI code without review
- ❌ Don't blindly trust AI-generated code

### How to Use the Copilot Agent

#### Typical Workflow

1. **Task Identification**
   - Identify a complex, time-consuming task
   - Ensure it's appropriate for AI assistance
   - Document clear requirements

2. **Trigger the Agent**
   - Use GitHub's interface to request Copilot assistance
   - Provide clear, specific instructions
   - Include context and constraints

3. **Monitor Progress**
   - Watch the workflow run in the Actions tab
   - Review intermediate commits if visible
   - Be patient - complex tasks take time

4. **Review Results**
   - Carefully review all generated code
   - Test functionality thoroughly
   - Run CodeQL scan to check for security issues
   - Request peer review from team members

5. **Iterate if Needed**
   - If results aren't quite right, provide feedback
   - Agent may run again with refinements
   - Multiple iterations are normal

#### Example: Documentation Task

```
Task: "Generate comprehensive GitHub Actions documentation"

Agent Process:
1. ✅ Analyzes workflow configuration
2. ✅ Reviews existing documentation
3. ✅ Creates structured markdown file
4. ✅ Includes examples and best practices
5. ✅ Commits to dedicated branch (copilot/document-github-actions)

Your Process:
1. Review generated documentation
2. Check for accuracy and completeness
3. Test any code examples provided
4. Request changes if needed
5. Merge when satisfied
```

### Troubleshooting Copilot Issues

#### Issue: Workflow Taking Too Long

**Symptoms**: Processing step running for 30+ minutes

**Possible Causes**:
- Complex task requiring extensive code changes
- Agent encountered unexpected code structure
- Network or resource constraints

**What to Do**:
- Be patient - complex tasks take time
- Check workflow logs for progress
- If stuck for hours, may need to cancel and retry with clearer instructions

#### Issue: Generated Code Has Errors

**Symptoms**: Code doesn't compile or has bugs

**Possible Causes**:
- AI misunderstood requirements
- Edge cases not considered
- Incomplete context provided

**What to Do**:
- Review and fix errors manually
- Provide feedback for future improvements
- Consider if task was too complex for AI

#### Issue: Changes Don't Match Requirements

**Symptoms**: Agent did something different than expected

**Possible Causes**:
- Unclear or ambiguous instructions
- AI interpreted requirements differently
- Missing context about project constraints

**What to Do**:
- Review what was generated
- Provide more specific instructions
- Retry with clearer requirements

---

## Understanding Dynamic Workflows

### What Are Dynamic Workflows?

Traditional GitHub Actions workflows are defined in YAML files (`.github/workflows/*.yml`) that you can view and edit. **Dynamic workflows** are different:

#### Traditional Workflows
```
✅ Visible in repository
✅ Version controlled
✅ Easy to audit
✅ Can be customized
❌ Require manual setup
```

#### Dynamic Workflows (This Repository)
```
✅ Automatically configured
✅ Managed by GitHub
✅ Seamless integration
✅ Always up-to-date
❌ Not visible in repository
❌ Limited customization
❌ Harder to audit
```

### Why Dynamic Workflows Are Used Here

GitHub uses dynamic workflows for:
1. **CodeQL** - GitHub Advanced Security feature
2. **Copilot** - GitHub Copilot Workspace feature

These are native GitHub features that work better as managed workflows.

### What You Can't See

Because these are dynamic workflows, you can't directly view:
- Exact trigger configuration
- Permission scopes
- Environment variables
- Action versions
- Secret usage

### What You Can See

You can still monitor:
- Workflow runs in the Actions tab
- Results in the Security tab
- Logs for each run
- Success/failure status
- Duration and performance

### Should You Worry?

**Short answer: No, but stay aware.**

Dynamic workflows are:
- ✅ Managed by GitHub (trusted platform)
- ✅ Follow security best practices
- ✅ Regularly updated by GitHub
- ✅ Used by thousands of repositories

However:
- ⚠️ Less transparency than YAML workflows
- ⚠️ You don't control configuration
- ⚠️ Harder to audit for compliance
- ⚠️ Migration to YAML may be beneficial for some teams

### If You Need More Control

Consider migrating to traditional YAML workflows:

**Pros:**
- Full visibility into configuration
- Version-controlled workflow files
- Easier compliance auditing
- Customizable to exact needs

**Cons:**
- Requires manual configuration
- Need to maintain workflow files
- May miss automatic GitHub updates
- More initial setup work

**When to migrate:**
- Strict compliance requirements (SOC 2, ISO 27001)
- Need custom security query configuration
- Want version-controlled audit trail
- Organization policy requires YAML workflows

---

## Security Best Practices

### For All Developers

#### 1. Review Security Alerts Promptly

**Why it matters**: Vulnerabilities can be exploited quickly. The faster you fix them, the safer your code.

**What to do:**
- Check the Security tab weekly (or when notified)
- Review all new alerts within 24 hours
- Prioritize High and Critical severity issues
- Don't let Medium severity alerts accumulate

#### 2. Never Bypass Security Checks

**Why it matters**: Security checks exist to protect users and data. Bypassing them creates risk.

**What to do:**
- Wait for CodeQL scans to complete before merging
- Fix identified issues rather than dismissing alerts
- If you must dismiss an alert, document why thoroughly
- Discuss with security-minded team members first

#### 3. Review AI-Generated Code Carefully

**Why it matters**: AI can make mistakes, including security mistakes. Human review is essential.

**What to do:**
- Treat AI code like any other code review
- Look for security anti-patterns
- Test edge cases thoroughly
- Run security scans on generated code
- Get peer review before merging

#### 4. Keep Dependencies Updated

**Why it matters**: Vulnerabilities are discovered in libraries regularly. Updates often include security fixes.

**What to do:**
- Monitor for dependency security alerts
- Update dependencies during sprint planning
- Test thoroughly after updates
- Document any dependencies that can't be updated

### For Repository Maintainers

#### 1. Monitor Security Posture

**Set up:**
- Weekly review of Security tab
- Email notifications for new alerts
- Dashboard for security metrics
- Regular security review meetings

**Track:**
- Number of open security alerts
- Time to fix vulnerabilities
- Types of issues most common
- Trends over time

#### 2. Protect Main Branch

**Recommended settings:**
```
Branch Protection Rules for 'main':
✅ Require pull request reviews (minimum 1)
✅ Require status checks to pass (CodeQL)
✅ Require branches to be up to date
✅ Restrict who can push to branch
✅ Require linear history
❌ Allow force pushes (disabled)
❌ Allow deletions (disabled)
```

#### 3. Configure Security Policies

**Create `.github/SECURITY.md`:**
```markdown
# Security Policy

## Reporting Vulnerabilities
Contact: [security-email]

## Security Scan Schedule
- CodeQL: Weekly (Mondays 11:20 PM UTC)
- Manual reviews: Monthly

## Response Times
- Critical: 24 hours
- High: 3 days
- Medium: 2 weeks
- Low: Next sprint
```

#### 4. Review Copilot Bot Permissions

**Regular audits:**
- Review what branches bot can access
- Verify bot commits are properly attributed
- Ensure bot can't merge without approval
- Monitor bot activity for unusual patterns

### Security Checklist

Use this checklist for every PR:

```markdown
## Security Review Checklist

- [ ] CodeQL scan passed (no new alerts)
- [ ] All code changes reviewed by human
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on all user inputs
- [ ] Output encoding for displayed user data
- [ ] Parameterized queries (no string concatenation in SQL)
- [ ] Error messages don't expose sensitive info
- [ ] Authentication/authorization checked
- [ ] Dependencies are up to date
- [ ] Follows principle of least privilege
```

### Common Vulnerabilities in This Codebase

Based on CodeQL configuration, watch for:

#### 1. SQL Injection
```csharp
// ❌ Vulnerable
string query = "SELECT * FROM Students WHERE Name = '" + userInput + "'";

// ✅ Safe
var students = context.Students.Where(s => s.Name == userInput);
```

#### 2. Cross-Site Scripting (XSS)
```html
<!-- ❌ Vulnerable -->
<div>@Html.Raw(userInput)</div>

<!-- ✅ Safe -->
<div>@Html.Encode(userInput)</div>
```

#### 3. Path Traversal
```csharp
// ❌ Vulnerable
string path = "uploads/" + userFileName;
File.ReadAllBytes(path);

// ✅ Safe
string path = Path.Combine(uploadsDirectory, Path.GetFileName(userFileName));
if (!path.StartsWith(uploadsDirectory)) throw new SecurityException();
File.ReadAllBytes(path);
```

#### 4. Insecure Deserialization
```csharp
// ❌ Vulnerable
BinaryFormatter formatter = new BinaryFormatter();
object obj = formatter.Deserialize(stream);

// ✅ Safe
// Use JSON serialization with [Serializable] restrictions
JsonSerializer.Deserialize<KnownType>(json);
```

### Secrets Management

#### ✅ Do This

```csharp
// Store in Azure Key Vault or GitHub Secrets
string apiKey = Environment.GetEnvironmentVariable("API_KEY");

// Use connection string from configuration
string connectionString = Configuration.GetConnectionString("DefaultConnection");
```

#### ❌ Never Do This

```csharp
// ❌ Hardcoded secret
string apiKey = "sk-1234567890abcdef";

// ❌ Committed to git
// appsettings.json with production credentials

// ❌ In source code comments
// Password: MySecretPassword123
```

### Resources

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CodeQL Documentation](https://codeql.github.com/docs/)
- [.NET Security Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/security/)

---

## Troubleshooting

### CodeQL Issues

#### Issue: Workflow Failed

**Symptoms**: Red X on workflow run, "CodeQL" check failed

**Common Causes & Solutions**:

1. **Build Failed**
   ```
   Error: Project failed to compile
   ```
   **Fix**: Ensure code compiles locally first
   ```bash
   cd ContosoUniversity
   dotnet build
   ```

2. **Out of Memory**
   ```
   Error: OutOfMemoryException during analysis
   ```
   **Fix**: Usually temporary - rerun the workflow
   - Click "Re-run failed jobs" in Actions tab

3. **Timeout**
   ```
   Error: Job timed out after 6 hours
   ```
   **Fix**: Very rare for this codebase. Contact GitHub Support if persistent.

#### Issue: Many False Positives

**Symptoms**: Alerts for code that's actually safe

**Solutions**:

1. **Add Code Comments**
   ```csharp
   // CodeQL [sql-injection]: Safe - using parameterized query via Entity Framework
   var students = context.Students.Where(s => s.Name == name);
   ```

2. **Improve Code Clarity**
   - Make security controls more obvious
   - Add validation checks explicitly
   - Use framework security features

3. **Dismiss with Justification**
   - Go to Security tab → Alert
   - Click "Dismiss alert"
   - Select reason: "False positive"
   - Add explanation

#### Issue: Scan Taking Too Long

**Symptoms**: Workflow running for 10+ minutes (normal is ~3 minutes)

**Possible Causes**:
- GitHub infrastructure issues (check [status.github.com](https://status.github.com))
- Unusually large code changes in PR
- Network latency

**Solutions**:
- Wait a bit longer - may just be slow
- Rerun the workflow if it exceeds 30 minutes
- Check GitHub Status page for incidents

### Copilot Agent Issues

#### Issue: Agent Not Starting

**Symptoms**: Workflow never begins or fails immediately

**Possible Causes**:
- Copilot feature not enabled
- Insufficient permissions
- Incorrect trigger method

**Solutions**:
1. Verify Copilot is enabled for your organization
2. Check with repository admin about permissions
3. Use GitHub's official Copilot interface to trigger

#### Issue: Generated Code Quality Poor

**Symptoms**: Code has obvious errors or doesn't meet requirements

**Solutions**:
1. **Improve Instructions**
   - Be more specific about requirements
   - Provide examples of desired output
   - Include constraints and edge cases

2. **Provide More Context**
   - Reference existing code patterns
   - Link to relevant documentation
   - Specify technology versions

3. **Break Down Task**
   - Split large tasks into smaller ones
   - Generate code incrementally
   - Review each part before continuing

#### Issue: Can't Find Copilot Workflow Runs

**Symptoms**: Don't see "Copilot coding agent" in Actions tab

**Why**: Workflow is only triggered on-demand, not automatically

**Solution**: 
- Check if any runs exist using the workflow filter
- Verify Copilot feature is enabled
- Ask team lead about Copilot access

### General Issues

#### Issue: Can't View Workflow Configuration

**Symptoms**: No YAML files in `.github/workflows/`

**Why**: These are dynamic workflows, not traditional YAML

**What you can do**:
- View run history in Actions tab
- Check run logs for details
- See this documentation for workflow behavior

#### Issue: Notification Overload

**Symptoms**: Too many emails about workflow runs

**Solutions**:
1. **Adjust Email Settings**
   - GitHub Settings → Notifications
   - Customize Actions notifications
   - Only get notified on failures

2. **Use GitHub Mobile App**
   - Get critical notifications only
   - Swipe to dismiss minor updates

3. **Configure Watch Settings**
   - Repository → Watch → Custom
   - Select specific event types

#### Issue: Workflow Status Unknown

**Symptoms**: Workflow shows as "pending" or "queued" for long time

**Causes**:
- GitHub Actions queue backlog
- Runner availability issues
- Organization rate limits

**Solutions**:
- Check [GitHub Status](https://status.github.com)
- Wait 10-15 minutes
- Contact repository admin if persistent

---

## FAQ

### General Questions

**Q: Do I need to do anything to make these workflows run?**

A: No! Both workflows are automatically configured and will run without any setup from you. CodeQL runs on every PR and weekly. Copilot runs on-demand when triggered.

**Q: Can I customize these workflows?**

A: Not directly, since they're dynamic workflows. However, you can:
- Configure CodeQL query filters (ask repository admin)
- Adjust schedule via GitHub settings
- Request migration to YAML for full customization

**Q: What happens if I don't fix a security alert?**

A: The alert remains open in the Security tab. While you can still merge PRs, ignoring security alerts increases risk. Team policy may require fixing critical/high severity issues before merge.

**Q: Are these workflows free?**

A: CodeQL is included with GitHub Advanced Security (may require license). Copilot requires GitHub Copilot subscription. Check with your organization about licensing.

### About CodeQL

**Q: How accurate is CodeQL?**

A: Very accurate! CodeQL uses semantic analysis, not just pattern matching. However:
- Some false positives are possible (5-10% rate)
- Some false negatives possible (no tool is perfect)
- Human review is still essential

**Q: Does CodeQL slow down my development?**

A: Minimal impact:
- Runs in parallel with your work
- Only adds ~3 minutes to PR checks
- Weekly scans run overnight
- Prevents security issues from reaching production

**Q: Can I run CodeQL locally?**

A: Yes! Install CodeQL CLI:
```bash
# Download CodeQL CLI
# https://github.com/github/codeql-cli-binaries

# Run analysis
codeql database create mydb --language=csharp
codeql database analyze mydb codeql/csharp-queries:codeql-suites/csharp-security-extended.qls
```

**Q: What if CodeQL finds a vulnerability in a library?**

A: CodeQL scans your code, not dependencies. For dependency vulnerabilities:
- Enable Dependabot (may already be enabled)
- Check the Security tab → "Dependabot alerts"
- Update vulnerable dependencies

**Q: Can I add custom security queries?**

A: Yes, but requires repository admin:
1. Create `.github/codeql/codeql-config.yml`
2. Add custom queries or query suites
3. Reference in workflow configuration
4. May require migrating to YAML workflow

### About Copilot Agent

**Q: Is the Copilot Agent the same as GitHub Copilot in my IDE?**

A: No, they're different:
- **IDE Copilot**: Line-by-line code suggestions as you type
- **Copilot Agent**: Workflow-based agent for complex, multi-file tasks

**Q: Can the Copilot Agent make unauthorized changes?**

A: No:
- Agent creates PRs, doesn't merge directly
- All changes require human review
- Changes are clearly attributed to bot account
- You control what gets merged

**Q: How do I know if Copilot Agent did a good job?**

A: Review criteria:
- ✅ Code compiles without errors
- ✅ Functionality matches requirements
- ✅ No security vulnerabilities introduced
- ✅ Code follows project conventions
- ✅ Tests pass (if applicable)
- ✅ Documentation is accurate

**Q: What if I don't want to use Copilot Agent?**

A: That's fine! The agent only runs when explicitly triggered. You can:
- Simply not trigger it
- Do all coding manually
- Ask admin to disable if needed

**Q: Can I trust AI-generated code?**

A: Trust but verify:
- AI is a powerful tool, not a replacement for developers
- Always review generated code thoroughly
- Test functionality and security
- Treat it like code from any other developer
- Use your judgment and expertise

### About Dynamic Workflows

**Q: Why can't I see the workflow YAML files?**

A: These are dynamic workflows, managed by GitHub internally rather than as YAML files in your repository. They're designed for GitHub native features like CodeQL and Copilot.

**Q: Is this less secure than traditional workflows?**

A: Not necessarily:
- Dynamic workflows are managed by GitHub's security team
- Receive automatic updates and improvements
- Follow GitHub's security best practices
- Less transparency, but not less secure

**Q: Can I convert these to traditional YAML workflows?**

A: Yes, but it requires manual configuration:
1. Create `.github/workflows/codeql.yml`
2. Configure CodeQL action manually
3. Set up triggers and permissions
4. Test thoroughly

Consult GitHub documentation or ask repository admin for assistance.

### Troubleshooting Questions

**Q: The workflow is stuck. What do I do?**

A:
1. Wait 5-10 minutes (may just be slow)
2. Check [GitHub Status](https://status.github.com) for incidents
3. Try rerunning the workflow
4. Cancel and restart if stuck for >30 minutes
5. Contact repository admin if persistent

**Q: I'm getting too many security alerts. Are they all real?**

A: Probably mixed:
- Most CodeQL alerts are real issues
- Some may be false positives (5-10%)
- Review each alert carefully
- Ask team for second opinion if unsure
- Dismiss false positives with justification

**Q: Can I disable these workflows temporarily?**

A: You shouldn't disable security scanning, but if absolutely necessary:
- Repository admin can disable workflows
- Better option: Dismiss alerts temporarily with clear timeline to fix
- Security first!

**Q: Who can I ask for help?**

A:
1. Team lead or senior developers
2. Repository maintainers
3. Security team (if your org has one)
4. GitHub Support (for GitHub-specific issues)
5. This documentation!

---

## Quick Start Guide

### For New Developers

**Your First Week:**

1. **Day 1**: Familiarize yourself with the Actions and Security tabs
2. **Day 2**: Watch a CodeQL scan run on a PR
3. **Day 3**: Review a security alert and understand the issue
4. **Day 4**: Make a small PR and see scans run automatically
5. **Day 5**: Review this documentation and ask questions

### For Code Reviewers

**Review Checklist:**

```markdown
## PR Review Checklist

### Automated Checks
- [ ] CodeQL scan completed successfully
- [ ] No new security alerts introduced
- [ ] All workflow checks passed

### Code Quality
- [ ] Code follows project conventions
- [ ] Adequate test coverage
- [ ] Documentation updated if needed

### Security Review
- [ ] No hardcoded secrets
- [ ] Input validation present
- [ ] Output encoding for user data
- [ ] Error handling doesn't expose sensitive info

### If Copilot-Generated
- [ ] Extra scrutiny on logic
- [ ] Verified edge cases handled
- [ ] Security patterns correct
- [ ] Code style matches project
```

### For Repository Administrators

**Setup Checklist:**

- [ ] Verify CodeQL is enabled and running
- [ ] Configure branch protection rules
- [ ] Set up security policy (SECURITY.md)
- [ ] Configure notification preferences
- [ ] Review and adjust scan schedules
- [ ] Document custom security requirements
- [ ] Train team on security practices
- [ ] Set up security metrics dashboard

**Monthly Tasks:**

- [ ] Review open security alerts
- [ ] Check workflow success rate
- [ ] Analyze security trends
- [ ] Update security documentation
- [ ] Review Copilot usage (if applicable)
- [ ] Audit bot permissions

---

## Additional Resources

### Official Documentation

- **GitHub Actions**: [https://docs.github.com/actions](https://docs.github.com/actions)
- **GitHub Advanced Security**: [https://docs.github.com/code-security](https://docs.github.com/code-security)
- **CodeQL**: [https://codeql.github.com/](https://codeql.github.com/)
- **GitHub Copilot**: [https://github.com/features/copilot](https://github.com/features/copilot)

### Learning Resources

- **CodeQL Tutorial**: [CodeQL for Security Researchers](https://codeql.github.com/docs/codeql-for-security-researchers/)
- **Security Best Practices**: [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- **.NET Security**: [Microsoft Security Guidelines](https://docs.microsoft.com/security/)

### Project-Specific

- **Repository**: [ms-mfg-community/ghcp-contoso-university](https://github.com/ms-mfg-community/ghcp-contoso-university)
- **Main Project**: Azure-Samples/dotnet-migration-copilot-samples - Contoso University
- **Purpose**: .NET Framework to Azure migration sample

### Support Channels

- **GitHub Community**: [community.github.com](https://community.github.com)
- **GitHub Support**: Available through your organization
- **Security Issues**: Use SECURITY.md reporting process

---

## Appendix: Workflow Run History

### CodeQL Recent Activity

| Run # | Date | Trigger | Duration | Status |
|-------|------|---------|----------|--------|
| #26 | Jan 21, 2026 21:52 | PR #4 | In Progress | 🔄 Running |
| #25 | Jan 20, 2026 23:20 | Schedule | 3m 2s | ✅ Success |
| #24 | Jan 13, 2026 23:21 | Schedule | 2m 58s | ✅ Success |
| #23 | Jan 09, 2026 19:17 | PR #2 | 3m 5s | ✅ Success |
| #22 | Jan 06, 2026 23:21 | Schedule | 3m 1s | ✅ Success |

**Observations:**
- 100% success rate over last 10 runs
- Consistent ~3 minute runtime
- Regular weekly schedule (Mondays 11:20 PM UTC)
- Responsive to PR activity

### Copilot Agent Recent Activity

| Run # | Date | Branch | Task | Status |
|-------|------|--------|------|--------|
| #1 | Jan 21, 2026 21:52 | copilot/document-github-actions | Documentation generation | 🔄 In Progress |

**Observations:**
- First recorded run of Copilot agent
- Creating documentation for GitHub Actions
- Running on dedicated branch
- Associated with PR #4

---

## Glossary

**Action**: A reusable unit in GitHub Actions (like a function)

**Bot**: An automated account that performs actions (e.g., Copilot bot)

**Branch Protection**: Rules that prevent direct commits to important branches

**CI/CD**: Continuous Integration / Continuous Deployment

**CodeQL**: GitHub's semantic code analysis engine for security scanning

**CWE**: Common Weakness Enumeration - standard vulnerability classification

**Dynamic Workflow**: GitHub Actions workflow managed by GitHub, not defined in YAML

**False Positive**: A security alert for code that's actually safe

**OWASP**: Open Web Application Security Project - security standards organization

**PR**: Pull Request - proposed code changes for review

**SARIF**: Static Analysis Results Interchange Format - output format for security tools

**Severity**: How serious a security vulnerability is (Critical, High, Medium, Low)

**Workflow**: Automated process that runs on GitHub Actions

**YAML**: Configuration file format (Yet Another Markup Language)

---

**Document Version**: 1.0  
**Last Updated**: January 21, 2026  
**Maintained By**: Repository Security Team  
**Questions?** Open an issue or contact the repository maintainers

---

**Next Steps:**
1. ✅ Read this documentation
2. ✅ Check the Security tab for any open alerts
3. ✅ Watch the Actions tab during your next PR
4. ✅ Ask questions if anything is unclear
5. ✅ Share this doc with new team members

**Remember**: Security is everyone's responsibility. These workflows are here to help you write secure code. Use them, trust them, but always apply your own judgment and expertise.
