# MarkMyWords - Collaborative Note Taking App

A collaborative note-taking application built with Go backend and Flutter frontend using Clean Architecture principles.

## Project Structure

```
MarkMyWords/
├── backend/                 # Go backend server
│   ├── cmd/                # Application entry points
│   ├── internal/           # Private application code
│   ├── pkg/                # Public libraries
│   └── configs/            # Configuration files
└── frontend/               # Flutter frontend app
    └── lib/
        ├── core/           # Core functionality
        │   ├── constants/  # App constants
        │   ├── errors/     # Error handling
        │   ├── network/    # Network services
        │   ├── utils/      # Utility functions
        │   └── di/         # Dependency injection
        └── features/       # Feature modules
            ├── auth/       # Authentication feature
            ├── notes/      # Notes management feature
            └── invites/    # Collaboration invites feature
```

## Clean Architecture Implementation

### Frontend (Flutter)

The Flutter app follows Clean Architecture with the following layers:

#### Core Layer
- **Constants**: App-wide constants and configuration
- **Errors**: Failure classes for error handling
- **Network**: HTTP and WebSocket services
- **Utils**: Utility functions and helpers
- **DI**: Dependency injection using GetIt

#### Feature Layer
Each feature follows the same structure:

```
feature/
├── data/                   # Data layer
│   ├── datasources/        # Remote and local data sources
│   ├── models/            # Data models (JSON serializable)
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic use cases
└── presentation/          # Presentation layer
    ├── bloc/              # BLoC state management
    ├── pages/             # Screen widgets
    └── widgets/           # Reusable UI components
```

#### State Management
- **BLoC Pattern**: Each feature has its own BLoC for state management
- **Events**: User actions and system events
- **States**: UI states and data states
- **Cubits**: Simple state management for basic features

#### Key Features

1. **Authentication Feature**
   - Login/Register functionality
   - JWT token management
   - User session persistence

2. **Notes Feature**
   - Create, read, update, delete notes
   - Private and collaborative notes
   - Real-time collaboration via WebSocket
   - Markdown support

3. **Invites Feature**
   - Send collaboration invites
   - Accept/decline invitations
   - User search functionality

## Getting Started

### Prerequisites
- Go 1.21+
- Flutter 3.8+
- SQLite (for development)

### Backend Setup
```bash
cd backend
go mod tidy
go run cmd/server/main.go
```

### Frontend Setup
```bash
cd frontend
flutter pub get
dart run build_runner build
flutter run
```

## Architecture Benefits

1. **Separation of Concerns**: Clear boundaries between layers
2. **Testability**: Easy to unit test each layer independently
3. **Maintainability**: Well-organized code structure
4. **Scalability**: Easy to add new features
5. **Dependency Inversion**: High-level modules don't depend on low-level modules

## Dependencies

### Backend
- Gin (HTTP framework)
- GORM (ORM)
- JWT (Authentication)
- Gorilla WebSocket (Real-time communication)

### Frontend
- flutter_bloc (State management)
- dio (HTTP client)
- web_socket_channel (WebSocket)
- get_it (Dependency injection)
- json_annotation (JSON serialization)

## Development Guidelines

1. **Feature Development**: Create new features in the `features/` directory
2. **State Management**: Use BLoC for complex state, Cubit for simple state
3. **Error Handling**: Use Failure classes for consistent error handling
4. **Testing**: Write unit tests for use cases and BLoCs
5. **Code Generation**: Run `dart run build_runner build` after model changes

## License

MIT License
