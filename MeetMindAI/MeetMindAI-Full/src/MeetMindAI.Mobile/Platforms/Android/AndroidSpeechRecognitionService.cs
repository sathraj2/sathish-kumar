using Android.OS;
#if ANDROID
using Android.Content;
using Android.Speech;
using Android.Runtime;

namespace MeetMindAI.Mobile;

public sealed class AndroidSpeechRecognitionService : Java.Lang.Object, ISpeechRecognitionService, IRecognitionListener
{
    private SpeechRecognizer? _recognizer;
    private CancellationTokenSource? _cts;
    private bool _stopping;
    public bool IsListening { get; private set; }
    public event EventHandler<string>? PartialResult;
    public event EventHandler<string>? FinalResult;
    public event EventHandler<string>? Error;

    public async Task<bool> StartAsync(CancellationToken cancellationToken = default)
    {
        if (!SpeechRecognizer.IsRecognitionAvailable(Android.App.Application.Context))
        {
            Error?.Invoke(this, "Speech recognition is not available on this device.");
            return false;
        }

        if (Android.App.Application.Context is not Android.Content.Context context)
            return false;

        _cts?.Cancel();
        _cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        _stopping = false;
        _recognizer?.Destroy();
        _recognizer = SpeechRecognizer.CreateSpeechRecognizer(context);
        _recognizer.SetRecognitionListener(this);

        var intent = new Intent(RecognizerIntent.ActionRecognizeSpeech);
        intent.PutExtra(RecognizerIntent.ExtraLanguageModel, RecognizerIntent.LanguageModelFreeForm);
        intent.PutExtra(RecognizerIntent.ExtraPartialResults, true);
        intent.PutExtra(RecognizerIntent.ExtraCallingPackage, context.PackageName);
        intent.PutExtra(RecognizerIntent.ExtraLanguage, Java.Util.Locale.Default.ToLanguageTag());
        _recognizer.StartListening(intent);
        IsListening = true;
        await Task.CompletedTask;
        return true;
    }

    public Task StopAsync()
    {
        _stopping = true;
        IsListening = false;
        _recognizer?.StopListening();
        _recognizer?.Destroy();
        _recognizer = null;
        _cts?.Cancel();
        return Task.CompletedTask;
    }

    public void OnBeginningOfSpeech() { }
    public void OnBufferReceived(byte[]? buffer) { }
    public void OnEndOfSpeech()
    {
        IsListening = false;
        if (!_stopping && _cts is { IsCancellationRequested: false })
            MainThread.BeginInvokeOnMainThread(async () => await RestartAsync());
    }
    public void OnError([GeneratedEnum] SpeechRecognizerError error)
    {
        IsListening = false;
        if (!_stopping && error is not SpeechRecognizerError.Client && error is not SpeechRecognizerError.InsufficientPermissions)
            MainThread.BeginInvokeOnMainThread(async () => await RestartAsync());
        else
            Error?.Invoke(this, $"Speech recognition error: {error}");
    }
    public void OnEvent(int eventType, Bundle? @params) { }
    public void OnPartialResults(Bundle? partialResults)
    {
        var text = ReadText(partialResults);
        if (!string.IsNullOrWhiteSpace(text)) PartialResult?.Invoke(this, text);
    }
    public void OnReadyForSpeech(Bundle? @params) { IsListening = true; }
    public void OnResults(Bundle? results)
    {
        var text = ReadText(results);
        if (!string.IsNullOrWhiteSpace(text)) FinalResult?.Invoke(this, text);
        IsListening = false;
        if (!_stopping && _cts is { IsCancellationRequested: false })
            MainThread.BeginInvokeOnMainThread(async () => await RestartAsync());
    }
    public void OnRmsChanged(float rmsdB) { }

    private async Task RestartAsync()
    {
        if (_stopping || _cts?.IsCancellationRequested == true) return;
        await Task.Delay(150);
        if (!_stopping && _cts?.IsCancellationRequested == false)
            await StartAsync(_cts.Token);
    }

    private static string ReadText(Bundle? bundle)
    {
        var matches = bundle?.GetStringArrayList(SpeechRecognizer.ResultsRecognition);
        return matches?.FirstOrDefault() ?? string.Empty;
    }

    protected override void Dispose(bool disposing)
    {
        if (disposing) _recognizer?.Destroy();
        base.Dispose(disposing);
    }
}
#endif
