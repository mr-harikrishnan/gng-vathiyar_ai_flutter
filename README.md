# vathiyar_ai_flutter

A new Flutter project.


folder structure

lib/
├─ main.dart
├─ app.dart                     // Root widget (MaterialApp, routes)
│
├─ core/                        // Common code used everywhere
│  ├─ constants/
│  │  ├─ api_constants.dart    // Base URLs, endpoints
│  │  └─ app_constants.dart   // App strings, keys
│  ├─ services/
│  │  ├─ api_service.dart     // HTTP client (GET, POST, headers)
│  │  └─ cognito_service.dart// AWS Cognito login, logout, token
│  ├─ utils/
│  │  └─ validators.dart     // Email, password checks
│  └─ storage/
│     └─ secure_storage.dart // Save token, user data
│
├─ features/                  // App features (by screen / flow)
│  ├─ auth/                  // Login flow
│  │  ├─ data/
│  │  │  └─ auth_repository.dart   // Calls Cognito service
│  │  ├─ models/
│  │  │  └─ user_model.dart       // User data model
│  │  ├─ ui/
│  │  │  ├─ login_screen.dart    // Login UI
│  │  │  └─ widgets/            // Small login widgets
│  │  │     └─ login_form.dart
│  │  └─ auth_controller.dart   // State / logic for login
│  │
│  ├─ dashboard/            // After login screens
│  │  ├─ data/
│  │  │  └─ dashboard_repository.dart // Calls API service
│  │  ├─ models/
│  │  │  └─ dashboard_model.dart
│  │  ├─ ui/
│  │  │  ├─ dashboard_screen.dart
│  │  │  └─ widgets/
│  │  └─ dashboard_controller.dart
│  │
│  └─ profile/             // Example extra feature
│     ├─ data/
│     ├─ models/
│     ├─ ui/
│     └─ profile_controller.dart
│
├─ routes/
│  └─ app_routes.dart     // All named routes
│
└─ widgets/              // Global reusable widgets
   ├─ app_button.dart
   └─ app_loader.dart
