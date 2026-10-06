# AI Business Assistant — Clean Flutter Project

This package intentionally uses **only Flutter SDK widgets**. There are no third-party packages and no generated/corrupted `all_screens.dart` file.

## Included screens

1. Splash
2. Onboarding 1
3. Onboarding 2
4. Choose Business Type
5. Register
6. OTP Verification
7. Login
8. Business Setup
9. Dashboard
10. Customers
11. Add Customer
12. Customer Details
13. Products
14. Add Product
15. Create Invoice
16. Invoice Preview
17. Expenses
18. Add Expense
19. Payments / Receivables
20. Reports
21. AI Assistant
22. Subscription
23. Settings
24. Profile & More

## Important: Android project generation

The ZIP contains the clean Flutter source and does not include generated Android/Gradle files. This avoids carrying broken platform files from the old project.

After extracting into your Codespace:

```bash
cd ai_business_assistant
flutter create --platforms=android .
flutter pub get
flutter analyze
flutter run
```

If you already have Android platform files generated, do NOT run `flutter create` again; just run:

```bash
flutter pub get
flutter analyze
flutter run
```

The application has no API/backend dependency and is safe to test as a UI prototype. API, OTP, database, AI, and persistence can be connected after the clean build is confirmed.
