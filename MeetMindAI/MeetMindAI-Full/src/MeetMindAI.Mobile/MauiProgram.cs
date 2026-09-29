using CommunityToolkit.Maui;
using Microsoft.Extensions.Logging;
namespace MeetMindAI.Mobile;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder.UseMauiApp<App>()
                .UseMauiCommunityToolkit()
            .ConfigureFonts(fonts => fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular"));
#if ANDROID
        builder.Services.AddSingleton<ISpeechRecognitionService, AndroidSpeechRecognitionService>();
#else
        builder.Services.AddSingleton<ISpeechRecognitionService, UnsupportedSpeechRecognitionService>();
#endif
#if DEBUG
#endif
        return builder.Build();
    }
}

public sealed class UnsupportedSpeechRecognitionService : ISpeechRecognitionService
{
    public bool IsListening => false;
    public event EventHandler<string>? PartialResult;
    public event EventHandler<string>? FinalResult;
    public event EventHandler<string>? Error;
    public Task<bool> StartAsync(CancellationToken cancellationToken = default)
    {
        Error?.Invoke(this, "Live speech recognition is currently supported on Android.");
        return Task.FromResult(false);
    }
    public Task StopAsync() => Task.CompletedTask;
}
