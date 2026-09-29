# MeetMind AI

Ritu Technology branded real-time meeting copilot starter.

## Mobile flow
Splash (Ritu Technology + version/build) -> Login -> Home -> Live Meeting -> microphone speech recognition -> transcript -> question detection -> AI suggestion -> meeting summary.

## Run backend
1. Install .NET 9 SDK.
2. Start PostgreSQL/Redis: `docker compose up -d`.
3. `dotnet restore MeetMindAI.sln`.
4. `dotnet run --project src/MeetMindAI.Api`.
5. Open Swagger at the displayed local URL.

## Android
Open the solution in Visual Studio with the .NET MAUI workload. Select the Android target and run. Grant microphone permission when prompted.

## Demo login
Email: demo@meetmind.ai
Password: Demo@123

## Production before Play Store
Replace demo authentication with real JWT/refresh tokens, use HTTPS, configure a production PostgreSQL instance, integrate a production speech-to-text/LLM provider, add privacy/consent flows for recording/transcription, configure signing keystore and Play App Bundle, and remove demo credentials from UI/source.
