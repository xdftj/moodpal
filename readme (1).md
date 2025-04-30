# MoodPal

MoodPal is an emotionally-aware mood tracking app that makes emotional self-awareness feel light, daily, and vibey — like talking to a friend instead of doing therapy homework.

## Features

- **Daily Mood Check-In**: Quick emoji-based mood selection with optional text notes
- **Voice Journaling**: Record audio logs that get transcribed with AI emotional analysis
- **Mood Creatures**: Each mood unlocks unique creatures that evolve over time
- **Mood History**: Track and filter your emotional journey
- **Streak Tracking**: Build consistency with a daily check-in streak counter

## Screenshots

(Placeholder for screenshots)

## Setup Instructions

### Prerequisites

1. Make sure you have Flutter installed on your machine.
   - Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) if you haven't installed it yet.
   - Run `flutter doctor` to ensure everything is set up correctly.

2. Make sure you have VS Code installed with Flutter extensions.
   - Install VS Code from [here](https://code.visualstudio.com/)
   - Open VS Code and install the Flutter extension from the marketplace

### Project Setup

1. **Clone the repository or create a new Flutter project:**

```bash
flutter create mood_pal
cd mood_pal
```

2. **Replace the project files:**
   - Delete the auto-generated files in the `lib` folder
   - Copy all the code files into their respective folders as shown in the project structure below
   - Update the `pubspec.yaml` file with the provided dependencies

3. **Create required folders:**

```bash
mkdir -p lib/models lib/providers lib/screens lib/widgets lib/constants lib/theme assets/creatures
```

4. **Install dependencies:**

```bash
flutter pub get
```

5. **For iOS development:**
   - Make sure you have Xcode installed (Mac only)
   - Run the following commands:

```bash
cd ios
pod install
cd ..
```

6. **Run the app:**

```bash
flutter run
```

## Project Structure

```
mood_pal/
├── lib/
│   ├── constants/
│   │   └── mood_constants.dart
│   ├── models/
│   │   ├── mood_entry.dart
│   │   └── mood_creature.dart
│   ├── providers/
│   │   └── mood_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── zoo_screen.dart
│   │   ├── history_screen.dart
│   │   └── settings_screen.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   ├── mood_selector.dart
│   │   ├── voice_journal.dart
│   │   ├── creature_card.dart
│   │   ├── mood_history_card.dart
│   │   └── streak_counter.dart
│   └── main.dart
├── assets/
│   └── creatures/  # Add creature images here
├── pubspec.yaml
└── README.md
```

## Adding creature images

For the app to display mood creatures properly, you need to add creature images to the `assets/creatures/` folder. Each creature should have three evolution levels with naming convention:

```
[mood_type]_lvl[level_number].png
```

Example:
- `happy_lvl1.png`
- `happy_lvl2.png`
- `happy_lvl3.png`
- `sad_lvl1.png`
- etc.

## Dependencies

The app uses the following main dependencies:

- **provider**: For state management
- **shared_preferences**: For local storage
- **google_fonts**: For custom fonts
- **record** and **flutter_sound**: For audio recording and playback
- **intl**: For date formatting
- **path_provider**: For file management

## Next Steps

This is the MVP (Minimum Viable Product) version of MoodPal. Future enhancements could include:

1. Implement actual AI emotion analysis integration
2. Add notification system for daily reminders
3. Create more sophisticated creature evolution mechanics
4. Add data visualization for mood patterns
5. Implement cloud backup and sync
6. Add social features like anonymous mood matching

## License

This project is licensed under the MIT License - see the LICENSE file for details.
