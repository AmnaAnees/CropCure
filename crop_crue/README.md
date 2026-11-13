# Crop Crue

A Flutter frontend for wheat-leaf disease detection.

## Simple project structure

```text
lib/
  main.dart
  screens/       # App pages: login, register, home, analyze, result, history, admin
  widgets/       # Reusable UI pieces, such as buttons and input fields
  models/        # Data models shared by screens
  services/      # App logic and future API/backend connections
  l10n/          # Localization and translation files
assets/
  images/
  icons/
  fonts/
```

Create the registration screen at `lib/screens/register_page.dart`. Keep each page in `screens/`; add a separate widget under `widgets/` only when you want to reuse it on multiple pages. Backend connections can be added later in `services/`.
