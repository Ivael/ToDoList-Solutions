# BetaTask with Notes & Calendar

A modern full-stack Todo application with Vue 3 frontend and Firebase backend, featuring comprehensive task management, notes, calendar view, and real-time notifications.

## ✨ Features

### 📝 Task Management

- Create, edit, and delete todos
- Mark tasks as complete/incomplete
- Organize tasks with tags
- Set task priorities and due dates

### 📖 Notes System

- Create and manage personal notes
- Link notes to specific tasks
- Rich text content support
- Real-time synchronization

### 📅 Calendar Integration

- Calendar view for task scheduling
- Visual task organization by date
- Interactive date-based task management

### 🔔 Notifications & Reminders

- Real-time notification system
- Task reminder management
- Automated notification delivery

### 🔐 Authentication & Security

- Firebase Authentication
- Secure user registration and login
- User-specific data isolation
- Firestore security rules

### 🎨 Modern UI/UX

- Vue 3 with Composition API
- Responsive design
- Modern CSS styling
- Intuitive user interface

## 🚀 Quick Start

### Prerequisites

- Node.js (v16+) and npm installed
- Firebase project with Authentication and Firestore enabled

### 1. Firebase Setup

1. **Create a Firebase project:**

   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication (Email/Password provider)
   - Enable Firestore Database

2. **Get Firebase configuration:**

   - Go to Project Settings > General
   - Add a web app to get your config object
   - Copy the configuration values

3. **Set up Firestore security rules:**
   - Deploy the `firestore.rules` file to your Firebase project
   - Or copy the rules from the file to your Firestore Rules tab

### 2. Frontend Setup

1. **Clone and navigate to frontend:**

   ```bash
   git clone <repository_url>
   cd ToDoList-Solutions/frontend
   npm install
   ```

2. **Configure Firebase:**

   ```bash
   # Update src/firebase.js with your Firebase config
   # Replace the firebaseConfig object with your values
   ```

3. **Start development server:**
   ```bash
   npm run dev
   ```
   Frontend runs at: http://localhost:5173

### 3. Backend Setup (Optional - for reminders)

1. **Navigate to backend:**

   ```bash
   cd backend
   npm install
   ```

2. **Configure Firebase Admin:**

   ```bash
   # Add your Firebase service account key
   # Update firebase-admin.js with your configuration
   ```

3. **Start backend server:**
   ```bash
   npm start
   ```
   Backend runs at: http://localhost:3000

## 🐳 Docker Deployment

### Full Application

```bash
# Build and run both services
docker compose up --build

# Run in background
docker compose up -d --build

# Stop services
docker compose down
```

### Individual Services

#### Frontend Only

```bash
cd frontend
docker build -t todo-frontend .
docker run -p 80:80 todo-frontend
```

#### Backend Only

```bash
cd backend
docker build -t todo-backend .
docker run -p 3000:3000 todo-backend
```

## ☸️ Kubernetes Deployment

Deploy to Kubernetes cluster:

```bash
# Apply deployments and services
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
```

## 🔧 Configuration

### Firebase Configuration

Update `frontend/src/firebase.js` with your Firebase project configuration:

```javascript
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "your-app-id",
};
```

### Firestore Security Rules

The application uses comprehensive security rules (see `firestore.rules`):

- Users can only access their own data
- Authenticated users required for all operations
- Role-based access for different collections

### Environment Variables

Backend environment variables:

| Variable              | Description                         |
| --------------------- | ----------------------------------- |
| `PORT`                | Backend server port (default: 3000) |
| `FIREBASE_PROJECT_ID` | Your Firebase project ID            |

## 📁 Project Structure

```
ToDoList-Solutions/
├── frontend/                    # Vue 3 frontend
│   ├── src/
│   │   ├── components/         # Vue components
│   │   │   ├── AddTodoModal.vue
│   │   │   ├── CalendarPage.vue
│   │   │   ├── DashboardPage.vue
│   │   │   ├── Notes.vue
│   │   │   ├── NotificationCenter.vue
│   │   │   ├── ReminderModal.vue
│   │   │   ├── TagsManager.vue
│   │   │   └── TodoItem.vue
│   │   ├── composables/        # Vue composables
│   │   │   ├── useAuth.js
│   │   │   └── useNotifications.js
│   │   ├── services/           # API services
│   │   └── firebase.js         # Firebase configuration
├── backend/                     # Node.js backend (optional)
│   ├── routes/                 # API routes
│   │   ├── auth.js
│   │   └── reminders.js
│   ├── middleware/             # Authentication middleware
│   ├── tests/                  # Test files
│   └── server.js               # Entry point
├── Infra/                      # Terraform infrastructure
│   ├── environments/dev/       # Development environment
│   └── modules/                # Terraform modules
├── firestore.rules             # Firestore security rules
├── docker-compose.yml          # Multi-service setup
├── *-deployment.yaml           # Kubernetes deployments
└── *-service.yaml              # Kubernetes services
```

## 🏗️ Architecture & Design

### Frontend

- **Framework:** Vue 3 with Composition API
- **Build Tool:** Vite for fast development
- **Authentication:** Firebase Authentication
- **Database:** Firestore for real-time data
- **State Management:** Vue composables
- **Styling:** Modern CSS with responsive design

### Backend (Optional)

- **Framework:** Express.js for reminder API
- **Authentication:** Firebase Admin SDK
- **Integration:** Firebase Firestore
- **Purpose:** Advanced features like automated reminders

### Security Features

- Firebase Authentication with email/password
- Firestore security rules for data protection
- User-specific data isolation
- Real-time permission validation

### Real-time Features

- Live task updates across devices
- Real-time notifications
- Instant data synchronization
- Collaborative capabilities ready

## 🔗 Main Features

### Task Management

- ✅ Create, edit, delete todos
- 🏷️ Tag-based organization
- 📅 Due date management
- ⭐ Priority levels

### Notes System

- 📝 Rich text notes
- 🔗 Task linking
- 🔄 Real-time sync
- 👤 User-specific content

### Calendar View

- 📅 Monthly/weekly views
- 📍 Task positioning by date
- 🎯 Visual task management
- 📊 Progress tracking

### Notifications

- 🔔 Real-time alerts
- ⏰ Reminder system
- 📱 Cross-device sync
- 🎛️ Customizable settings

## 🧪 Testing

Run frontend tests:

```bash
cd frontend
npm run test
```

Run backend tests:

```bash
cd backend
npm test
```

## 🚀 Deployment

### Firebase Hosting (Frontend)

```bash
cd frontend
npm run build
firebase deploy
```

### Cloud Run (Backend)

```bash
cd backend
gcloud run deploy todo-backend --source .
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`npm test`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🆘 Troubleshooting

### Common Issues

1. **Permission denied errors:**

   - Ensure Firestore rules are properly deployed
   - Verify user authentication status
   - Check that `userId` is correctly set in document data

2. **Firebase configuration errors:**

   - Verify all Firebase config values are correct
   - Ensure Firebase project has Authentication and Firestore enabled
   - Check that the web app is properly configured in Firebase

3. **Build/deployment issues:**
   - Clear node_modules and reinstall dependencies
   - Verify Node.js version compatibility (v16+)
   - Check environment variables and configuration files

### Support

For additional support:

- Check the [Issues](https://github.com/your-repo/issues) section
- Review Firebase documentation
- Consult Vue 3 documentation for frontend issues
