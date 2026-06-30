# DecoBot

DecoBot is a professional rule-based AI chatbot built with Flutter as part of an AI portfolio project from a DecodeLabs internship. It works completely offline by loading responses from a local JSON knowledge base and matching user input with deterministic rules instead of machine learning.

## Features

- Offline chatbot experience
- Local JSON knowledge base for responses
- Rule-based response engine
- Input sanitization before matching
- Exact intent matching
- Fallback response for unknown inputs
- Conversation history persistence
- History screen for reviewing saved chats
- Clear chat support
- Separate current chat and saved history
- Native launch screen with an in-app splash screen
- Background initialization for saved theme and chat state
- Dark mode and light mode support
- Material 3 user interface
- Provider-based state management
- Named route navigation
- Simple reusable chat bubbles

## Project Overview

DecoBot is built as a simple offline chat application with a guided startup flow. When the app opens, the native launch screen appears first, then the Flutter splash screen shows while app state is getting ready in the background. After that, the main chat screen loads with saved conversations and theme preferences.

The app is organized around a few core parts:

- `main.dart` starts the app and wires up providers.
- `theme_provider.dart` loads and stores the selected theme.
- `chat_provider.dart` loads responses, restores chat data, and handles message sending.
- `responses.json` holds the chatbot knowledge base.
- `screens.dart` contains the splash, chat, and history screens.

## Screenshots

### Home Screen

![Home](screenshots/home.png)

### Chat Screen

![Chat](screenshots/chat.png)

### Dark Mode

![Dark](screenshots/dark_mode.png)

### Conversation History

![History](screenshots/history.png)

## Project Structure

```text
rule_based_chat_app/
|-- assets/
|   `-- responses.json
|-- lib/
|   |-- main.dart
|   |-- models/
|   |   `-- models.dart
|   |-- providers/
|   |   |-- chat_provider.dart
|   |   `-- theme_provider.dart
|   |-- routes/
|   |   |-- app_router.dart
|   |   `-- app_routes.dart
|   |-- screens/
|   |   `-- screens.dart
|   |-- services/
|   |   `-- services.dart
|   |-- utils/
|   |   `-- utils.dart
|   `-- widgets/
|       `-- widgets.dart
|-- pubspec.yaml
`-- screenshots/
    |-- home.png
    |-- chat.png
    |-- dark_mode.png
    `-- history.png
```

## How It Works

```text
User Input
|
Sanitize Input
|
Load JSON Responses
|
Exact Match
|
Fallback Response
|
Display Reply
```

1. The user types a message in the chat screen.
2. The input is sanitized to make matching consistent.
3. The chatbot loads responses from the local `responses.json` file.
4. The service checks for an exact intent match.
5. If no match is found, a fallback response is returned.
6. The reply is displayed in the chat UI.
7. Theme and chat state continue loading in the background while the UI is already visible.

## Technologies Used

- Flutter
- Dart
- Material 3
- JSON
- Provider
- SharedPreferences
- Flutter asset loading
- Named routes

## Installation

1. Clone the repository.
2. Run `flutter pub get`.
3. Run `flutter run`.

## Future Improvements

- Fuzzy matching for typo tolerance
- Voice input
- Speech output
- Better intent matching rules
- SQLite support for larger conversation storage
- AI API integration for hybrid responses

## Author

- Name: Your Name
- GitHub: https://github.com/your-username
- LinkedIn: https://www.linkedin.com/in/your-linkedin
- Email: your.email@example.com

## License

This project is licensed under the MIT License.
