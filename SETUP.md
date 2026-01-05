# Setup Guide

## Quick Start

1. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

2. **Get Google Maps API Key**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing
   - Enable "Maps SDK for Android", "Maps SDK for iOS", and "Maps JavaScript API"
   - Create credentials (API Key)
   - Restrict the API key for security (recommended)

3. **Configure API Key**

   **Android:**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

   **iOS:**
   - Open `ios/Runner/AppDelegate.swift`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

   **Web:**
   - Open `web/index.html`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key

4. **Run the App**
   ```bash
   flutter run
   ```

## Platform-Specific Setup

### Android
- Minimum SDK: 21
- Target SDK: 33+
- Ensure location permissions are granted

### iOS
- Minimum iOS: 12.0
- Add location permissions in Info.plist (already configured)
- Run `pod install` in `ios/` directory if needed

### Web
- Ensure Google Maps JavaScript API is enabled
- API key must have web domain restrictions configured

## Testing

### Demo Credentials
- Use any email and password for login (mock authentication)
- Example: `test@example.com` / `password123`

### Features to Test
1. **Authentication**: Login with any credentials
2. **Create Booking**: 
   - Select pickup and drop locations on map
   - Choose date and time
   - Add optional notes
3. **View Bookings**: See all bookings in history
4. **Filter Bookings**: Filter by status (Pending, Accepted, On The Way, Completed)
5. **Update Status**: Change booking status from details page
6. **Live Tracking**: Start tracking to see simulated marker movement

## Troubleshooting

### Maps Not Showing
- Verify API key is correctly set in all platform files
- Check API key restrictions in Google Cloud Console
- Ensure billing is enabled for Google Cloud project
- Check console for API key errors

### Location Not Working
- Grant location permissions on device
- For iOS, check Info.plist permissions
- For Android, check AndroidManifest.xml permissions

### Build Errors
- Run `flutter clean`
- Run `flutter pub get`
- For iOS: `cd ios && pod install && cd ..`
- For Android: Invalidate caches in Android Studio

## Next Steps

1. Replace mock authentication with real API
2. Connect to real backend services
3. Add push notifications
4. Implement offline support
5. Add user profile management

