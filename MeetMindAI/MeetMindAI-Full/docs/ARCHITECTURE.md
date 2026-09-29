# MeetMind AI Architecture

Mobile client (.NET MAUI) -> ASP.NET Core API -> Application/Core -> Infrastructure -> PostgreSQL.

SignalR provides real-time meeting events. Redis is reserved for distributed caching/pub-sub when scaling the API. AI calls are isolated behind `IAiAssistant` so the provider can be changed without changing the mobile UI.

## Production roadmap
1. Replace demo authentication with ASP.NET Core Identity/JWT and refresh tokens.
2. Replace demo AI implementation with a server-side provider; never store API keys in the mobile app.
3. Add real speech-to-text and explicit microphone consent.
4. Add encryption, rate limiting, audit logs and tenant isolation.
5. Add EF Core migrations instead of `EnsureCreated`.
6. Configure HTTPS, managed PostgreSQL/Redis and Android release signing.
