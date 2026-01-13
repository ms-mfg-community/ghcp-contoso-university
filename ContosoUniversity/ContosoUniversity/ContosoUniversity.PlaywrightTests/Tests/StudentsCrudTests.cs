using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;
using static Microsoft.Playwright.Assertions;
using ContosoUniversity.PlaywrightTests.Infrastructure;
using NUnit.Framework;

namespace ContosoUniversity.PlaywrightTests.Tests;

public class StudentsCrudTests : PageTest
{
    private readonly WebAppFixture _app;

    public StudentsCrudTests()
    {
        _app = new WebAppFixture();
    }

    [OneTimeSetUp]
    public async Task OneTimeSetup()
    {
        await _app.InitializeAsync();
    }

    [OneTimeTearDown]
    public async Task OneTimeTeardown()
    {
        await _app.DisposeAsync();
    }

    [Test]
    public async Task CreateStudent_AsAdmin_ShouldAppearInList()
    {
        var lastName = $"E2E-{Guid.NewGuid():N}";
        var firstName = "Playwright";

        await Test.StepAsync("Sign in (development cookie auth)", async () =>
        {
            await Page.GotoAsync(new Uri(_app.BaseUri, "/Account/SignIn").ToString());
            await Expect(Page).ToHaveURLAsync(_app.BaseUri.ToString());
        });

        await Test.StepAsync("Navigate to Students index", async () =>
        {
            await Page.GotoAsync(new Uri(_app.BaseUri, "/Students").ToString());
            await Expect(Page).ToHaveURLAsync(new Uri(_app.BaseUri, "/Students").ToString());
            await Expect(Page.GetByRole(AriaRole.Heading, new() { Name = "Index" })).ToBeVisibleAsync();
        });

        await Test.StepAsync("Open Create Student", async () =>
        {
            await Page.GetByRole(AriaRole.Link, new() { Name = "Create New" }).ClickAsync();
            await Expect(Page).ToHaveURLAsync(new Uri(_app.BaseUri, "/Students/Create").ToString());
            await Expect(Page.GetByRole(AriaRole.Heading, new() { Name = "Create" })).ToBeVisibleAsync();
        });

        await Test.StepAsync("Fill and submit Create form", async () =>
        {
            await Page.GetByLabel("LastName").FillAsync(lastName);
            await Page.GetByLabel("FirstMidName").FillAsync(firstName);
            await Page.GetByLabel("EnrollmentDate").FillAsync(DateTime.Today.ToString("yyyy-MM-dd"));

            await Page.GetByRole(AriaRole.Button, new() { Name = "Create" }).ClickAsync();
        });

        await Test.StepAsync("Verify student appears in table", async () =>
        {
            await Expect(Page).ToHaveURLAsync(new Uri(_app.BaseUri, "/Students").ToString());

            var row = Page.Locator("tr", new() { HasTextString = lastName });
            await Expect(row).ToHaveCountAsync(1);
            await Expect(row).ToContainTextAsync(firstName);
        });
    }
}
