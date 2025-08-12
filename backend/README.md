# MarkMyWords Backend

A Go backend for the MarkMyWords collaborative note-taking application.

## Features

- **User Authentication**: JWT-based authentication with secure password hashing
- **Note Management**: CRUD operations for private and collaborative notes
- **Real-time Collaboration**: WebSocket-based real-time editing
- **User Invitations**: Send and manage collaboration invitations
- **Database**: SQLite for development (easily configurable for production)

## Prerequisites

- Go 1.21 or higher
- SQLite (included with Go)

## Setup

1. **Install dependencies**:
   ```bash
   go mod tidy
   ```

2. **Run database migrations**:
   ```bash
   go run cmd/migrate/main.go
   ```

3. **Start the server**:
   ```bash
   go run cmd/server/main.go
   ```

The server will start on `http://localhost:8080`

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user info (protected)

### Notes
- `GET /api/notes` - Get user's notes (protected)
- `POST /api/notes` - Create new note (protected)
- `GET /api/notes/:id` - Get specific note (protected)
- `PUT /api/notes/:id` - Update note (protected)
- `DELETE /api/notes/:id` - Delete note (protected)
- `GET /api/notes/collaborative` - Get collaborative notes (protected)

### Collaboration
- `POST /api/notes/:id/invite` - Invite user to note (protected)
- `GET /api/invites` - Get user's invites (protected)
- `POST /api/invites/:id/accept` - Accept invite (protected)
- `POST /api/invites/:id/decline` - Decline invite (protected)

### Users
- `POST /api/users/search` - Search users (protected)

### WebSocket
- `GET /ws?user_id=<id>` - WebSocket connection for real-time updates

## Project Structure

```
backend/
├── cmd/
│   ├── server/          # Main server application
│   └── migrate/         # Database migration tool
├── internal/
│   ├── handlers/        # HTTP request handlers
│   ├── middleware/      # Authentication middleware
│   ├── models/          # Data models and DTOs
│   ├── services/        # Business logic
│   └── websocket/       # WebSocket management
├── pkg/
│   ├── auth/            # JWT authentication utilities
│   ├── database/        # Database connection and setup
│   └── utils/           # Utility functions
└── go.mod               # Go module file
```

## Development

### Running Tests
```bash
go test ./...
```

### Database
The application uses SQLite for development. The database file `markmywords.db` will be created automatically when you run the server.

For production, you can easily switch to PostgreSQL or MySQL by updating the database driver in `pkg/database/database.go`.

### Environment Variables
Create a `.env` file in the backend directory for environment-specific configuration:

```env
JWT_SECRET=your-secret-key-here
DB_DRIVER=sqlite
DB_DSN=markmywords.db
PORT=8080
```

## Security Features

- JWT-based authentication
- Password hashing with bcrypt
- CORS configuration
- Input validation
- SQL injection protection via GORM

## WebSocket Events

The WebSocket connection supports the following events:

- `note:join` - Join a note's real-time session
- `note:leave` - Leave a note's real-time session
- `note:update` - Real-time note content updates
- `note:user_typing` - User typing indicators
- `note:user_joined` - User joined notification
- `note:user_left` - User left notification

## Production Deployment

1. Set environment variables
2. Use a production database (PostgreSQL/MySQL)
3. Configure proper CORS settings
4. Set up HTTPS
5. Use a process manager like PM2 or systemd
6. Configure logging and monitoring

## License

MIT License
