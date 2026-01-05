<<<<<<< HEAD
# 📦 Booking & Tracking App

A production-ready Flutter application for booking and tracking deliveries using **Clean Architecture** principles.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🔐 Authentication
- ✅ Login screen with email and password
- ✅ Form validation (email format, password strength)
- ✅ Mock authentication service (ready for real API integration)
- ✅ Session management

### 📦 Booking Module
- ✅ Create new bookings with:
  - 📍 Pickup location (Google Maps with address geocoding)
  - 📍 Drop location (Google Maps with address geocoding)
  - 📅 Date & time selection
  - 📝 Optional notes
- ✅ View booking history
- ✅ Filter bookings by status
- ✅ View detailed booking information
- ✅ Update booking status (Pending → Accepted → On The Way → Completed)

### 📍 Live Tracking Module
- ✅ Real-time location tracking on Google Maps
- ✅ Marker movement simulation
- ✅ Polyline route visualization between pickup & drop
- ✅ Auto camera movement following the marker
- ✅ Visual distinction between traveled path and remaining route

### 📊 Status Management
- ✅ Four status levels with color coding:
  - 🟠 Pending
  - 🔵 Accepted
  - 🟣 On The Way
  - 🟢 Completed
- ✅ Status change with UI updates
- ✅ Status filtering

## 🏗️ Architecture

The app follows **Clean Architecture** with clear separation of concerns:

```
lib/
 ├── core/                    # Core functionality
 │    ├── constants/          # App constants, colors, strings
 │    ├── utils/              # Utility functions (validators, formatters)
 │    ├── widgets/            # Reusable UI components
 │    ├── services/           # Core services (storage, etc.)
 │    └── di/                 # Dependency injection
 │
 ├── features/                # Feature modules
 │    ├── auth/               # Authentication
 │    │    ├── data/          # Data layer
 │    │    ├── domain/        # Domain layer
 │    │    └── presentation/  # Presentation layer
 │    │
 │    ├── booking/            # Booking management
 │    │    ├── data/
 │    │    ├── domain/
 │    │    └── presentation/
 │    │
 │    ├── tracking/           # Live tracking
 │    │    └── presentation/
 │    │
 │    └── home/               # Home screen
 │         └── presentation/
 │
 └── main.dart               # App entry point
```

## 🎯 State Management

Uses **Bloc/Cubit** pattern:
- `AuthBloc` - Authentication state management
- `BookingBloc` - Booking operations (CRUD)
- `TrackingBloc` - Live tracking state

## 📦 Dependencies

### Core
- `flutter_bloc` - State management
- `equatable` - Value equality
- `get_it` - Dependency injection
- `go_router` - Navigation

### Maps & Location
- `google_maps_flutter` - Google Maps integration
- `geolocator` - Location services
- `geocoding` - Reverse geocoding (lat/long to address)

### Storage
- `shared_preferences` - Local storage
- `hive` - NoSQL database

### Utilities
- `intl` - Internationalization & date formatting
- `uuid` - Unique ID generation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Google Maps API Key ([Get one here](https://console.cloud.google.com/))

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/ds95745/booking-tracking-app.git
cd booking-tracking-app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Set up Google Maps API Key:**

   **For Android:**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

   **For iOS:**
   - Open `ios/Runner/AppDelegate.swift`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

   **For Web:**
   - Open `web/index.html`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

4. **Run the app:**
```bash
flutter run
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (12.0+)
- ✅ **Web**

## 🎨 UI/UX Features

- 🎨 Modern Material Design 3
- 📱 Responsive layout (mobile, tablet, web)
- 🔄 Loading states
- ⚠️ Error handling
- ✅ Form validation
- 🎯 Empty states
- 🌈 Color-coded status indicators

## 📸 Screenshots

> **Note**: Screenshots add karne ke liye `HOW_TO_ADD_SCREENSHOTS.md` file check karein.

### Login Screen
![Login Screen](https://via.placeholder.com/400x800/2196F3/FFFFFF?text=Login+Screen)
- Clean login interface with form validation
- Email and password fields
- Demo mode indicator

### Home Screen
![Home Screen](https://via.placeholder.com/400x800/4CAF50/FFFFFF?text=Home+Screen)
- Welcome card with gradient
- Quick action buttons
- Navigation drawer

### Create Booking
![Create Booking](https://via.placeholder.com/400x800/FF9800/FFFFFF?text=Create+Booking)
- Interactive Google Maps location picker
- Real-time address geocoding
- Date & time picker
- Notes field

### Location Picker
![Location Picker](https://via.placeholder.com/400x800/9C27B0/FFFFFF?text=Location+Picker)
- Google Maps integration
- Address geocoding
- Draggable markers

### Booking History
![Booking History](https://via.placeholder.com/400x800/2196F3/FFFFFF?text=Booking+History)
- List view with all bookings
- Status filters
- Color-coded status chips
- Floating action button

### Booking Details
![Booking Details](https://via.placeholder.com/400x800/4CAF50/FFFFFF?text=Booking+Details)
- Map preview with route
- Complete booking information
- Status change button
- Start tracking button

### Live Tracking
![Live Tracking](https://via.placeholder.com/400x800/FF9800/FFFFFF?text=Live+Tracking)
- Real-time marker movement
- Route visualization
- Traveled path vs remaining route
- Auto camera following

### Status Management
![Status Change](https://via.placeholder.com/400x800/9C27B0/FFFFFF?text=Status+Change)
- Status change dialog
- Color-coded status indicators
- Status flow visualization

---

**Screenshots add karne ke liye:**
1. App run karo aur screenshots lein
2. Screenshots ko `screenshots/` folder mein add karo
3. Files ko git mein add karo: `git add screenshots/*.png`
4. Commit aur push karo

## 🔧 Code Quality

- ✅ Clean Architecture
- ✅ SOLID principles
- ✅ Proper error handling
- ✅ Loading states
- ✅ Form validation
- ✅ Responsive design
- ✅ No hardcoded values
- ✅ Reusable widgets

## 📝 Project Structure

### Core Layer
- **Constants**: App-wide constants, colors, strings
- **Utils**: Validators, date formatters
- **Widgets**: Reusable UI components
- **Services**: Core services (storage)
- **DI**: Dependency injection setup

### Feature Layer
Each feature follows Clean Architecture:
- **Data Layer**: Models, data sources, repository implementations
- **Domain Layer**: Entities, use cases, repository interfaces
- **Presentation Layer**: UI pages, BLoC/Cubit

## 🔮 Future Enhancements

- [ ] Real API integration
- [ ] Push notifications
- [ ] Offline support
- [ ] Real-time updates via WebSocket
- [ ] User profile management
- [ ] Payment integration
- [ ] Rating and reviews
- [ ] Multi-language support
- [ ] Dark mode

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**ds95745@gmail.com**

- GitHub: [@ds95745](https://github.com/ds95745)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps for location services
- All open-source contributors

---

⭐ If you like this project, please give it a star!

Built with ❤️ using Flutter and Clean Architecture
=======
# booking-tracking-app
A Flutter Booking &amp; Tracking app with Google Maps, status flow, booking history, and mock API using clean architecture.
>>>>>>> 95b0d114e69b9828acd91c80a94e03d3b49651e7
