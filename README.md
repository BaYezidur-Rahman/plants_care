# PlantCare Pro 🌿

PlantCare Pro is a premium gardening companion app designed for Bangladesh and South Asia. It features AI plant identification, automated care routines, compost tracking, and a gamified experience to help you grow a healthy garden.

## ✨ Features
- **AI Expert (Pata):** Chat with an AI botanist and identify plants/diseases.
- **Smart Garden:** Track plants with real-time health stats and age calculation.
- **Automated Routines:** AI-generated care schedules with local weather integration.
- **Compost Tracker:** Scientific composting with real-time countdowns.
- **Gamification:** Earn 15 unique badges and maintain daily streaks.
- **Data Safety:** Backup and restore your garden data via Google Drive.

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (Latest Stable)
- Android Studio / Xcode
- A Google AI Studio (Gemini) API Key

### 2. Configuration
The app uses Google Gemini for AI features. You must provide your API key during build:

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY_HERE
```

### 3. Required Assets
The app uses Lottie animations for a premium feel. Please ensure these files are in `assets/lottie/`:
- `weather_sunny.json`
- `weather_rainy.json`
- `weather_cloudy.json`
- `weather_night.json`
- `confetti.json`
- `loading_plant.json`

Download these from [LottieFiles.com](https://lottiefiles.com/).

### 4. Build Instructions
To generate reactive models and adapters, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📱 Platform Support
- **Android:** Permissions for Camera, Location, Storage, and Exact Alarms configured.
- **iOS:** Localized permission descriptions for privacy.

## 🛠 Tech Stack
- **Framework:** Flutter (GetX)
- **Database:** Hive (Local Persistence)
- **AI:** Google Generative AI (Gemini)
- **Styling:** Vanilla CSS-inspired Flutter UI, Iconsax, Flutter Animate

---
Developed with ❤️ by BAYZID
