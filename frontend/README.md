# MarkMyWords Frontend

A Flutter mobile application for collaborative note-taking with real-time updates.

## Features

- **User Authentication**: Secure login and registration
- **Note Management**: Create, edit, and delete notes
- **Real-time Collaboration**: Live editing with multiple users
- **Markdown Support**: Rich text formatting and code snippets
- **User Invitations**: Send and manage collaboration invites
- **Offline Support**: Work on private notes without internet

## Prerequisites

- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for iOS development) or Android Emulator

## Setup

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate model files** (if using JSON serialization):
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
frontend/
├── lib/
│   ├── models/           # Data models
│   ├── providers/        # State management
│   ├── screens/          # UI screens
│   ├── services/         # API and WebSocket services
│   └── main.dart         # App entry point
├── assets/               # Images and other assets
├── pubspec.yaml          # Dependencies
└── README.md             # This file
```

## Configuration

### API Configuration
Update the API base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://localhost:8080/api';
```

### WebSocket Configuration
Update the WebSocket URL in `lib/services/websocket_service.dart`:

```dart
final wsUrl = 'ws://localhost:8080/ws?user_id=$userId';
```

## Development

### Running on Different Platforms

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

### Building for Production

**Android APK:**
```bash
flutter build apk
```

**iOS:**
```bash
flutter build ios
```

**Web:**
```bash
flutter build web
```

## State Management

The app uses the Provider pattern for state management:

- **AuthProvider**: Handles user authentication state
- **NoteProvider**: Manages notes and real-time updates

## Real-time Features

### WebSocket Events
- `note:join` - Join a note's real-time session
- `note:leave` - Leave a note's real-time session
- `note:update` - Real-time note content updates
- `note:user_typing` - User typing indicators

### Collaboration Flow
1. User creates a collaborative note
2. User invites others via email/username
3. Invited users accept/decline invitations
4. Accepted users can edit the note in real-time
5. Changes are synchronized across all connected users

## UI Components

### Screens
- **LoginScreen**: User authentication
- **HomeScreen**: Note list and navigation
- **NoteEditorScreen**: Create and edit notes
- **InvitesScreen**: Manage collaboration invitations

### Features
- Material Design 3 theme
- Responsive layout
- Dark/light mode support (planned)
- Offline-first architecture

## Dependencies

### Core Dependencies
- `flutter`: UI framework
- `provider`: State management
- `dio`: HTTP client
- `web_socket_channel`: Real-time communication
- `shared_preferences`: Local storage
- `flutter_markdown`: Markdown rendering
- `flutter_quill`: Rich text editor

### Development Dependencies
- `flutter_test`: Testing framework
- `flutter_lints`: Code linting
- `build_runner`: Code generation
- `json_serializable`: JSON serialization

## Testing

Run tests:
```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Dependencies not found**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build errors**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **WebSocket connection issues**:
   - Ensure the backend server is running
   - Check the WebSocket URL configuration
   - Verify network connectivity

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License
