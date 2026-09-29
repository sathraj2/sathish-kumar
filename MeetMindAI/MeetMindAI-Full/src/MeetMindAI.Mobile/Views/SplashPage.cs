namespace MeetMindAI.Mobile.Views;

public sealed class SplashPage : ContentPage
{
    public SplashPage()
    {
        NavigationPage.SetHasNavigationBar(this, false);
        BackgroundColor = Color.FromArgb("#101828");

        var logo = new Image
        {
            Source = "ritutechnologylogo.svg",
            HeightRequest = 110,
            WidthRequest = 110,
            HorizontalOptions = LayoutOptions.Center
        };
        var brand = new Label
        {
            Text = "Ritu Technology",
            TextColor = Colors.White,
            FontSize = 28,
            FontAttributes = FontAttributes.Bold,
            HorizontalTextAlignment = TextAlignment.Center
        };
        var product = new Label
        {
            Text = "MeetMind AI",
            TextColor = Color.FromArgb("#B8C0FF"),
            FontSize = 18,
            HorizontalTextAlignment = TextAlignment.Center
        };
        var activity = new ActivityIndicator { IsRunning = true, Color = Color.FromArgb("#7C83FF"), Scale = 0.8 };
        var version = new Label
        {
            Text = $"Version {AppInfoService.Version}  •  Build {AppInfoService.Build}",
            TextColor = Color.FromArgb("#98A2B3"),
            FontSize = 12,
            HorizontalTextAlignment = TextAlignment.Center
        };

        Content = new Grid
        {
            Padding = 32,
            Children =
            {
                new VerticalStackLayout
                {
                    Spacing = 12,
                    VerticalOptions = LayoutOptions.Center,
                    Children = { logo, brand, product, activity, version }
                }
            }
        };
    }

    protected override async void OnAppearing()
    {
        base.OnAppearing();
        await Task.Delay(1400);
        if (Navigation.NavigationStack.Count == 1)
            await Navigation.PushAsync(new LoginPage());
    }
}
