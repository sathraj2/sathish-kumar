# Google Play deployment checklist

- Create a unique Android application ID.
- Create a release keystore and keep it outside GitHub.
- Build an Android App Bundle (.aab), not an APK for normal Play release.
- Add privacy policy URL and complete the Play Console Data safety form.
- Declare microphone/recording behavior clearly.
- Request microphone permission only when the user starts a meeting.
- Do not ship API keys in the APK.
- Configure HTTPS API endpoint for production.
- Test on physical Android devices and multiple screen sizes.
- Add app icon, screenshots, feature graphic and store listing copy.
