# MarkMyWords - Real-time Collaborative Note Taking App

A complete note-taking application with real-time collaboration features, built with Go backend and Flutter frontend.

## Features

- **User Authentication**: Sign up, login, and persistent sessions
- **Private Notes**: Personal notes with markdown support
- **Collaborative Notes**: Real-time shared editing with multiple users
- **User Management**: Search and invite other users to collaborate
- **Real-time Updates**: Live synchronization without page refresh
- **Code Snippets**: Support for code blocks within markdown notes

## Project Structure

```
MarkMyWords/
├── backend/          # Go backend with REST API and WebSocket
├── frontend/         # Flutter mobile app
└── README.md         # This file
```

## Quick Start

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   go mod tidy
   ```

3. Set up the database (SQLite for development):
   ```bash
   go run cmd/migrate/main.go
   ```

4. Run the server:
   ```bash
   go run cmd/server/main.go
   ```

The backend will start on `http://localhost:8080`

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Technology Stack

### Backend (Go)
- **Framework**: Gin for REST API
- **WebSocket**: Gorilla WebSocket for real-time communication
- **Database**: SQLite (development) / PostgreSQL (production)
- **Authentication**: JWT tokens
- **ORM**: GORM

### Frontend (Flutter)
- **Framework**: Flutter 3.x
- **State Management**: Provider
- **HTTP Client**: Dio
- **WebSocket**: web_socket_channel
- **Markdown**: flutter_markdown

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user

### Notes
- `GET /api/notes` - Get user's notes
- `POST /api/notes` - Create new note
- `GET /api/notes/:id` - Get specific note
- `PUT /api/notes/:id` - Update note
- `DELETE /api/notes/:id` - Delete note

### Collaboration
- `POST /api/notes/:id/invite` - Invite user to note
- `GET /api/notes/:id/collaborators` - Get note collaborators
- `POST /api/invites/:id/accept` - Accept collaboration invite
- `POST /api/invites/:id/decline` - Decline collaboration invite

### Users
- `GET /api/users/search` - Search users by name/email

## WebSocket Events

### Note Updates
- `note:join` - Join a note's real-time session
- `note:leave` - Leave a note's real-time session
- `note:update` - Real-time note content updates
- `note:user_typing` - User typing indicators

## Development

### Backend Development
- The backend uses a clean architecture pattern
- Database migrations are handled automatically
- JWT tokens are used for authentication
- WebSocket connections are managed per note session

### Frontend Development
- Provider pattern for state management
- Responsive design for mobile and tablet
- Real-time updates via WebSocket
- Offline support for private notes

## Security Features

- JWT-based authentication
- Password hashing with bcrypt
- CORS configuration
- Input validation and sanitization
- Rate limiting on API endpoints

## Database Schema

The app uses the following main tables:
- `users` - User accounts and profiles
- `notes` - Note content and metadata
- `note_collaborators` - Collaboration relationships
- `invites` - Pending collaboration invitations
- `sessions` - User sessions for real-time editing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details
