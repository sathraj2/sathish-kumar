using MeetMindAI.Core.Models;
using System.Net.Http.Json;

namespace MeetMindAI.Mobile.Views;

public sealed class LoginPage : ContentPage
{
    readonly Entry email = new() { Placeholder = "Email", Text = "demo@meetmind.ai", Keyboard = Keyboard.Email };
    readonly Entry password = new() { Placeholder = "Password", Text = "Demo@123", IsPassword = true };

    public LoginPage()
    {
        Title = "Sign in";
        BackgroundColor = Color.FromArgb("#F7F8FC");
        var logo = new Image { Source = "ritutechnologylogo.svg", HeightRequest = 82, WidthRequest = 82, HorizontalOptions = LayoutOptions.Center };
        var title = new Label { Text = "Welcome to MeetMind AI", FontSize = 28, FontAttributes = FontAttributes.Bold, TextColor = Color.FromArgb("#101828"), HorizontalTextAlignment = TextAlignment.Center };
        var subtitle = new Label { Text = "Your real-time meeting copilot", FontSize = 16, TextColor = Color.FromArgb("#667085"), HorizontalTextAlignment = TextAlignment.Center };
        var signIn = new Button { Text = "Sign in", HeightRequest = 54, CornerRadius = 16, BackgroundColor = Color.FromArgb("#5B5FEF"), TextColor = Colors.White, FontAttributes = FontAttributes.Bold };
        signIn.Clicked += SignInClicked;
        Content = new ScrollView { Content = new VerticalStackLayout { Padding = 28, Spacing = 16, Children = { new BoxView { HeightRequest = 36, Color = Colors.Transparent }, logo, title, subtitle, email, password, signIn, new Label { Text = "Demo account: demo@meetmind.ai", FontSize = 12, TextColor = Color.FromArgb("#667085"), HorizontalTextAlignment = TextAlignment.Center } } } };
    }

    async void SignInClicked(object? sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(email.Text) || string.IsNullOrWhiteSpace(password.Text)) { await DisplayAlert("Sign in", "Please enter email and password.", "OK"); return; }
        try
        {
            using var client = new HttpClient { BaseAddress = new Uri(DeviceInfo.Platform == DevicePlatform.Android ? "http://10.0.2.2:5000" : "http://localhost:5000") };
            var response = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest(email.Text.Trim(), password.Text));
            if (!response.IsSuccessStatusCode) { await DisplayAlert("Sign in", "Invalid email or password.", "OK"); return; }
        }
        catch
        {
            // Demo mode keeps the UI navigable when the local API is not running.
        }
        await Navigation.PushAsync(new HomePage());
    }
}
