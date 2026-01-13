using System.Diagnostics;
using System.Net;
using Microsoft.Extensions.Configuration;

namespace ContosoUniversity.PlaywrightTests.Infrastructure;

public sealed class WebAppFixture : IAsyncLifetime
{
    private Process? _process;

    public Uri BaseUri { get; private set; } = new("http://127.0.0.1:5055");

    public async Task InitializeAsync()
    {
        var config = new ConfigurationBuilder()
            .AddJsonFile(Path.Combine(AppContext.BaseDirectory, "playwrightSettings.json"), optional: true)
            .AddEnvironmentVariables(prefix: "CONTOSO_E2E_")
            .Build();

        var baseUrl = config["BaseUrl"];
        if (!string.IsNullOrWhiteSpace(baseUrl))
        {
            BaseUri = new Uri(baseUrl);
        }

        var solutionDir = FindSolutionDirectory();
        var projectPath = Path.Combine(solutionDir, "ContosoUniversity.Web", "ContosoUniversity.Web.csproj");

        var startInfo = new ProcessStartInfo
        {
            FileName = "dotnet",
            Arguments = $"run --project \"{projectPath}\" --urls {BaseUri}",
            WorkingDirectory = solutionDir,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        _process = Process.Start(startInfo);
        if (_process is null)
        {
            throw new InvalidOperationException("Failed to start ContosoUniversity.Web process.");
        }

        await WaitForReadyAsync(BaseUri, TimeSpan.FromSeconds(30));
    }

    public Task DisposeAsync()
    {
        try
        {
            if (_process is { HasExited: false })
            {
                _process.Kill(entireProcessTree: true);
                _process.WaitForExit(5000);
            }
        }
        catch
        {
            // Best-effort cleanup
        }
        finally
        {
            _process?.Dispose();
            _process = null;
        }

        return Task.CompletedTask;
    }

    private static async Task WaitForReadyAsync(Uri baseUri, TimeSpan timeout)
    {
        using var http = new HttpClient(new HttpClientHandler { AutomaticDecompression = DecompressionMethods.All });

        var start = DateTimeOffset.UtcNow;
        while (DateTimeOffset.UtcNow - start < timeout)
        {
            try
            {
                using var response = await http.GetAsync(baseUri);
                if (response.IsSuccessStatusCode)
                {
                    return;
                }
            }
            catch
            {
                // keep polling
            }

            await Task.Delay(250);
        }

        throw new TimeoutException($"Web app did not become ready at {baseUri} within {timeout.TotalSeconds} seconds.");
    }

    private static string FindSolutionDirectory()
    {
        var dir = AppContext.BaseDirectory;
        while (!string.IsNullOrWhiteSpace(dir))
        {
            if (File.Exists(Path.Combine(dir, "ContosoUniversity.sln")))
            {
                return dir;
            }

            dir = Directory.GetParent(dir)?.FullName;
        }

        throw new DirectoryNotFoundException("Could not locate ContosoUniversity.sln from test output directory.");
    }
}
