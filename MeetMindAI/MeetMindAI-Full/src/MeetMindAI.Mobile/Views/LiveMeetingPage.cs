using Microsoft.Maui.Controls.Shapes;
namespace MeetMindAI.Mobile.Views;

public sealed class LiveMeetingPage : ContentPage
{
    readonly Editor transcript = new() { Placeholder = "Your live transcript will appear here…", AutoSize = EditorAutoSizeOption.TextChanges, HeightRequest = 190, IsReadOnly = true };
    readonly Label suggestion = new() { Text = "AI will suggest a response when a question is detected.", FontSize = 16, TextColor = Color.FromArgb("#344054") };
    readonly Label listening = new() { Text = "Microphone is off", FontSize = 13, TextColor = Color.FromArgb("#667085") };
    readonly Button micButton = new() { Text = "🎙  Start Listening", HeightRequest = 56, CornerRadius = 16, BackgroundColor = Color.FromArgb("#5B5FEF"), TextColor = Colors.White };
    readonly ISpeechRecognitionService speech;

    public LiveMeetingPage()
    {
        Title = "Live Meeting";
        speech = Application.Current?.Handler?.MauiContext?.Services.GetService<ISpeechRecognitionService>() ?? new UnsupportedSpeechRecognitionService();
        speech.PartialResult += OnPartialResult;
        speech.FinalResult += OnFinalResult;
        speech.Error += OnSpeechError;
        micButton.Clicked += ToggleListening;

        var end = new Button { Text = "End Meeting", HeightRequest = 52, CornerRadius = 16, BackgroundColor = Color.FromArgb("#FEE4E2"), TextColor = Color.FromArgb("#B42318") };
        end.Clicked += async (_, _) => { await speech.StopAsync(); await Navigation.PushAsync(new SummaryPage()); };
        var useResponse = new Button { Text = "Use Suggested Response", HeightRequest = 50, CornerRadius = 14, BackgroundColor = Color.FromArgb("#EEF0FF"), TextColor = Color.FromArgb("#3F46C6") };
        useResponse.Clicked += (_, _) => DisplayAlert("Suggested response", suggestion.Text, "OK");

        Content = new ScrollView { Content = new VerticalStackLayout { Padding = 20, Spacing = 14,
            Children = {
                new HorizontalStackLayout { Children = { new Label { Text = "● LIVE", TextColor = Color.FromArgb("#D92D20"), FontAttributes = FontAttributes.Bold }, new Label { Text = "   Project Discussion", FontSize = 24, FontAttributes = FontAttributes.Bold } } },
                listening,
                new Border { StrokeShape = new RoundRectangle { CornerRadius = 18 }, Padding = 16, BackgroundColor = Colors.White, Content = transcript },
                new Label { Text = "AI RESPONSE", FontAttributes = FontAttributes.Bold, TextColor = Color.FromArgb("#5B5FEF") },
                new Border { StrokeShape = new RoundRectangle { CornerRadius = 18 }, Padding = 16, BackgroundColor = Colors.White, Content = suggestion },
                useResponse,
                micButton,
                end
            } } };
    }

    async void ToggleListening(object? sender, EventArgs e)
    {
#if ANDROID
        var status = await Permissions.RequestAsync<Permissions.Microphone>();
        if (status != PermissionStatus.Granted) { await DisplayAlert("Microphone permission", "Please allow microphone access in Android settings to use live meeting assistance.", "OK"); return; }
#endif
        if (speech.IsListening) { await speech.StopAsync(); micButton.Text = "🎙  Start Listening"; listening.Text = "Microphone is off"; }
        else if (await speech.StartAsync()) { micButton.Text = "⏹  Stop Listening"; listening.Text = "Listening for questions…"; }
    }

    void OnPartialResult(object? s, string text) => MainThread.BeginInvokeOnMainThread(() => transcript.Text = text);
    void OnFinalResult(object? s, string text) => MainThread.BeginInvokeOnMainThread(() => { transcript.Text = (transcript.Text + "\n" + text).Trim(); suggestion.Text = BuildSuggestion(text); listening.Text = "Question detected — AI suggestion ready"; });
    async void OnSpeechError(object? s, string text) => await MainThread.InvokeOnMainThreadAsync(() => DisplayAlert("Microphone", text, "OK"));
    static string BuildSuggestion(string question) => question.Contains("deadline", StringComparison.OrdinalIgnoreCase) ? "We should confirm the target date, owner, and dependencies before committing." : "Let me confirm the context and give you a clear answer.";
    protected override async void OnDisappearing() { await speech.StopAsync(); base.OnDisappearing(); }
}
