namespace MeetMindAI.Mobile;

public interface ISpeechRecognitionService
{
    bool IsListening { get; }
    event EventHandler<string>? PartialResult;
    event EventHandler<string>? FinalResult;
    event EventHandler<string>? Error;
    Task<bool> StartAsync(CancellationToken cancellationToken = default);
    Task StopAsync();
}

public static class AppInfoService
{
    public static string Version => AppInfo.Current.VersionString;
    public static string Build => AppInfo.Current.BuildString;
}
